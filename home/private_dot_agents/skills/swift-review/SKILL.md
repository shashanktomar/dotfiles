---
name: swift-review
description: 'Review Swift code in this repository from five distinct perspectives: correctness, Swift best practices, API design, refactoring opportunities, and iOS platform compliance. Use this skill when the user asks for a code review, design review, code audit, API critique, or requests written review output for the Swift code. Trigger even when the user only mentions reviewing "the Swift code", "the app", "the iOS code", or asks for findings to be written into files.'
---

# Swift Review

## Overview

Review the Swift code in this repository and write findings into a `review/` directory with one file per review angle. Treat this as a code review task: findings first, ordered by severity, with file/line references and concrete impact.

## Scope

Review the Swift source code, including:

- All targets (app, frameworks, extensions, packages)
- Tests, docs, and architecture decision records when relevant
- Package manifests, project configuration, and tooling files if they affect developer workflow or API quality

Do not review only the diff unless the user explicitly narrows scope.

## Workflow

### 1. Build context first

- Inspect the project structure before judging details.
- Read the main modules, views, models, and tests to understand intended behavior.
- Run targeted validation when useful, usually `swift build` and `swift test`.

### 2. Review from five separate angles

Keep the perspectives separate. A single issue can appear in more than one perspective only if the reasoning is genuinely different.

#### Correctness

Focus on:

- Bugs, crashes, force-unwrap risks, out-of-bounds behavior, invalid assumptions
- Behavioral regressions
- Incorrect concurrency behavior: data races, actor isolation violations, Sendable conformance gaps, deadlocks
- Missing error handling for fallible operations (network, I/O, parsing, decoding)
- Core Data / SwiftData consistency and migration issues
- Missing tests for fragile behavior
- Mismatches between docs/examples and actual implementation

This file should answer: "What can break or already behaves incorrectly?"

#### Swift Best Practices

Focus on:

- Idiomatic Swift: value types vs reference types, optionals, pattern matching
- Protocol-oriented design and protocol conformance quality
- Error type design and propagation (`throws`, typed throws, `Result`)
- Swift concurrency: structured concurrency, `async`/`await`, actors, `@Sendable`, task groups
- Memory management: retain cycles, weak/unowned usage, closure capture lists
- Generics and type safety
- Test quality and coverage gaps
- SwiftLint-worthy patterns, unnecessary allocations, and maintainability concerns

This file should answer: "What is valid Swift, but not the best way to implement or maintain this?"

#### API Design

Focus on the public surfaces, module boundaries, and cross-target interfaces:

- Naming and conceptual clarity (Swift API Design Guidelines compliance)
- Separation of concerns across modules and targets
- Extensibility and forward compatibility
- Consistency across modules
- Ease of use for downstream callers
- Whether defaults, initializers, and protocol conformances create surprising behavior
- Domain modeling quality

This file should answer: "Is this a good API for callers to depend on?"

#### Refactoring Opportunities

Focus on simplification and opportunities to make the code cleaner and more elegant:

- Repeated logic that should be extracted into helpers, protocols, extensions, or shared modules
- Duplicated branching, parsing, validation, or mapping code
- Overly complex control flow that can be flattened or decomposed
- Large types or functions carrying too many responsibilities
- Boilerplate that obscures the core behavior
- Near-duplicate tests that should become shared fixtures or parameterized cases
- Places where a small redesign would remove incidental complexity without weakening correctness

This file should answer: "Where can the code become simpler, cleaner, and more elegant through refactoring?"

#### iOS Platform Compliance

**Before writing findings for this section, look up the latest Apple documentation** using web search for any APIs, frameworks, or platform features referenced in the codebase. Verify against current iOS SDK docs, WWDC sessions, and Apple Human Interface Guidelines. Flag anything that relies on deprecated APIs or patterns that Apple has superseded.

Focus on:

- Deprecated API usage: UIKit, SwiftUI, Foundation, Combine, or other framework APIs that Apple has deprecated or replaced
- iOS version compatibility: minimum deployment target alignment, availability checks (`@available` / `#available`)
- App lifecycle correctness: scene lifecycle, background execution, state restoration
- Privacy and permissions: Info.plist declarations, purpose strings, App Tracking Transparency, required entitlements
- SwiftUI best practices: proper use of state management (`@State`, `@Binding`, `@Observable`, `@Environment`), view identity, performance (lazy stacks, task modifiers)
- UIKit integration: correct UIViewRepresentable / UIViewControllerRepresentable patterns
- App Store compliance risks: private API usage, undocumented behavior, missing required capabilities
- Accessibility: VoiceOver support, Dynamic Type, sufficient contrast
- Performance: main thread usage, large allocations on the main actor, excessive view redraws

This file should answer: "Does this code follow current Apple platform guidance and will it pass App Store review?"

### 3. Write the review output

Create `review/` at the repo root and write exactly these files:

- `review/correctness.md`
- `review/swift-best-practices.md`
- `review/api-design.md`
- `review/refactoring-opportunities.md`
- `review/ios-platform-compliance.md`

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
- Avoid duplicate findings across the five files unless the perspective changes the reasoning.
- Call out when a problem is covered by existing tests versus missing regression coverage.
- If you run validation commands, reflect that in the written review when relevant.
- For iOS Platform Compliance, always cite the Apple documentation source when flagging deprecated or incorrect API usage.
