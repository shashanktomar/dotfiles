# Codebase Deep Dive Analysis

<role>
You are a principal engineer conducting a comprehensive technical analysis of a codebase to create thorough, accurate documentation for team onboarding and knowledge transfer. This document target other principal engineers and not the junior devs in the team.
</role>

## Overview

This command performs an in-depth exploration of a codebase, producing structured documentation that captures architecture, components, patterns, and technical decisions.

## Step 1: Setup Analysis Location

<setup>
Ask the user: "Where would you like to save the codebase analysis documentation?"

Expected format: A directory path (e.g., `docs/analysis`, `.analysis`, `architecture-docs`)

Create the directory structure:

```
{analysis-dir}/
├── 00-overview.md
├── 01-architecture.md
├── 02-tech-stack.md
├── components/
│   └── [component-name].md
└── patterns/
    └── [pattern-name].md
```

</setup>

## Step 2: Initial Codebase Reconnaissance

<reconnaissance>
Before deep analysis, build a comprehensive understanding:

1. **Project Structure Discovery**
   - Identify all package.json, pom.xml, build.gradle, Cargo.toml, go.mod, or similar files
   - Map directory structure and module boundaries
   - Find build configuration and scripts
   - Locate test directories and patterns

2. **Documentation Review**
   - Read existing README files at all levels
   - Review ARCHITECTURE.md, CONTRIBUTING.md, and similar docs
   - Examine inline code documentation and comments
   - Check for ADRs (Architecture Decision Records)

3. **Dependency Analysis**
   - List all external dependencies and their versions
   - Identify frameworks and libraries in use
   - Map internal module dependencies
   - Note any monorepo or multi-package structure

4. **Entry Points Identification**
   - Find main application entry points
   - Locate API definitions (REST, GraphQL, gRPC, etc.)
   - Identify CLI commands or executable scripts
   - Map background jobs, workers, or scheduled tasks

Achieve these tasks as a checklist, printing progress as you go.
</reconnaissance>

## Step 3: Create High-Level Overview

<overview-document>
Create `{analysis-dir}/00-overview.md` with:

### Document Structure

# Codebase Overview

## Project Purpose

[2-3 paragraphs explaining what this project does, its primary use cases, and target users]

## Core Components

[For each major component, provide:]

### [Component Name]

- **Purpose**: One-line description
- **Location**: Directory path(s)
- **Responsibility**: What it owns and manages
- **Key Technologies**: Primary frameworks/libraries used
- **External Interactions**: What it communicates with

## System Boundaries

### Internal Services/Modules

[List all internal components and their relationships]

### External Dependencies

[APIs, databases, message queues, third-party services]

### Data Flow

[High-level description of how data moves through the system]

## Development Setup

- Build system and commands
- Testing approach
- Key scripts and tools

---

**Requirements for this document:**

- Be factual and precise - cite specific files/directories
- Use concrete examples from the codebase
- Aim for 1500-2500 words
- Focus on the "what" and "why", not implementation details
  </overview-document>

## Step 4: Create Architecture Diagram

<architecture-diagram>
Create `{analysis-dir}/01-architecture.md` with ASCII diagram:

### Document Structure

# System Architecture

## Component Interaction Diagram

```
[Create detailed ASCII diagram showing:]
- All major components as boxes
- Communication paths with arrows
- Protocols/mechanisms labeled (HTTP, gRPC, events, etc.)
- External systems at boundaries
- Data stores and their connections
- Background processes and their triggers
```

## Component Responsibilities

[For each component in diagram:]

### [Component Name]

- **Handles**: Specific responsibilities
- **Exposes**: APIs, interfaces, events
- **Consumes**: What it depends on
- **State Management**: How it stores/manages data

## Communication Patterns

### Synchronous

[HTTP endpoints, RPC calls, direct function calls]

### Asynchronous

[Events, message queues, webhooks]

### Data Access

[Database queries, caching layers, file system access]

## Deployment Architecture

[If discernible: how components are deployed, containerization, orchestration]

---

**Requirements:**

- Diagram must accurately represent actual code structure
- Verify all connections by examining actual imports/calls
- Include both runtime and build-time relationships
- Label all arrows with specific mechanisms (e.g., "POST /api/users", "UserCreated event")
  </architecture-diagram>

## Step 5: Create Tech Stack Document

<tech-stack-document>
Create `{analysis-dir}/02-tech-stack.md`:

### Document Structure

# Technology Stack

## Languages

- **Primary**: [Language and version]
- **Secondary**: [Other languages used and where]
- **Build-time**: [Languages for tooling, scripts]

## Frameworks & Libraries

### [Category - e.g., Web Framework, Testing, etc.]

| Library | Version | Purpose | Used In |
| ------- | ------- | ------- | ------- |
| [name]  | [ver]   | [why]   | [where] |

[Repeat for all categories:]

- Application Frameworks
- Testing Frameworks
- Database/ORM
- API/Networking
- Authentication/Authorization
- Logging/Monitoring
- Build Tools
- Development Tools

## Infrastructure & Services

### Databases

- Type, version, purpose, access patterns

### Caching

- Technologies used, strategies, invalidation patterns

### Message Queues / Event Systems

- Technologies, patterns, use cases

### External Services

- Third-party APIs and integrations

## Development Tooling

- Package manager(s)
- Build system
- Test runners
- Linters/formatters
- CI/CD tools (if configured)

## Version Requirements

- Runtime version requirements
- Compatibility constraints
- Known version-specific issues (if documented)

---

**Requirements:**

- Extract versions directly from dependency files
- Explain WHY each technology is used, not just THAT it's used
- Note any unusual or interesting technology choices
- Identify potential tech debt or version mismatches
  </tech-stack-document>

## Step 6: Component Deep Dive

<component-analysis>
For each component identified in overview:

### Process

1. **Code Examination**
   - Read all source files in component
   - Understand data structures and models
   - Map internal module structure
   - Identify key algorithms and business logic

2. **Create Component Document**: `{analysis-dir}/components/{component-name}.md`

### Component Document Structure

# [Component Name]

## Purpose & Scope

[Detailed explanation of what this component does and its boundaries]

## Directory Structure

```
[Tree view of component's file organization]
```

## Key Modules/Classes

### [Module/Class Name]

**File**: `path/to/file.ts:lineNumber`
**Purpose**: What it does
**Key Methods/Functions**:

- `functionName()`: Description and when it's called
  **Dependencies**: What it imports and uses
  **Used By**: What depends on this module

[Repeat for all significant modules]

## Data Models

### [Model/Entity Name]

**Definition**: `path/to/definition:line`
**Fields**: Key fields and their types
**Validation**: Rules and constraints
**Lifecycle**: How instances are created, modified, destroyed

## API Surface

### Public Interfaces

[Functions, classes, endpoints this component exposes]

### Internal Interfaces

[Private APIs used within component]

## Dependencies

### External Libraries

[Third-party dependencies specific to this component]

### Internal Dependencies

[Other components this depends on]

## Configuration

[How this component is configured, config files, environment variables]

## Testing Approach

[Test files location, coverage, testing patterns used]

## Notable Patterns

[Design patterns, architectural decisions, interesting implementations]

## Potential Issues

[Technical debt, TODOs, areas of concern found during analysis]

---

**Requirements:**

- Include specific file paths and line numbers for all references
- Cite actual code snippets for complex patterns
- Aim for 1000-2000 words per component
- Be thorough but concise

### Refinement

3. **Cross-Reference with Overview**
   - Compare component details with `00-overview.md`
   - Update overview if findings contradict initial understanding
   - Ensure consistency in terminology and component boundaries
   - Add any missed relationships or interactions

4. **Document Updates**
   - Note what was refined: "Updated overview to reflect [specific finding]"
   - Ensure architecture diagram reflects actual component structure

Achieve these tasks as a checklist for each component, printing progress as you go.
</component-analysis>

## Step 7: Cross-Cutting Patterns Analysis

<patterns-analysis>
Examine the codebase for cross-cutting concerns and create dedicated documents:

### Required Pattern Documents

Create `{analysis-dir}/patterns/[pattern-name].md` for:

1. **Configuration Management** (`configuration-management.md`)
2. **Error Handling** (`error-handling.md`)
3. **Logging & Observability** (`logging-observability.md`)
4. **Authentication & Authorization** (`auth.md`) - if present
5. **Data Validation** (`data-validation.md`)
6. **Testing Strategy** (`testing-strategy.md`)
7. **Communication Patterns** (`communication-patterns.md`)
8. **State Management** (`state-management.md`)
9. **Event Handling** (`event-handling.md`) - if event-driven
10. **API Design Conventions** (`api-conventions.md`) - if applicable

### Pattern Document Structure

# [Pattern Name]

## Overview

[What this pattern addresses and why it exists in this codebase]

## Implementation Approach

[How this concern is handled across the codebase]

## Key Components/Utilities

### [Utility/Module Name]

**Location**: `path/to/file:line`
**Purpose**: What it provides
**Usage Pattern**: How to use it
**Example**:

```[language]
[Real code example from codebase]
```

## Conventions & Standards

[Rules and patterns developers should follow]

## Examples Across Codebase

### Example 1: [Scenario]

**Location**: `path/to/example:line`
**Pattern**:

```[language]
[Actual code snippet]
```

**Explanation**: Why this approach was taken

[Repeat for 3-5 representative examples]

## Variations

[Different approaches used in different contexts and why]

## Anti-Patterns Found

[Instances where pattern is violated or could be improved]

## Recommendations

[Suggestions for consistency or improvement]

---

**Requirements for Each Pattern:**

- Find ALL instances of this pattern across the codebase
- Show evolution - note if pattern changes over time
- Identify inconsistencies between components
- Provide actionable guidelines for future development
- Include 5-10 concrete code examples with file references

### Pattern Discovery Process

1. **Identify Pattern**
   - Search for pattern implementations across all components
   - Note variations and inconsistencies
   - Find framework/library patterns in use

2. **Document Pattern**
   - Create pattern document with examples
   - Link to specific files and line numbers
   - Explain rationale where discernible

3. **Cross-Reference**
   - Update component documents to reference pattern docs
   - Note pattern usage in overview if architecturally significant

Achieve these as a checklist, printing progress as you go.
</patterns-analysis>

## Step 8: Final Review & Validation

<final-review>
Before completing:

1. **Consistency Check**
   - All component names match across documents
   - Architecture diagram matches component documents
   - Tech stack aligns with actual usage in components
   - All cross-references are valid

2. **Accuracy Verification**
   - Revisit 3-5 random code files to verify documentation accuracy
   - Ensure no major components were missed
   - Validate that patterns are consistently described

3. **Completeness Check**
   - All components have dedicated documents
   - All major patterns are documented
   - Directory structure is organized and navigable
   - Overview provides clear entry point

4. **Create Index**
   - Update `{analysis-dir}/README.md` with:
     - Navigation to all documents
     - Reading order recommendation
     - Last updated timestamp
     - Brief summary of analysis scope

Print final checklist results.
</final-review>

## Quality Standards

<quality-standards>
Throughout this analysis:

**Accuracy Over Speed**

- Verify every claim by examining actual code
- Cite specific files and line numbers
- If uncertain, investigate deeper before documenting

**Depth Over Breadth**

- Better to thoroughly document 80% than superficially document 100%
- Include concrete examples, not abstract descriptions
- Show real code snippets, not pseudo-code

**Actionable Insights**

- Documentation should help developers navigate and understand
- Highlight patterns to follow and anti-patterns to avoid
- Note areas of technical debt or confusion

**Consistency**

- Use same terminology throughout all documents
- Maintain consistent document structure
- Keep formatting uniform

**Evidence-Based**

- Every statement should reference actual code
- Use quantitative measures where possible (e.g., "47 API endpoints", not "many endpoints")
- Distinguish between what code does vs. what comments claim
  </quality-standards>

## Output Summary

<completion>
When analysis is complete, provide:

1. **Document Count Summary**
   - Overview documents created: [count]
   - Component documents created: [count]
   - Pattern documents created: [count]
   - Total files analyzed: [approximate count]

2. **Key Findings**
   - Most complex component
   - Most common patterns
   - Potential areas of concern
   - Architectural highlights

3. **Next Steps**
   - Recommended reading order for new team members
   - Areas that may need deeper investigation
   - Suggestions for documentation improvements
     </completion>
