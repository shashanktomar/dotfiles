---
name: ratatui
description: "Build terminal user interfaces with Ratatui in Rust. Use this skill whenever the user mentions ratatui, TUI apps in Rust, terminal UI, or wants to build interactive CLI applications with widgets, layouts, and event handling. Also trigger when you see ratatui in Cargo.toml or imports like `use ratatui::`. Even if the user just asks a question about how ratatui works internally, use this skill."
---

# Ratatui TUI Development

This skill helps you build production-quality terminal UIs with Ratatui (v0.30+) in Rust.

## ratatui-cheese widget library

We maintain a custom widget library called [ratatui-cheese](https://github.com/shashanktomar/ratatui-cheese) (local: `/Users/shashank/personal/code/projects/ratatui-cheese`). When building TUI features:

- **Prefer widgets from `ratatui-cheese`** over building custom widgets from scratch.
- If a needed widget is generic enough to be reusable, it should be created in `ratatui-cheese`, not in the consuming project. That development happens separately.
- Check what's available in `ratatui-cheese` before implementing new widgets.

## Before starting any task

Check the ratatui changelog at https://ratatui.rs/highlights/ for the latest version's changes before writing code. APIs evolve between releases — verify that the methods, types, and patterns you plan to use match the version in the user's `Cargo.toml`.

## When to load reference files

Read the relevant reference file based on what the user needs:

| User is asking about... | Read |
|---|---|
| How ratatui works, concepts, internals, widgets, layout system, rendering, buffers, terminal fundamentals | `references/concepts.md` |
| Starting a new project, choosing an app pattern, project structure, backends | `references/project-setup.md` |
| Event handling, key events, mouse events, crossterm, async events, channels, background tasks, render strategy | `references/eventing.md` |
| Popups, overlays, styling, text composition, scrolling, custom widgets, Block usage, dynamic layouts | `references/recipes.md` |
| Testing, unit tests, widget tests, snapshot tests, integration tests, test helpers | `references/testing.md` |
| Logging, tracing, debugging, log files, tracing-subscriber, performance profiling | `references/logging.md` |
| Error handling, panic hooks, terminal restoration, color-eyre, thiserror, Result types | `references/error-handling.md` |
| Config files, CLI arguments, TOML, clap, config merging, user state, directories | `references/config.md` |
