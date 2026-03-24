# Project Setup

This guide walks through setting up a new Ratatui project — from choosing the right application pattern to scaffolding the project with real-world references.

## Step 1: Terminal Initialization

`ratatui::init()` enables raw mode, switches to the alternate screen, and returns a `DefaultTerminal`. `ratatui::restore()` reverses everything. For simple apps, `ratatui::run()` wraps both and also installs panic hooks so the terminal is always restored.

For details on what raw mode, alternate screen, and mouse capture mean, see `concepts.md` > Terminal Fundamentals.

## Step 2: Choose a Backend

Ratatui supports three terminal backends:

| Backend | Platform | Best for |
|---|---|---|
| **Crossterm** (default) | Windows, macOS, Linux | Most apps. Cross-platform, well-maintained, most community support. |
| **Termion** | Unix only | Lightweight Unix-only apps where you want minimal dependencies. |
| **Termwiz** | Unix, Windows | Apps targeting Wezterm or wanting Wezterm-specific features. |

**Recommendation**: Use **Crossterm** unless you have a specific reason not to. It's the default, the best documented, and what all the example repos use.

There is also a **TestBackend** for unit testing your UI — it renders to an in-memory buffer you can assert against without a real terminal.

Experimental backends for non-terminal targets:
- **Ratzilla** — WebAssembly backend for terminal-themed web apps
- **Mousefood** — embedded-graphics backend for embedded displays

### Crossterm Version Compatibility

Ratatui 0.30+ supports multiple crossterm major versions via feature flags. This matters because pulling in multiple semver-incompatible crossterm versions causes race conditions (separate event queues), broken raw mode restoration, and type mismatches.

```toml
# Pin to a specific crossterm version
ratatui = { version = "0.30", features = ["crossterm_0_28"] }
crossterm = "0.28"

# Or use a newer version
ratatui = { version = "0.30", features = ["crossterm_0_29"] }
crossterm = "0.29"
```

If multiple flags are enabled, ratatui selects the latest. Use `cargo tree -p crossterm` to check your dependency graph and disable default features on dependencies that drag in a conflicting crossterm major.

Ratatui 0.30+ also introduces `ratatui-core`, moving backends into separate crates so backend changes can evolve independently of the main library.

## Step 3: Choose an Application Pattern

Ask the user about their app's complexity and suggest the right pattern. Present it like this:

> I'd suggest one of these patterns based on your app's complexity:
>
> **Simple (flat struct)** — Single-screen apps, monitoring dashboards, simple viewers. One struct holds all state, one loop handles events and rendering. Start here if unsure.
>
> **Elm Architecture (TEA)** — Multi-screen apps with clear state transitions. Separates Model/Message/Update/View. State changes are predictable and testable. Good for apps with modes, forms, or workflows.
>
> **Component** — Complex apps with multiple independent panels or screens. Each UI section owns its state, events, and rendering. Best for apps like database clients, file managers, or multi-pane tools.
>
> What kind of app are you building? I'll suggest which pattern fits best.

After the user describes their app, recommend a pattern with reasoning. Let the user confirm or override.

### Pattern: Simple (Flat Struct)

A single `App` struct holds all state. One main loop polls events and redraws. No message passing, no trait abstractions.

**When to use**: Single-purpose tools, dashboards, viewers, small utilities with 1-2 screens.

**Structure**:
```
src/
├── main.rs          # Entry point, terminal init
├── app.rs           # App struct, run loop, event handling
└── ui.rs            # Rendering functions (optional split)
```

**Key characteristics**:
- `App` struct with `should_quit: bool` and all state fields
- `app.run(&mut terminal)` loop with `terminal.draw()` and `event::poll()`
- Direct key matching in the event handler
- Rendering either as methods on App or standalone functions taking `&App`

**Reference repos to study**:

| Repo | Stars | Description |
|---|---|---|
| [vladkens/macmon](https://github.com/vladkens/macmon) | 1.3k | Apple Silicon performance monitor — clean flat struct, focused tool |
| [pythops/bluetui](https://github.com/pythops/bluetui) | 2.6k | Bluetooth manager for Linux — simple, well-separated |
| [lusingander/serie](https://github.com/lusingander/serie) | 1.8k | Git commit graph visualizer — focused single-purpose |
| [ratatui/templates (simple)](https://github.com/ratatui/templates) | — | Official simple template |

### Pattern: Elm Architecture (TEA)

Separates the app into Model (state), Message (events), Update (state transitions), and View (rendering). State changes only happen through messages, making the flow predictable.

**When to use**: Apps with multiple modes or screens, form workflows, anything where you want testable state transitions.

**Structure**:
```
src/
├── main.rs          # Entry point
├── model.rs         # App state (Model)
├── message.rs       # Message enum
├── update.rs        # State transitions
└── view.rs          # Rendering
```

**Key characteristics**:
- `Model` struct holds all state
- `Message` enum represents every possible state change
- `update(model, msg)` is a pure function (or near-pure) — easy to unit test
- `view(model, frame)` is a pure rendering function — no mutation
- Event handler maps key events to Messages

**Reference repos to study**:

| Repo | Stars | Description |
|---|---|---|
| [veeso/termscp](https://github.com/veeso/termscp) | 2.8k | Terminal file transfer client — large production TEA app via tui-realm |
| [veeso/tui-realm](https://github.com/veeso/tui-realm) | 900 | React/Elm-inspired framework built on ratatui — the TEA reference implementation |
| [ratatui/templates (event-driven)](https://github.com/ratatui/templates) | — | Official event-driven template — closest to TEA in the official templates |

### Pattern: Component Architecture

Each UI section is a self-contained component implementing a shared trait. Components own their state, handle their own events, and render themselves. A root component composes children.

**When to use**: Complex multi-pane apps, database clients, API testers, file managers — anything with multiple independent UI sections that each need their own state and event handling.

**Structure**:
```
src/
├── main.rs
├── app.rs                # Root component, orchestration
├── components/
│   ├── mod.rs            # Component trait definition
│   ├── header.rs
│   ├── sidebar.rs
│   ├── main_panel.rs
│   └── status_bar.rs
├── action.rs             # Action enum for cross-component communication
└── event.rs              # Event handling infrastructure
```

**Key characteristics**:
- A `Component` trait with methods like `handle_key_event()`, `update()`, `render()`
- Each component manages its own state internally
- Cross-component communication via an `Action` enum
- Root component dispatches events to the focused component
- Components can return Actions that bubble up to the root

**Reference repos to study**:

| Repo | Stars | Description |
|---|---|---|
| [ratatui/templates (component)](https://github.com/ratatui/templates) | — | Official component template — the canonical reference |
| [TaKO8Ki/gobang](https://github.com/TaKO8Ki/gobang) | 3.2k | Database management tool — cited in official component docs |
| [Julien-cpsn/ATAC](https://github.com/Julien-cpsn/ATAC) | 3.5k | Terminal API client (Postman-like) — complex multi-pane component UI |
| [achristmascarl/rainfrog](https://github.com/achristmascarl/rainfrog) | 4.9k | Database tool — component-style architecture |

### Pattern: Flux Architecture

Flux uses a unidirectional data flow: Actions → Dispatcher → Store → View. Similar to TEA but with an explicit dispatcher and potentially multiple stores. The ratatui ecosystem mentions this as a recognized pattern, but it's less commonly used than TEA or Component in practice. Consider it if you're coming from a React/Redux background and find that mental model natural.

### Notable Large-Scale References

These are well-known apps worth studying regardless of which pattern you choose:

| Repo | Stars | Description |
|---|---|---|
| [sxyazi/yazi](https://github.com/sxyazi/yazi) | 34k | Async terminal file manager — best-in-class async architecture |
| [gitui-org/gitui](https://github.com/gitui-org/gitui) | 21k | Git terminal UI — component-based, very well structured |
| [ClementTsang/bottom](https://github.com/ClementTsang/bottom) | 13k | System monitor — handles complex real-time data rendering |
| [fujiapple852/trippy](https://github.com/fujiapple852/trippy) | 6.7k | Network diagnostics — good async + rendering patterns |
| [orhun/binsider](https://github.com/orhun/binsider) | 4k | Binary analyzer — clean architecture |

## Step 4: Study Reference Repos

Before scaffolding, clone and study 1-2 repos that match the chosen pattern. This grounds the project in real, tested code rather than guessing at structure.

Tell the user what you're doing:

> I'm going to clone [repo1] and [repo2] into a temp directory to study how they structure their [chosen pattern] app. I'll look at their project layout, how they handle state, events, and rendering, and then use those patterns to set up your project.

Then:

1. Clone the repos into `/tmp/ratatui-refs/`:
   ```bash
   mkdir -p /tmp/ratatui-refs
   git clone --depth 1 <repo-url> /tmp/ratatui-refs/<repo-name>
   ```

2. Study the key files:
   - `Cargo.toml` — dependencies, features
   - `src/main.rs` — entry point, terminal init pattern
   - `src/app.rs` or equivalent — app struct, run loop
   - Component/model/message files if applicable
   - How they organize rendering code

3. Summarize findings to the user:
   > Here's what I found from studying [repo]:
   > - They use [pattern details]
   > - Their project structure is [layout]
   > - Notable patterns: [what stood out]
   >
   > I'll use these patterns to scaffold your project now.

4. Clean up when done:
   ```bash
   rm -rf /tmp/ratatui-refs
   ```

## Step 5: Scaffold the Project

After studying references, set up the project:

### Base Dependencies (Cargo.toml)

Before adding dependencies, look up the latest versions using `cargo search`:

```bash
cargo search ratatui --limit 1
cargo search crossterm --limit 1
cargo search color-eyre --limit 1
```

Every Ratatui app needs these (use the latest versions from the search results above):
- `ratatui`
- `crossterm`
- `color-eyre`

Add based on pattern — again, check latest versions with `cargo search <crate> --limit 1`:

For TEA or Component (often want async):
- `tokio` with features `["rt", "rt-multi-thread", "macros"]`

For Component (often want these):
- `tracing`
- `tracing-subscriber`
### Entry Point

For simple apps, use `ratatui::run()`:
```rust
fn main() -> color_eyre::Result<()> {
    color_eyre::install()?;
    let mut app = App::default();
    ratatui::run(|terminal| app.run(terminal))
}
```

For apps needing more control (mouse capture, custom panic hooks, logging setup):
```rust
fn main() -> color_eyre::Result<()> {
    color_eyre::install()?;
    let terminal = ratatui::init();
    let result = App::default().run(terminal);
    ratatui::restore();
    result
}
```

Use `DefaultTerminal` as the terminal type — don't use generic `Terminal<B: Backend>` unless you need multiple backends.

### Logging

Never log to stdout — it's the rendering surface. Use tracing with a file appender:

```rust
tracing_subscriber::fmt()
    .with_writer(std::fs::File::create("/tmp/myapp.log").unwrap())
    .init();
```

Or use `tui-logger` for in-app log display.
