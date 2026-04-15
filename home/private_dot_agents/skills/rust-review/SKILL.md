---
name: rust-review
description: 'Review Rust code in this repository from four distinct perspectives: correctness, Rust best practices, API design, and refactoring opportunities for reducing repetition. Use this skill when the user asks for a code review, design review, code audit, API critique, or requests written review output for the Rust crates. Trigger even when the user only mentions reviewing "the Rust code", "the crates", "the backend", or asks for findings to be written into files.'
---

# Rust Review

## Overview

Review the Rust crates in this repository and write findings into a `review/` directory with one file per review angle. Treat this as a code review task: findings first, ordered by severity, with file/line references and concrete impact.

## Scope

Review the `crates/` workspace, including:

- All workspace members (library crates and binaries)
- Tests, docs, and ADRs when relevant
- Workspace manifests and tooling files if they affect developer workflow or API quality

Do not review only the diff unless the user explicitly narrows scope.

## Workflow

### 1. Build context first

- Inspect the crate structure before judging details.
- Read the main modules, tests, and docs to understand intended behavior.
- Run targeted validation when useful, usually `cargo test` and `cargo clippy --all-targets`.

### 2. Review from four separate angles

Keep the perspectives separate. A single issue can appear in more than one perspective only if the reasoning is genuinely different.

#### Correctness

Focus on:

- Bugs, panics, out-of-bounds behavior, invalid assumptions
- Behavioral regressions
- Incorrect async behavior, race conditions, or deadlocks
- SQL injection or query correctness issues
- Missing error handling for fallible operations (network, I/O, parsing)
- Missing tests for fragile behavior
- Mismatches between docs/examples and actual implementation

This file should answer: "What can break or already behaves incorrectly?"

#### Rust Best Practices

Focus on:

- Idiomatic ownership and borrowing
- Panic resistance and boundary handling
- Trait impl quality
- Builder/state patterns
- Error type design and propagation
- Async patterns and runtime usage
- Test quality and coverage gaps
- Clippy-worthy patterns, unnecessary clones, needless allocations, and maintainability concerns

This file should answer: "What is valid Rust, but not the best way to implement or maintain this?"

#### API Design

Focus on the public crate surfaces and cross-crate boundaries:

- Naming and conceptual clarity
- Separation of concerns across workspace crates
- Extensibility and forward compatibility
- Consistency across modules
- Ease of use for downstream callers (including the non-Rust apps in this repo)
- Whether defaults, constructors, and trait impls create surprising behavior
- Domain modeling quality

This file should answer: "Is this a good library API for callers to depend on?"

#### Refactoring Opportunities

Focus on simplification and opportunities to make the code cleaner and more elegant:

- Repeated logic that should be extracted into helpers, traits, or shared modules
- Duplicated branching, parsing, validation, or mapping code
- Overly complex control flow that can be flattened or decomposed
- Large functions or types carrying too many responsibilities
- Boilerplate that obscures the core behavior
- Near-duplicate tests that should become shared fixtures or table-driven cases
- Places where a small redesign would remove incidental complexity without weakening correctness

This file should answer: "Where can the code become simpler, cleaner, and more elegant through refactoring?"

### 3. Write the review output

Create `review/` at the repo root and write exactly these files:

- `review/correctness.md`
- `review/rust-best-practices.md`
- `review/api-design.md`
- `review/refactoring-opportunities.md`

Each file should:

- Start with `#` title naming the perspective
- List findings first, ordered by severity
- Include file and line references for each finding
- Explain why the issue matters
- Mention missing tests when they materially increase risk
- State explicitly if no findings were found

Keep summaries brief and secondary. Do not bury findings under long introductions.

## Output Format

Use this structure inside each file:

```md
# <Perspective>

## Findings

### 1. <Short issue title>

- Severity: high|medium|low
- File: `path:line`

<Why this is a problem, with concrete impact.>
```

If there are no findings, use:

```md
# <Perspective>

## Findings

No findings.

## Residual Risks

- <short note about untested or unreviewed areas, if any>
```

## Review Standards

- Prefer evidence over style opinions.
- Do not invent intent; infer it from code, tests, examples, and docs.
- Avoid duplicate findings across the four files unless the perspective changes the reasoning.
- Call out when a problem is covered by existing tests versus missing regression coverage.
- If you run validation commands, reflect that in the written review when relevant.
