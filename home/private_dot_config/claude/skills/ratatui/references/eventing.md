# Eventing

Ratatui provides no event system — you build your own from the backend (crossterm) and Rust's concurrency primitives. This guide covers crossterm basics and the patterns used by production ratatui apps.

## Table of Contents

1. [Crossterm Basics](#crossterm-basics)
2. [Choosing an Architecture](#choosing-an-architecture)
3. [Single-Thread Blocking Poll](#single-thread-blocking-poll)
4. [Dedicated Input Thread with Channels](#dedicated-input-thread-with-channels)
5. [Async with Tokio](#async-with-tokio)
6. [The Event → Action Pipeline](#the-event--action-pipeline)
7. [Render Strategy](#render-strategy)
8. [Background Tasks](#background-tasks)

---

## Crossterm Basics

### Polling and Reading Events

Crossterm provides blocking and polling APIs for reading terminal events:

```rust
use crossterm::event::{self, Event, KeyCode, KeyEvent, KeyModifiers};

// Blocking read — waits indefinitely for the next event
let event = event::read()?;

// Poll with timeout — returns true if an event is available
if event::poll(std::time::Duration::from_millis(250))? {
    let event = event::read()?;
}
```

### Key Events

A `KeyEvent` contains the key code, modifiers, and the kind of event (press, release, repeat):

```rust
fn handle_key(key: KeyEvent, app: &mut App) {
    match key.code {
        KeyCode::Char('q') => app.should_quit = true,
        KeyCode::Char('c') if key.modifiers.contains(KeyModifiers::CONTROL) => {
            app.should_quit = true;
        }
        KeyCode::Up | KeyCode::Char('k') => app.scroll_up(),
        KeyCode::Down | KeyCode::Char('j') => app.scroll_down(),
        KeyCode::Enter => app.select(),
        KeyCode::Esc => app.back(),
        _ => {}
    }
}
```

In raw mode, Ctrl+C no longer sends SIGINT — your app must handle quit explicitly.

### Mouse Events

Mouse capture must be enabled at startup:

```rust
use crossterm::event::{EnableMouseCapture, DisableMouseCapture};
use crossterm::execute;

execute!(std::io::stdout(), EnableMouseCapture)?;   // on init
execute!(std::io::stdout(), DisableMouseCapture)?;  // on restore
```

```rust
use crossterm::event::{MouseEvent, MouseEventKind};

fn handle_mouse(mouse: MouseEvent, app: &mut App) {
    match mouse.kind {
        MouseEventKind::Down(button) => { /* click at mouse.column, mouse.row */ }
        MouseEventKind::ScrollUp => app.scroll_up(),
        MouseEventKind::ScrollDown => app.scroll_down(),
        MouseEventKind::Moved => { /* hover tracking */ }
        _ => {}
    }
}
```

---

## Choosing an Architecture

| Complexity | Pattern | Runtime | Used by |
|---|---|---|---|
| Simple tools, viewers | Single-thread blocking poll | None | trippy |
| Multi-threaded, background work | Dedicated threads + channels | None | gitui, bottom, binsider |
| Async I/O, network, databases | Tokio + EventStream | tokio | yazi, rainfrog |

Pick the simplest one that fits your app. You can always upgrade later — the Event → Action separation (section 5) works with any of these.

---

## Single-Thread Blocking Poll

The simplest architecture. One thread, no channels, no async runtime. The `event::poll()` timeout doubles as a refresh timer.

```rust
use std::time::Duration;
use crossterm::event::{self, Event, KeyCode, KeyEventKind};

fn run(mut terminal: DefaultTerminal) -> color_eyre::Result<()> {
    let mut app = App::default();

    loop {
        terminal.draw(|frame| app.render(frame))?;

        // Poll with timeout — redraws at refresh_rate even without input
        if event::poll(Duration::from_millis(250))? {
            if let Event::Key(key) = event::read()? {
                if key.kind == KeyEventKind::Press {
                    match key.code {
                        KeyCode::Char('q') => break,
                        KeyCode::Up => app.previous(),
                        KeyCode::Down => app.next(),
                        _ => {}
                    }
                }
            }
        }

        if app.should_quit {
            break;
        }
    }
    Ok(())
}
```

**Works well for**: single-screen tools, dashboards, viewers, anything without background work.

**Breaks down when**: you need async I/O, background data fetching, or multiple event sources.

---

## Dedicated Input Thread with Channels

Move input polling to a separate thread so the main thread can process events from multiple sources. This is the standard pattern for threaded ratatui apps (gitui, bottom, binsider).

### Event enum

Define what your app cares about:

```rust
pub enum Event {
    Key(KeyEvent),
    Mouse(MouseEvent),
    Resize(u16, u16),
    Tick,
}
```

### Event handler thread

```rust
use std::sync::mpsc;
use std::thread;
use std::time::Duration;
use crossterm::event::{self, Event as TermEvent, KeyEventKind};

pub struct EventHandler {
    rx: mpsc::Receiver<Event>,
}

impl EventHandler {
    pub fn new(tick_rate: Duration) -> Self {
        let (tx, rx) = mpsc::channel();

        thread::spawn(move || {
            loop {
                if event::poll(tick_rate).unwrap_or(false) {
                    match event::read().unwrap() {
                        TermEvent::Key(key) if key.kind == KeyEventKind::Press => {
                            tx.send(Event::Key(key)).ok();
                        }
                        TermEvent::Mouse(mouse) => {
                            tx.send(Event::Mouse(mouse)).ok();
                        }
                        TermEvent::Resize(w, h) => {
                            tx.send(Event::Resize(w, h)).ok();
                        }
                        _ => {}
                    }
                } else {
                    // Timeout — send tick for periodic updates
                    tx.send(Event::Tick).ok();
                }
            }
        });

        Self { rx }
    }

    pub fn next(&self) -> color_eyre::Result<Event> {
        Ok(self.rx.recv()?)
    }
}
```

### Main loop

```rust
fn run(mut terminal: DefaultTerminal) -> color_eyre::Result<()> {
    let mut app = App::default();
    let events = EventHandler::new(Duration::from_millis(250));

    loop {
        terminal.draw(|frame| app.render(frame))?;

        match events.next()? {
            Event::Key(key) => app.handle_key(key),
            Event::Mouse(mouse) => app.handle_mouse(mouse),
            Event::Resize(_, _) => {} // ratatui handles resize automatically
            Event::Tick => app.on_tick(),
        }

        if app.should_quit {
            break;
        }
    }
    Ok(())
}
```

### Multiple event sources (gitui pattern)

For apps with multiple background threads, use `crossbeam::Select` to multiplex channels:

```rust
use crossbeam_channel::{select, unbounded, Receiver};

fn select_event(
    rx_input: &Receiver<Event>,
    rx_git: &Receiver<AsyncGitNotification>,
    rx_ticker: &Receiver<()>,
) -> AppEvent {
    select! {
        recv(rx_input) -> msg => AppEvent::Input(msg.unwrap()),
        recv(rx_git) -> msg => AppEvent::GitUpdate(msg.unwrap()),
        recv(rx_ticker) -> _ => AppEvent::Tick,
    }
}
```

GitUI multiplexes 6 channels this way: terminal input, git notifications, app notifications, ticker, filesystem watcher, and spinner animation.

---

## Async with Tokio

For apps with async I/O (network, databases, file watching), use crossterm's `EventStream` with `tokio::select!`.

Install the latest versions of `tokio` (with `rt`, `rt-multi-thread`, `macros` features), `tokio-stream`, and `crossterm` (with `event-stream` feature).

```rust
use crossterm::event::{EventStream, Event as TermEvent, KeyEventKind};
use tokio::time::{interval, Duration};
use tokio_stream::StreamExt;

async fn run(mut terminal: DefaultTerminal) -> color_eyre::Result<()> {
    let mut app = App::default();
    let mut event_stream = EventStream::new();
    let mut tick_interval = interval(Duration::from_millis(250));
    let mut render_interval = interval(Duration::from_millis(66)); // ~15 FPS

    loop {
        tokio::select! {
            // Terminal events (keys, mouse, resize)
            Some(Ok(event)) = event_stream.next() => {
                match event {
                    TermEvent::Key(key) if key.kind == KeyEventKind::Press => {
                        app.handle_key(key);
                    }
                    TermEvent::Mouse(mouse) => app.handle_mouse(mouse),
                    _ => {}
                }
            }

            // Periodic tick for background updates
            _ = tick_interval.tick() => {
                app.on_tick();
            }

            // Render at fixed rate
            _ = render_interval.tick() => {
                terminal.draw(|frame| app.render(frame))?;
            }

            // Background async tasks
            Some(result) = app.next_background_result() => {
                app.handle_result(result);
            }
        }

        if app.should_quit {
            break;
        }
    }
    Ok(())
}
```

### Separate tick and render rates (rainfrog pattern)

Rainfrog uses different rates for ticking (data updates, 4Hz) and rendering (screen draws, 15Hz). This avoids unnecessary redraws when no state has changed:

```rust
let mut tick_interval = interval(Duration::from_millis(250));   // 4 Hz
let mut render_interval = interval(Duration::from_millis(66));  // ~15 Hz
```

---

## The Event → Action Pipeline

The cleanest way to decouple input handling from business logic. Terminal events are mapped to domain actions, which are processed separately. Used by rainfrog and binsider.

### Define your action enum

```rust
pub enum Action {
    Quit,
    Render,
    ScrollUp,
    ScrollDown,
    Select,
    Back,
    SubmitQuery,
    FocusNext,
    FocusPrevious,
    Delete,
    Refresh,
    Error(String),
}
```

### Map events to actions

```rust
fn map_key_to_action(key: KeyEvent, mode: &Mode) -> Option<Action> {
    match mode {
        Mode::Normal => match key.code {
            KeyCode::Char('q') => Some(Action::Quit),
            KeyCode::Up | KeyCode::Char('k') => Some(Action::ScrollUp),
            KeyCode::Down | KeyCode::Char('j') => Some(Action::ScrollDown),
            KeyCode::Enter => Some(Action::Select),
            KeyCode::Esc => Some(Action::Back),
            KeyCode::Tab => Some(Action::FocusNext),
            KeyCode::BackTab => Some(Action::FocusPrevious),
            KeyCode::Char('d') => Some(Action::Delete),
            _ => None,
        },
        Mode::Editing => match key.code {
            KeyCode::Esc => Some(Action::Back),
            KeyCode::Enter => Some(Action::SubmitQuery),
            _ => None, // let the text input component handle it
        },
    }
}
```

### Process actions

```rust
fn update(&mut self, action: Action) {
    match action {
        Action::Quit => self.should_quit = true,
        Action::ScrollUp => self.list_state.scroll_up(),
        Action::ScrollDown => self.list_state.scroll_down(),
        Action::Select => self.select_current(),
        Action::Back => self.mode = Mode::Normal,
        Action::SubmitQuery => self.execute_query(),
        Action::FocusNext => self.cycle_focus(1),
        Action::FocusPrevious => self.cycle_focus(-1),
        Action::Delete => self.delete_selected(),
        Action::Refresh => self.reload_data(),
        Action::Error(msg) => self.show_error(msg),
        Action::Render => {} // handled by render loop
    }
}
```

### Why this matters

- **Testable**: unit test `update()` without a terminal — just pass actions directly
- **Configurable keybindings**: swap out `map_key_to_action` with a user-defined keymap
- **Components can emit actions**: background tasks, timers, and child components all speak the same language

### Configurable keybindings (rainfrog pattern)

Store key-to-action mappings per focus state in a `HashMap`:

```rust
use std::collections::HashMap;

type KeyBindings = HashMap<Focus, HashMap<Vec<KeyEvent>, Action>>;

fn handle_key(&self, key: KeyEvent, focus: &Focus, bindings: &KeyBindings) -> Option<Action> {
    bindings
        .get(focus)
        .and_then(|keymap| keymap.get(&vec![key]))
        .cloned()
}
```

---

## Render Strategy

### Render every event (simplest)

Draw after every event. Fine for simple apps:

```rust
loop {
    terminal.draw(|frame| app.render(frame))?;
    let event = events.next()?;
    app.handle(event);
}
```

### Fixed render rate (rainfrog)

Separate render interval prevents wasted draws when events arrive faster than the screen updates:

```rust
// In tokio::select!
_ = render_interval.tick() => {
    terminal.draw(|frame| app.render(frame))?;
}
```

### Render coalescing (yazi)

For high-throughput apps, batch events and enforce a minimum gap between renders. Yazi uses an `AtomicU8` flag and 10ms minimum gap:

```rust
use std::sync::atomic::{AtomicBool, Ordering};
use std::time::Instant;

static NEEDS_RENDER: AtomicBool = AtomicBool::new(false);
const MIN_RENDER_GAP: Duration = Duration::from_millis(10);

// Event handlers set the flag
NEEDS_RENDER.store(true, Ordering::Relaxed);

// Render loop checks the flag
if NEEDS_RENDER.swap(false, Ordering::Relaxed) {
    if last_render.elapsed() >= MIN_RENDER_GAP {
        terminal.draw(|frame| app.render(frame))?;
        last_render = Instant::now();
    } else {
        NEEDS_RENDER.store(true, Ordering::Relaxed); // retry next loop
    }
}
```

### Mouse event debouncing (rainfrog)

Only keep the last mouse event per render frame to avoid processing dozens of mouse moves:

```rust
let mut last_mouse_event: Option<MouseEvent> = None;

// In event handling
TermEvent::Mouse(mouse) => {
    last_mouse_event = Some(mouse); // overwrite, don't queue
}

// At render time
if let Some(mouse) = last_mouse_event.take() {
    app.handle_mouse(mouse);
}
```

---

## Background Tasks

### Thread-based (bottom pattern)

Spawn dedicated threads for data collection. Send results through the same event channel:

```rust
pub enum Event {
    Key(KeyEvent),
    Tick,
    DataUpdate(Box<SystemMetrics>), // from collection thread
    Terminate,
}

// Collection thread
thread::spawn(move || {
    loop {
        thread::sleep(collection_interval);
        let metrics = collect_system_metrics();
        tx.send(Event::DataUpdate(Box::new(metrics))).ok();
    }
});

// Ctrl+C handler through the same channel
ctrlc::set_handler(move || {
    tx_clone.send(Event::Terminate).ok();
});
```

### Async tasks (rainfrog/yazi pattern)

In tokio apps, spawn tasks and receive results through channels or `tokio::select!`:

```rust
// Spawn a background query
let (result_tx, mut result_rx) = tokio::sync::mpsc::unbounded_channel();

tokio::spawn(async move {
    let result = database.execute_query(query).await;
    result_tx.send(result).ok();
});

// In the main select! loop
Some(result) = result_rx.recv() => {
    app.handle_query_result(result);
}
```

### Shared state (trippy pattern)

For read-heavy background data (metrics, trace results), use shared memory instead of channels. The background thread writes, the render loop reads:

```rust
use std::sync::{Arc, RwLock};

let shared_data = Arc::new(RwLock::new(TraceData::default()));

// Background thread
let data_clone = shared_data.clone();
thread::spawn(move || {
    loop {
        let new_data = collect_trace();
        *data_clone.write().unwrap() = new_data;
    }
});

// Main loop — snapshot on each frame
let snapshot = shared_data.read().unwrap().clone();
terminal.draw(|frame| render(frame, &snapshot))?;
```

This avoids channel backpressure when data updates faster than the UI renders.

### Cancellation

Use `CancellationToken` (tokio) or `AtomicBool` (threads) for clean shutdown:

```rust
// Tokio
use tokio_util::sync::CancellationToken;

let token = CancellationToken::new();
let token_clone = token.clone();

tokio::spawn(async move {
    loop {
        tokio::select! {
            _ = token_clone.cancelled() => break,
            _ = do_work() => {}
        }
    }
});

// On quit
token.cancel();
```

```rust
// Threads
use std::sync::atomic::{AtomicBool, Ordering};
use std::sync::Arc;

let running = Arc::new(AtomicBool::new(true));
let running_clone = running.clone();

thread::spawn(move || {
    while running_clone.load(Ordering::Relaxed) {
        // ... work ...
    }
});

// On quit
running.store(false, Ordering::Relaxed);
```
