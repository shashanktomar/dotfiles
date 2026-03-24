# Ratatui Concepts

## Table of Contents

1. [Terminal Fundamentals](#terminal-fundamentals)
2. [Widgets](#widgets)
3. [Layout](#layout)
4. [Rendering](#rendering)
5. [Under the Hood](#under-the-hood)

---

## Terminal Fundamentals

### Raw Mode

Normally, terminal input is line-buffered — the program only sees input after the user presses Enter. **Raw mode** disables this:
- Keypresses are delivered immediately, one at a time
- Special key handling (Ctrl+C for SIGINT, Ctrl+Z for SIGTSTP) is disabled — your app must handle quit/suspend itself
- Echo is turned off — typed characters don't appear unless you render them

Raw mode is enabled at app start and must be disabled on exit (including panics), or the user's terminal is left in a broken state.

### Alternate Screen

Terminals have two screen buffers — the **main screen** (where your shell history lives) and the **alternate screen** (a clean slate). TUI apps switch to the alternate screen on start and back to the main screen on exit, so the user's shell history is preserved.

### Mouse Capture

Optionally, your app can capture mouse events (clicks, scroll, movement). This is enabled via the backend and disabled on exit.

---

## Widgets

Widgets are the building blocks of Ratatui UIs. They render content into a rectangular area of the terminal buffer.

### Built-in Widgets

- **Block** — draws borders, titles, and padding around content
- **Paragraph** — styled, wrapped text display
- **List** — selectable item list
- **Table** — multi-column grid with row selection
- **Tabs** — tab bar with selection
- **Chart** — line/scatter graphs for multiple datasets
- **BarChart** — grouped bar displays
- **Gauge** / **LineGauge** — progress indicators
- **Sparkline** — inline data visualization
- **Scrollbar** — scroll position indicator
- **Canvas** — arbitrary shape drawing
- **Calendar** — single month display
- **Clear** — resets the area (important for popups/overlays)

`String`, `&str`, `Span`, `Line`, and `Text` also implement `Widget`, though `Paragraph` is preferred for most text rendering.

### The Widget Trait

The core trait — takes ownership of self and renders into a buffer area:

```rust
pub trait Widget {
    fn render(self, area: Rect, buf: &mut Buffer);
}
```

Implement `Widget for &YourType` (on a reference) rather than consuming self — this allows reuse without cloning:

```rust
struct GreetingWidget {
    name: String,
}

impl Widget for &GreetingWidget {
    fn render(self, area: Rect, buf: &mut Buffer) {
        let hello = Span::raw("Hello, ");
        let name = Span::styled(&self.name, Modifier::BOLD);
        Line::from(vec![hello, name]).render(area, buf);
    }
}
```

### StatefulWidget Trait

For widgets that need mutable state across renders (scroll position, selection index, animation frame):

```rust
pub trait StatefulWidget {
    type State;
    fn render(self, area: Rect, buf: &mut Buffer, state: &mut Self::State);
}
```

Example — a frame counter:

```rust
struct FrameCountWidget {
    style: Style,
}

impl StatefulWidget for FrameCountWidget {
    type State = i32;

    fn render(self, area: Rect, buf: &mut Buffer, state: &mut i32) {
        *state += 1;
        Line::styled(format!("Frame count: {state}"), self.style).render(area, buf);
    }
}
```

Built-in stateful widgets like `List`, `Table`, and `Scrollbar` have companion state types (`ListState`, `TableState`, `ScrollbarState`) that track selection and scroll position.

### WidgetRef and StatefulWidgetRef

These traits (behind the `unstable-widget-ref` feature flag) allow rendering by reference instead of consuming the widget. Useful for storing widget collections:

```rust
pub trait WidgetRef {
    fn render_ref(&self, area: Rect, buf: &mut Buffer);
}
```

There is a blanket implementation of `Widget` for `&T where T: WidgetRef`.

This enables dynamic widget collections using trait objects:

```rust
let widgets: Vec<Box<dyn WidgetRef>> = vec![
    Box::new(Greeting { name: "alice".into() }),
    Box::new(Farewell { name: "bob".into() }),
];

for widget in widgets {
    widget.render_ref(area, buf);
}
```

### Using Widgets

`Frame` provides the rendering methods:

- `frame.render_widget(widget, area)` — renders a consuming widget
- `frame.render_stateful_widget(widget, area, &mut state)` — renders with mutable state

These are called from the closure passed to `Terminal::draw`:

```rust
terminal.draw(|frame| {
    frame.render_widget(some_widget, frame.area());
})?;
```

A common pattern is implementing `Widget` on the `App` struct itself, so it becomes the root widget that composes all others:

```rust
impl Widget for &App {
    fn render(self, area: Rect, buf: &mut Buffer) {
        // Layout and render child widgets here
        MyHeaderWidget::new("Header text")
            .render(Rect::new(0, 0, area.width, 1), buf);
    }
}

// In the main loop:
terminal.draw(|frame| {
    frame.render_widget(&app, frame.area());
})?;
```

---

## Layout

### Coordinate System

Ratatui uses a coordinate system running left to right, top to bottom, with `(0, 0)` at the top-left corner. Coordinates are `u16` values. Each position maps to a terminal cell — approximately twice as tall as it is wide.

### The Layout Struct

`Layout` divides a `Rect` into smaller `Rect`s based on constraints:

```rust
let layout = Layout::default()
    .direction(Direction::Vertical)
    .constraints(vec![
        Constraint::Percentage(50),
        Constraint::Percentage(50),
    ])
    .split(frame.area());

frame.render_widget(top_widget, layout[0]);
frame.render_widget(bottom_widget, layout[1]);
```

Shorthand with the `areas` method for destructuring:

```rust
let [header, content, footer] = Layout::vertical([
    Constraint::Length(3),
    Constraint::Fill(1),
    Constraint::Length(1),
]).areas(area);
```

### Constraint Types

| Constraint | Behavior |
|---|---|
| `Length(n)` | Fixed absolute size in rows/columns. Not responsive to terminal size. |
| `Percentage(n)` | Proportional to parent size. `Percentage(50)` = half of parent. |
| `Ratio(num, den)` | Fine-grained proportional sizing. `Ratio(1, 3)` = one third. |
| `Min(n)` | Minimum size — will never shrink below this. |
| `Max(n)` | Maximum size — will never exceed this. |
| `Fill(weight)` | Distributes remaining space proportionally among all `Fill` elements by weight. Only expands into excess space. |

**Caution**: `Ratio` and `Percentage` are defined relative to the parent's total size, not the remaining space. Mixing them with `Length` in the same layout can produce unexpected results. Use nested layouts instead.

The order of constraints is the order in which they map to the returned rectangles.

By default, `split` allocates any remaining space to the last area. To prevent this, add `Min(0)` as the final constraint.

Ratatui uses the **Cassowary** constraint solver algorithm internally. When constraints conflict, the solver returns an approximate solution.

### Nesting Layouts

Complex UIs are built by nesting layouts — split the outer area, then split inner areas:

```rust
let outer = Layout::vertical([
    Constraint::Percentage(50),
    Constraint::Percentage(50),
]).split(frame.area());

let inner = Layout::horizontal([
    Constraint::Percentage(25),
    Constraint::Percentage(75),
]).split(outer[1]);

frame.render_widget(top_widget, outer[0]);
frame.render_widget(sidebar_widget, inner[0]);
frame.render_widget(main_widget, inner[1]);
```

### Flex

The `Flex` system controls how elements are positioned when constraints don't perfectly fill the available area:

| Variant | Behavior |
|---|---|
| `Flex::Legacy` | Fills available space, putting excess into the last element |
| `Flex::Start` | Aligns items to the start |
| `Flex::End` | Aligns items to the end |
| `Flex::Center` | Centers items within the container |
| `Flex::SpaceBetween` | Distributes excess space between elements |
| `Flex::SpaceAround` | Distributes excess space around elements |

Use `.spacing(n)` to add automatic gaps between elements:

```rust
let layout = Layout::horizontal([Length(10), Length(10)])
    .flex(Flex::Center)
    .spacing(2)
    .split(area);
```

### Centering (v0.30+)

```rust
let centered = area.centered(Constraint::Percentage(60), Constraint::Length(5));
let h_centered = area.centered_horizontally(Constraint::Length(40));
let v_centered = area.centered_vertically(Constraint::Length(10));
```

---

## Rendering

### Immediate Mode

Ratatui uses **immediate mode rendering** — the UI is redrawn completely each frame from application state. There are no persistent widget objects that you modify between frames.

```rust
loop {
    terminal.draw(|frame| {
        if state.show_popup {
            frame.render_widget(popup, popup_area);
        } else {
            frame.render_widget(main_view, frame.area());
        }
    })?;
}
```

**Advantages**:
- UI logic directly reflects application state — no synchronization overhead
- Conditionally render widgets or change layouts freely without structural constraints

**Trade-offs**:
- You must trigger rendering explicitly — if the render thread blocks, the UI freezes
- You manage the event loop yourself (ratatui doesn't provide one)
- You design your own app architecture (ratatui provides no framework, only building blocks)

Every call to `terminal.draw()` must render **all** visible widgets, not just the ones that changed. Ratatui's diffing algorithm handles efficient terminal updates.

---

## Under the Hood

### The draw() call

When your application calls `terminal.draw(|frame| ...)`:

1. Ratatui constructs a `Frame` holding a mutable reference to an intermediate `Buffer`
2. Your closure calls `frame.render_widget()` for each widget
3. Each widget's `Widget::render()` method writes into the buffer
4. After the closure returns, `Terminal::flush()` writes the buffer to the terminal

```rust
terminal.draw(|frame| {
    frame.render_widget(Paragraph::new("Hello World!"), frame.area());
})?;
```

`frame.area()` returns a `Rect` representing the total renderable area.

### Buffer and Cells

A `Buffer` is a rectangular grid of `Cell`s representing the terminal's display area.

Each `Cell` is the smallest renderable unit, tracking:
- **symbol** — the character to display (usually 1-wide)
- **style** — foreground color, background color, modifiers (bold, italic, etc.)

```
 0 1 2 3 4 5 6 7 8 9 10 11
 H e l l o   W o r l d  !
```

Key buffer methods:
- `buf.get_mut(x, y)` — returns the `Cell` at that position for direct manipulation
- `buf.set_string(x, y, "text", style)` — writes a string starting at the given position

ANSI escape sequences embedded in cell string content are **not** rendered — style information is stored separately in the cell. Use the `ansi-to-tui` crate to convert ANSI-styled text to `Text` values before rendering.

### Double Buffering

Ratatui maintains two buffers and uses a **double buffering** approach:

1. Widgets render to the current buffer during `draw()`
2. After the closure returns, `flush()` computes a **diff** between the current and previous buffer
3. Only the changed cells are written to the terminal
4. The buffers are swapped — next frame renders to the other buffer

This diffing makes rendering efficient — unchanged regions don't produce any terminal output.

Before constructing a new `Frame`, Ratatui wipes the current buffer clean. This is why you must redraw everything each frame.

### Render Order Matters

All widgets render to the same buffer within a single `draw()` call. Later renders overwrite earlier ones at the same positions:

```rust
terminal.draw(|frame| {
    frame.render_widget(Paragraph::new("content1"), frame.area());
    frame.render_widget(Paragraph::new("content2"), frame.area());
    // Only "content2" will be visible
})?;
```

This is how popups work — render the background first, then render the popup on top. Always render `Clear` before a popup to reset the underlying cells:

```rust
frame.render_widget(Clear, popup_area);
frame.render_widget(popup_widget, popup_area);
```
