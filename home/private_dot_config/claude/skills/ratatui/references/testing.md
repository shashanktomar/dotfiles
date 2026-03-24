# Testing Ratatui Applications

## Table of Contents

1. [Testing Strategy](#testing-strategy)
2. [Logic and State Tests](#logic-and-state-tests)
3. [Buffer-Based Widget Tests](#buffer-based-widget-tests)
4. [Snapshot Tests with Insta](#snapshot-tests-with-insta)
5. [CLI Integration Tests](#cli-integration-tests)
6. [Test Helpers and Patterns](#test-helpers-and-patterns)

---

## Testing Strategy

The most important insight from studying production ratatui apps (gitui, yazi, bottom, rainfrog, trippy): **separate your logic from your rendering and test the logic.**

Apps like yazi (34k stars) and gitui (21k stars) have zero rendering tests. Their test suites focus entirely on state management, data structures, and business logic. The rendering layer is a thin translation from state to widgets — bugs live in the state, not in whether a border draws correctly.

### The test pyramid for ratatui apps

```
        /  CLI / snapshot  \        ← few: full app integration
       /  widget rendering  \       ← some: Buffer-based assertions
      /   logic and state    \      ← most: pure functions, state transitions
```

1. **Logic and state tests** — the bulk of your tests. State transitions, data processing, config parsing, domain logic. No terminal, no rendering.
2. **Widget rendering tests** — for custom widgets or complex rendering logic. Render to a `Buffer`, compare with expected output.
3. **Snapshot / integration tests** — for CLI help output, full-screen captures, or argument validation. Sit at the top of the pyramid.

---

## Logic and State Tests

This is where most of your tests should live. Keep rendering concerns out — test your app's state machine, data structures, and business logic as pure Rust.

### Separate state from rendering

Structure your app so state logic is testable without a terminal:

```rust
// app.rs — state and logic, no rendering imports needed
pub struct App {
    pub items: Vec<String>,
    pub selected: usize,
    pub filter: String,
    pub mode: Mode,
}

pub enum Mode {
    Normal,
    Editing,
}

impl App {
    pub fn next(&mut self) {
        if !self.items.is_empty() {
            self.selected = (self.selected + 1) % self.items.len();
        }
    }

    pub fn previous(&mut self) {
        if !self.items.is_empty() {
            self.selected = self.selected.checked_sub(1).unwrap_or(self.items.len() - 1);
        }
    }

    pub fn filtered_items(&self) -> Vec<&str> {
        self.items
            .iter()
            .filter(|item| item.contains(&self.filter))
            .map(|s| s.as_str())
            .collect()
    }

    pub fn delete_selected(&mut self) {
        if !self.items.is_empty() {
            self.items.remove(self.selected);
            if self.selected >= self.items.len() && self.selected > 0 {
                self.selected -= 1;
            }
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn sample_app() -> App {
        App {
            items: vec!["alpha".into(), "beta".into(), "gamma".into()],
            selected: 0,
            filter: String::new(),
            mode: Mode::Normal,
        }
    }

    #[test]
    fn next_wraps_around() {
        let mut app = sample_app();
        app.selected = 2;
        app.next();
        assert_eq!(app.selected, 0);
    }

    #[test]
    fn previous_wraps_around() {
        let mut app = sample_app();
        app.previous();
        assert_eq!(app.selected, 2);
    }

    #[test]
    fn filter_narrows_items() {
        let mut app = sample_app();
        app.filter = "a".into();
        let filtered = app.filtered_items();
        assert_eq!(filtered, vec!["alpha", "gamma"]);
    }

    #[test]
    fn delete_adjusts_selection() {
        let mut app = sample_app();
        app.selected = 2; // "gamma"
        app.delete_selected();
        assert_eq!(app.selected, 1);
        assert_eq!(app.items, vec!["alpha", "beta"]);
    }

    #[test]
    fn delete_on_empty_is_safe() {
        let mut app = App {
            items: vec![],
            selected: 0,
            filter: String::new(),
            mode: Mode::Normal,
        };
        app.delete_selected(); // should not panic
    }
}
```

### Component state testing (gitui pattern)

For apps using the Component pattern, create a test environment factory that provides dummy dependencies. From gitui:

```rust
pub struct Environment {
    pub queue: Queue,
    pub theme: SharedTheme,
    pub key_config: SharedKeyConfig,
    pub repo: RepoPathRef,
    pub sender_git: Sender<AsyncGitNotification>,
    pub sender_app: Sender<AsyncAppNotification>,
}

#[cfg(test)]
impl Environment {
    pub fn test_env() -> Self {
        use crossbeam_channel::unbounded;
        Self {
            queue: Queue::new(),
            theme: Default::default(),
            key_config: Default::default(),
            repo: RefCell::new(RepoPath::Path(Default::default())),
            sender_git: unbounded().0,
            sender_app: unbounded().0,
        }
    }
}
```

Then test component logic without rendering:

```rust
#[test]
fn test_text_input_cursor_movement() {
    let env = Environment::test_env();
    let mut comp = TextInputComponent::new(&env, "", "", false);
    comp.show_inner_textarea();
    comp.set_text(String::from("hello world"));

    if let Some(ta) = &mut comp.textarea {
        assert_eq!(ta.cursor(), (0, 0));
        ta.move_cursor(CursorMove::WordForward);
        assert_eq!(ta.cursor(), (0, 6));
    }
}
```

---

## Buffer-Based Widget Tests

This is how the ratatui library itself tests its widgets (~954 tests). Render a widget to an in-memory `Buffer`, then compare against expected output using `Buffer::with_lines()`.

### The core pattern

```rust
#[cfg(test)]
mod tests {
    use ratatui::prelude::*;
    use ratatui::widgets::*;

    /// Render a widget and return the buffer for assertion.
    fn render(widget: impl Widget, width: u16, height: u16) -> Buffer {
        let mut buffer = Buffer::empty(Rect::new(0, 0, width, height));
        widget.render(buffer.area, &mut buffer);
        buffer
    }

    #[test]
    fn renders_list_items() {
        let list = List::new(["Item 0", "Item 1", "Item 2"]);
        let buffer = render(list, 10, 4);

        let expected = Buffer::with_lines([
            "Item 0    ",
            "Item 1    ",
            "Item 2    ",
            "          ",
        ]);
        assert_eq!(buffer, expected);
    }
}
```

### Testing stateful widgets

For widgets that track state (selection, scroll position), use a stateful helper:

```rust
fn render_stateful(
    widget: impl StatefulWidget<State = ListState>,
    state: &mut ListState,
    width: u16,
    height: u16,
) -> Buffer {
    let mut buffer = Buffer::empty(Rect::new(0, 0, width, height));
    StatefulWidget::render(widget, buffer.area, &mut buffer, state);
    buffer
}

#[test]
fn list_highlights_selected_item() {
    let list = List::new(["Item 0", "Item 1", "Item 2"])
        .highlight_symbol(">> ");
    let mut state = ListState::default().with_selected(Some(1));
    let buffer = render_stateful(list, &mut state, 13, 3);

    let expected = Buffer::with_lines([
        "   Item 0    ",
        ">> Item 1    ",
        "   Item 2    ",
    ]);
    assert_eq!(buffer, expected);
}
```

### Testing custom widgets

Write `Buffer`-based tests for your own widgets:

```rust
struct StatusBar {
    mode: String,
    filename: String,
}

impl Widget for StatusBar {
    fn render(self, area: Rect, buf: &mut Buffer) {
        let [left, right] = Layout::horizontal([
            Constraint::Fill(1),
            Constraint::Length(self.filename.len() as u16),
        ]).areas(area);
        Line::from(self.mode).bold().render(left, buf);
        Line::from(self.filename).render(right, buf);
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn status_bar_renders_mode_and_filename() {
        let widget = StatusBar {
            mode: "NORMAL".into(),
            filename: "main.rs".into(),
        };
        let mut buf = Buffer::empty(Rect::new(0, 0, 20, 1));
        widget.render(buf.area, &mut buf);

        // mode fills remaining space, filename is right-aligned
        assert_eq!(buf, Buffer::with_lines(["NORMAL       main.rs"]));
    }
}
```

### Reusable test helper (ratatui pattern)

The ratatui codebase uses a `#[track_caller]` helper so test failures point to the calling test, not the helper:

```rust
#[track_caller]
fn assert_renders(widget: &impl Widget, expected: &Buffer) {
    let mut buffer = Buffer::empty(Rect::new(0, 0, expected.area.width, expected.area.height));
    widget.render(buffer.area, &mut buffer);
    assert_eq!(buffer, *expected);
}
```

### Where to find more patterns

The ratatui library's own widget tests are the best reference for Buffer-based testing:
- `ratatui-widgets/src/list/rendering.rs` — stateful widget tests, rstest fixtures
- `ratatui-widgets/src/paragraph.rs` — wrapping, alignment, scrolling
- `ratatui-widgets/src/table.rs` — column widths, row selection
- `ratatui-widgets/src/scrollbar.rs` — parameterized position tests

Browse them at https://github.com/ratatui/ratatui/tree/main/ratatui-widgets/src

---

## Snapshot Tests with Insta

For full-screen captures or large text output where writing `Buffer::with_lines` by hand would be tedious, use [insta](https://insta.rs) snapshot testing.

### Setup

```bash
cargo install cargo-insta
cargo add insta --dev
```

### Testing full-screen rendering with TestBackend

```rust
#[cfg(test)]
mod tests {
    use insta::assert_snapshot;
    use ratatui::{backend::TestBackend, Terminal};

    #[test]
    fn test_app_renders() {
        let app = App::default();
        let mut terminal = Terminal::new(TestBackend::new(80, 20)).unwrap();
        terminal
            .draw(|frame| frame.render_widget(&app, frame.area()))
            .unwrap();
        assert_snapshot!(terminal.backend());
    }
}
```

This captures the rendered terminal as a text snapshot stored in `snapshots/`. On first run, insta creates the snapshot file. On subsequent runs, it compares against the stored version.

Review and accept changes with:

```bash
cargo insta review
```

### Snapshot testing for CLI help and generated output (trippy pattern)

Trippy uses `test_case` + `insta` to snapshot-test shell completions and help text:

```rust
use test_case::test_case;

#[test_case(&shell_completions(Shell::Bash).unwrap(), "bash completions"; "bash")]
#[test_case(&shell_completions(Shell::Zsh).unwrap(), "zsh completions"; "zsh")]
#[test_case(&man_page().unwrap(), "man page"; "man page")]
fn test_output(actual: &str, name: &str) {
    insta::assert_snapshot!(name, actual);
}
```

### Caveats

- Color/style assertions are not supported in snapshots as of now — only text content is captured.
- Use a consistent terminal size (e.g., 80x24) for reproducible results.
- If your UI changes frequently during development, review snapshots after significant updates to avoid noisy CI failures.

---

## CLI Integration Tests

For apps with complex CLI argument handling, use `assert_cmd` + `predicates` to test the actual binary. This is the approach bottom uses.

### Setup

```bash
cargo add assert_cmd predicates --dev
```

### Testing argument validation

```rust
// tests/integration/cli_tests.rs
use assert_cmd::prelude::*;
use predicates::prelude::*;
use std::process::Command;

fn app_command() -> Command {
    Command::cargo_bin("myapp").unwrap()
}

#[test]
fn rejects_invalid_rate() {
    app_command()
        .args(["--rate", "0"])
        .assert()
        .failure()
        .stderr(predicate::str::contains("'--rate' must be greater than 0"));
}

#[test]
fn accepts_valid_config() {
    app_command()
        .args(["--config", "./tests/fixtures/valid_config.toml"])
        .args(["--check-config"])
        .assert()
        .success();
}

#[test]
fn rejects_invalid_config() {
    app_command()
        .args(["--config", "./tests/fixtures/bad_config.toml"])
        .assert()
        .failure()
        .stderr(predicate::str::contains("invalid configuration"));
}
```

---

## Test Helpers and Patterns

### Parameterized tests with rstest

`rstest` is the testing framework used by ratatui itself. `#[fixture]` creates reusable test setup, `#[case]` enables parameterized tests:

```bash
cargo add rstest --dev
```

```rust
use rstest::{fixture, rstest};

#[fixture]
fn small_buffer() -> Buffer {
    Buffer::empty(Rect::new(0, 0, 10, 1))
}

#[rstest]
#[case::top_to_bottom(ListDirection::TopToBottom, [
    "Item 0    ",
    "Item 1    ",
    "Item 2    ",
    "          ",
])]
#[case::bottom_to_top(ListDirection::BottomToTop, [
    "          ",
    "Item 2    ",
    "Item 1    ",
    "Item 0    ",
])]
fn list_direction<'line, Lines>(#[case] direction: ListDirection, #[case] expected: Lines)
where
    Lines: IntoIterator,
    Lines::Item: Into<Line<'line>>,
{
    let list = List::new(["Item 0", "Item 1", "Item 2"]).direction(direction);
    let mut buffer = Buffer::empty(Rect::new(0, 0, 10, 4));
    Widget::render(list, buffer.area, &mut buffer);
    assert_eq!(buffer, Buffer::with_lines(expected));
}
```

### Test factory pattern

Create lightweight factory functions to reduce boilerplate in tests:

```rust
#[cfg(test)]
mod tests {
    fn sample_items() -> Vec<String> {
        vec!["alpha", "beta", "gamma"].into_iter().map(String::from).collect()
    }

    fn app_with_items(items: Vec<String>) -> App {
        App {
            items,
            selected: 0,
            filter: String::new(),
            mode: Mode::Normal,
        }
    }

    #[test]
    fn test_something() {
        let mut app = app_with_items(sample_items());
        // ...
    }
}
```

### Builder pattern for test config (trippy pattern)

For complex configuration objects, use a builder that defaults everything:

```rust
#[cfg(test)]
struct TestConfigBuilder {
    mode: Mode,
    max_rounds: Option<usize>,
    // ...
}

#[cfg(test)]
impl TestConfigBuilder {
    fn new() -> Self {
        Self {
            mode: Mode::Tui,
            max_rounds: None,
        }
    }

    fn mode(mut self, mode: Mode) -> Self {
        self.mode = mode;
        self
    }

    fn build(self) -> AppConfig {
        AppConfig {
            mode: self.mode,
            max_rounds: self.max_rounds,
            // ... other fields with defaults
        }
    }
}

/// Shorthand for tests
#[cfg(test)]
fn cfg() -> TestConfigBuilder {
    TestConfigBuilder::new()
}

// Usage in parameterized tests:
#[test_case("myapp --mode stream", Ok(cfg().mode(Mode::Stream).build()); "stream mode")]
fn test_mode(cmd: &str, expected: Result<AppConfig>) {
    let actual = parse_config(cmd);
    assert_eq!(actual, expected);
}
```

### Recommended dev-dependencies

```toml
[dev-dependencies]
rstest = "*"              # fixtures and parameterized tests
pretty_assertions = "*"   # readable diffs on assertion failures
insta = "*"               # snapshot testing (if needed)
assert_cmd = "*"          # CLI integration tests (if needed)
predicates = "*"          # assertion predicates for assert_cmd
```
