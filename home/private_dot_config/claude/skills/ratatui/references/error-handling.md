# Error Handling

TUI apps have a unique error handling constraint: if the app panics or exits abnormally without restoring the terminal, the user's shell is left in a broken state (no echo, raw mode still on, stuck in alternate screen). Every ratatui app must handle this.

## Table of Contents

1. [Setup](#setup)
2. [Panic Hooks](#panic-hooks)
3. [Terminal Restoration Safety Nets](#terminal-restoration-safety-nets)
4. [Error Type Strategy](#error-type-strategy)
5. [Surfacing Errors to Users](#surfacing-errors-to-users)
6. [Preventing Panics at Compile Time](#preventing-panics-at-compile-time)

---

## Setup

Install the latest versions of:
- `color-eyre` — enhanced error reports with span traces and backtraces. The ratatui community standard.
- `thiserror` — derive `Display` and `Error` for custom error enums in library code
- `better-panic` (optional) — prettier stack traces in debug builds
- `human-panic` (optional) — user-friendly crash reports in release builds

Initialize `color-eyre` as the very first thing in `main()`:

```rust
fn main() -> color_eyre::Result<()> {
    color_eyre::install()?;
    // ... rest of app
}
```

---

## Panic Hooks

This is non-negotiable — every ratatui app must install a panic hook that restores the terminal before printing the panic message. Without it, the panic output renders as garbage inside the alternate screen.

### The canonical pattern

Save the original hook, restore the terminal, then call the original:

```rust
use std::panic::{self, take_hook};
use crossterm::{
    execute,
    terminal::{disable_raw_mode, LeaveAlternateScreen},
};

pub fn install_panic_hook() {
    let original_hook = take_hook();
    panic::set_hook(Box::new(move |panic_info| {
        // Restore terminal first — ignore errors since we're already panicking
        let _ = disable_raw_mode();
        let _ = execute!(std::io::stdout(), LeaveAlternateScreen);
        // Then call the original hook so the panic message prints normally
        original_hook(panic_info);
    }));
}
```

Call this **before** initializing the terminal:

```rust
fn main() -> color_eyre::Result<()> {
    color_eyre::install()?;
    install_panic_hook(); // before ratatui::init()
    let terminal = ratatui::init();
    let result = App::default().run(terminal);
    ratatui::restore();
    result
}
```

### Production panic hook (rainfrog pattern)

For apps shipping to end users, use different panic handlers for debug vs release:

```rust
use std::panic::{self, take_hook};

pub fn install_panic_hook() -> color_eyre::Result<()> {
    let (panic_hook, eyre_hook) = color_eyre::config::HookBuilder::default()
        .panic_section(format!(
            "This is a bug. Consider reporting it at {}",
            env!("CARGO_PKG_REPOSITORY")
        ))
        .into_hooks();
    eyre_hook.install()?;

    panic::set_hook(Box::new(move |panic_info| {
        // Restore terminal
        let _ = disable_raw_mode();
        let _ = execute!(std::io::stdout(), LeaveAlternateScreen);

        #[cfg(not(debug_assertions))]
        {
            // Release: user-friendly crash report
            use human_panic::{handle_dump, print_msg, Metadata};
            let meta = Metadata::new(env!("CARGO_PKG_NAME"), env!("CARGO_PKG_VERSION"))
                .authors(env!("CARGO_PKG_AUTHORS").replace(':', ", "))
                .homepage(env!("CARGO_PKG_HOMEPAGE"));
            let file_path = handle_dump(&meta, panic_info);
            print_msg(file_path, &meta)
                .expect("human-panic: printing error message failed");
        }

        #[cfg(debug_assertions)]
        {
            // Debug: detailed stack trace
            better_panic::Settings::auto()
                .most_recent_first(false)
                .lineno_suffix(true)
                .verbosity(better_panic::Verbosity::Full)
                .create_panic_handler()(panic_info);
        }

        std::process::exit(1);
    }));
    Ok(())
}
```

---

## Terminal Restoration Safety Nets

The panic hook only fires on panics. You also need to handle normal error exits (where `main()` returns `Err`). Two complementary patterns:

### scopeguard::defer! (gitui pattern)

Guarantees cleanup runs even if `?` early-returns:

```rust
use scopeguard::defer;

fn main() -> color_eyre::Result<()> {
    color_eyre::install()?;
    install_panic_hook();
    let terminal = ratatui::init();

    defer! {
        ratatui::restore();
    }

    let result = App::default().run(terminal);
    result
}
```

### Drop impl on a Tui wrapper (rainfrog pattern)

Wrap the terminal in a struct that restores on drop:

```rust
pub struct Tui {
    terminal: Terminal<CrosstermBackend<Stdout>>,
}

impl Tui {
    pub fn new() -> color_eyre::Result<Self> {
        let terminal = ratatui::init();
        Ok(Self { terminal })
    }

    pub fn exit(&mut self) -> color_eyre::Result<()> {
        ratatui::restore();
        Ok(())
    }
}

impl Drop for Tui {
    fn drop(&mut self) {
        let _ = self.exit(); // safety net
    }
}
```

### Both together

The belt-and-suspenders approach for production apps:
1. **Panic hook** — restores terminal on panic
2. **`defer!` or `Drop`** — restores terminal on normal exit or error return
3. **`ratatui::restore()` explicitly** — the happy path

---

## Error Type Strategy

The dominant pattern in the ratatui ecosystem: `thiserror` for library/domain errors, `color-eyre` (or `anyhow`) at the application boundary.

### Library/domain errors with thiserror

Define typed errors for each domain in your app. These make errors matchable and meaningful:

```rust
use thiserror::Error;

#[derive(Debug, Error)]
pub enum DatabaseError {
    #[error("connection failed: {0}")]
    ConnectionFailed(String),

    #[error("query timed out after {0}s")]
    QueryTimeout(u64),

    #[error("invalid query: {0}")]
    InvalidQuery(String),

    #[error(transparent)]
    Io(#[from] std::io::Error),
}
```

For workspace crates, each crate defines its own error enum. Yazi and trippy both follow this pattern — `thiserror` enums per crate with `#[from]` conversions for underlying errors.

### Application boundary with color-eyre

At the top level (`main.rs`, `app.rs`), use `color_eyre::Result<()>`. Domain errors convert automatically via `?`:

```rust
fn main() -> color_eyre::Result<()> {
    // DatabaseError, IoError, ConfigError all convert to eyre::Report via ?
    let config = load_config()?;
    let db = connect_database(&config)?;
    run_app(db)?;
    Ok(())
}
```

### Pure thiserror (binsider pattern)

For simpler apps, a single error enum with a type alias can replace `anyhow`/`color-eyre` entirely:

```rust
#[derive(Debug, Error)]
pub enum AppError {
    #[error("IO error: {0}")]
    Io(#[from] std::io::Error),

    #[error("parse error: {0}")]
    Parse(#[from] serde_json::Error),

    #[error("terminal error: {0}")]
    Terminal(String),

    #[error("{0}")]
    Other(String),
}

pub type Result<T> = std::result::Result<T, AppError>;
```

---

## Surfacing Errors to Users

### Exit and print (most apps)

The simplest approach — let errors propagate to `main()` and print on exit:

```rust
fn main() -> color_eyre::Result<()> {
    // ... app runs ...
    // If Err, color-eyre prints a formatted error after terminal is restored
}
```

For explicit control (binsider pattern):

```rust
fn main() {
    match run() {
        Ok(_) => std::process::exit(0),
        Err(e) => {
            ratatui::restore();
            eprintln!("{e}");
            std::process::exit(1);
        }
    }
}
```

### In-TUI error display (gitui pattern)

For recoverable errors (network failures, invalid input), show them inside the TUI:

```rust
pub enum InternalEvent {
    ShowErrorMsg(String),
    // ... other events
}

// When an operation fails, push an error event
if let Err(error) = self.fetch_data() {
    self.queue.push(InternalEvent::ShowErrorMsg(error.to_string()));
}

// The error popup component displays it
fn handle_event(&mut self, event: InternalEvent) {
    if let InternalEvent::ShowErrorMsg(msg) = event {
        self.error_popup.show(msg);
    }
}
```

This is the right approach for apps where operations frequently fail in recoverable ways (git operations, database queries, network requests).

---

## Preventing Panics at Compile Time

GitUI uses clippy deny lints to catch potential panics before they happen:

```rust
// In lib.rs or main.rs
#![deny(clippy::unwrap_used)]
#![deny(clippy::panic)]
```

This forces use of `?`, `.unwrap_or()`, `.unwrap_or_default()`, or explicit `match` instead of `.unwrap()` and `panic!()`. Particularly valuable for TUI apps where an unhandled panic leaves the terminal in a broken state.

For cases where you genuinely know a value is `Some`/`Ok`, use `expect()` with a meaningful message — clippy allows it by default and it documents the invariant.
