# Logging and Tracing

TUI apps cannot log to stdout — it's the rendering surface. All logging must go to files or external sinks.

## Table of Contents

1. [Setup](#setup)
2. [Initialization Patterns](#initialization-patterns)
3. [Using Tracing](#using-tracing)
4. [Opt-In Logging](#opt-in-logging)
5. [Advanced Patterns](#advanced-patterns)

---

## Setup

Use the `tracing` ecosystem. It's what the official ratatui docs recommend, what most production ratatui apps use (yazi, trippy, rainfrog), and what the broader Rust async ecosystem has standardized on.

Install the latest versions of:
- `tracing` — core instrumentation
- `tracing-subscriber` (with `env-filter` feature) — formatting, filtering, file output
- `tracing-appender` — non-blocking file writes
- `tracing-error` (optional) — integrates with color-eyre for span traces in error reports

---

## Initialization Patterns

### Simple: blocking file writer

Good enough for most apps. Logs synchronously to a file:

```rust
use tracing_subscriber::{fmt, EnvFilter};

pub fn init_logging() -> color_eyre::Result<()> {
    let log_dir = get_data_dir(); // your config/data directory
    std::fs::create_dir_all(&log_dir)?;
    let log_file = std::fs::File::create(log_dir.join("app.log"))?;

    tracing_subscriber::fmt()
        .with_writer(log_file)
        .with_env_filter(EnvFilter::from_default_env()) // respects RUST_LOG
        .with_target(false)
        .with_ansi(false) // no ANSI codes in log files
        .init();

    Ok(())
}
```

### Non-blocking: async file writer

Better for apps where logging shouldn't block the render loop. Uses `tracing-appender` for async writes. The `WorkerGuard` must be held alive — dropping it flushes and stops the writer:

```rust
use tracing_appender::non_blocking;
use tracing_subscriber::EnvFilter;

pub fn init_logging() -> color_eyre::Result<non_blocking::WorkerGuard> {
    let log_file = std::fs::File::create("app.log")?;
    let (non_blocking, guard) = non_blocking(log_file);

    tracing_subscriber::fmt()
        .with_writer(non_blocking)
        .with_env_filter(
            EnvFilter::builder()
                .with_default_directive(tracing::Level::DEBUG.into())
                .from_env_lossy(),
        )
        .with_ansi(false)
        .init();

    Ok(guard) // caller must hold this
}

fn main() -> color_eyre::Result<()> {
    let _guard = init_logging()?; // lives until main() exits
    // ...
}
```

### With color-eyre integration

The `tracing-error` crate adds span traces to `color-eyre` error reports, so you see which tracing spans were active when an error occurred:

```rust
use tracing_error::ErrorLayer;
use tracing_subscriber::prelude::*;

pub fn init_logging() -> color_eyre::Result<()> {
    let log_file = std::fs::File::create("app.log")?;

    let file_layer = tracing_subscriber::fmt::layer()
        .with_writer(log_file)
        .with_file(true)
        .with_line_number(true)
        .with_target(false)
        .with_ansi(false)
        .with_filter(EnvFilter::from_default_env());

    tracing_subscriber::registry()
        .with(file_layer)
        .with(ErrorLayer::default())
        .init();

    Ok(())
}
```

---

## Using Tracing

### Events (log messages)

```rust
use tracing::{trace, debug, info, warn, error};

info!("application started");
debug!(user = %username, "loading config");
warn!(retries = 3, "connection unstable");
error!(?err, "failed to fetch data"); // ?err uses Debug formatting
```

### Spans (context around operations)

Spans track the duration and context of operations. Use `#[instrument]` for automatic span creation:

```rust
use tracing::instrument;

#[instrument(skip(self))]
fn handle_key_event(&mut self, key: KeyEvent) -> color_eyre::Result<()> {
    // everything inside is automatically wrapped in a span
    // named "handle_key_event"
    debug!(?key, "processing key");
    // ...
}

#[instrument(skip(self), fields(query_len = query.len()))]
async fn execute_query(&self, query: &str) -> Result<QueryResult> {
    info!("executing query");
    // ...
}
```

### The trace_dbg! macro

A `dbg!` replacement that routes through tracing instead of stdout. Useful during development:

```rust
macro_rules! trace_dbg {
    ($val:expr) => {
        match $val {
            tmp => {
                tracing::trace!("{} = {:?}", stringify!($val), &tmp);
                tmp
            }
        }
    };
}

let result = trace_dbg!(some_computation()); // logs the value, returns it
```

---

## Opt-In Logging

Most production ratatui apps make logging opt-in to avoid creating log files users don't want. Choose one of these approaches:

### Environment variable (yazi pattern)

Only log when `RUST_LOG` is set:

```rust
pub fn init_logging() -> Option<non_blocking::WorkerGuard> {
    if std::env::var("RUST_LOG").is_err() {
        return None; // no logging unless explicitly requested
    }
    // ... initialize tracing, return guard
}
```

### CLI flag (gitui pattern)

```rust
#[derive(Parser)]
struct Args {
    /// Enable logging to file
    #[arg(short, long)]
    log: bool,

    /// Log file path
    #[arg(long, default_value = "app.log")]
    log_file: PathBuf,
}

fn main() -> color_eyre::Result<()> {
    let args = Args::parse();
    let _guard = if args.log {
        Some(init_logging(&args.log_file)?)
    } else {
        None
    };
    // ...
}
```

### Cargo feature (bottom pattern)

Zero overhead when disabled — log macros compile to nothing. Make `tracing`, `tracing-subscriber`, and `tracing-appender` optional dependencies gated behind a `logging` cargo feature:

```rust
#[cfg(feature = "logging")]
pub fn init_logging() -> tracing_appender::non_blocking::WorkerGuard {
    // ...
}

// Wrapper macros that compile to nothing when logging is disabled
#[cfg(not(feature = "logging"))]
macro_rules! info { ($($tt:tt)*) => {} }
```

---

## Advanced Patterns

### Rate-limited logging

For high-frequency events (mouse moves, frame renders), avoid log spam with a rate limiter. From bottom:

```rust
use std::sync::atomic::{AtomicU64, Ordering};
use std::time::SystemTime;

macro_rules! info_every_n_secs {
    ($n:expr, $($arg:tt)*) => {{
        static LAST: AtomicU64 = AtomicU64::new(0);
        let now = SystemTime::now()
            .duration_since(SystemTime::UNIX_EPOCH)
            .map(|d| d.as_secs())
            .unwrap_or(0);
        let last = LAST.load(Ordering::Relaxed);
        if now - last >= $n {
            LAST.store(now, Ordering::Relaxed);
            tracing::info!($($arg)*);
        }
    }};
}

// Usage: only logs at most once per 5 seconds
info_every_n_secs!(5, "current fps: {}", fps);
```

### Compile-time level filtering

Strip trace/debug logs from release builds for zero overhead. Enable these features on the `tracing` crate. Yazi uses this:

- `max_level_debug` — strips `trace!` in all builds
- `release_max_level_info` — strips `debug!` in release builds

### Chrome DevTools profiling

Generate trace files you can load in `chrome://tracing` or Perfetto for performance analysis. Install `tracing-chrome` (latest version). Trippy uses this:

```rust
use tracing_chrome::ChromeLayerBuilder;
use tracing_subscriber::prelude::*;

let (chrome_layer, guard) = ChromeLayerBuilder::new()
    .file("trace.json")
    .include_args(true)
    .build();
tracing_subscriber::registry()
    .with(chrome_layer)
    .init();
// hold guard until shutdown, then open trace.json in chrome://tracing
```

### Log file location

Use your app's data/cache directory, not the current working directory:

```rust
use directories::ProjectDirs;

fn log_path() -> PathBuf {
    ProjectDirs::from("", "", "myapp")
        .map(|dirs| dirs.data_local_dir().join("myapp.log"))
        .unwrap_or_else(|| PathBuf::from("myapp.log"))
}
```

### Telling the user where logs go

Print the log path to stderr before the TUI takes over (stderr is safe — it's not the rendering surface):

```rust
eprintln!("Logging to: {}", log_path.display());
```
