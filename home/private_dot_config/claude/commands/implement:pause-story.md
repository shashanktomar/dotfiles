# Pause Story Implementation

## Your Role

You are a senior developer pausing current story implementation and capturing state for future resumption.

## Preparation

<preparation>
1. Read the story implementation prompt: .claude/commands/implement/story.md
2. Use TodoRead to understand current progress
3. Examine recent git changes and current codebase state
4. Identify the story card being worked on
</preparation>

## Process

<step1>
Infer the current story from TodoRead and recent git activity. If unclear, ask the user: "Which story are you pausing? (Provide the story name)"
</step1>

<step2>
Analyze current implementation state:
- Review completed vs remaining acceptance criteria
- Identify files modified during implementation
- Note any implementation decisions or patterns used
- Capture any blockers or pending technical decisions
</step2>

<step3>
Create pause snapshot with this structure:

```markdown
# [Story Name] - PAUSED

## Story Reference
- **Original Card**: [path to original card]
- **Story Prompt**: .claude/commands/implement/story.md
- **Paused Date**: [current date]

## Current Progress

### ✅ Completed
- [List completed acceptance criteria]
- [List completed implementation tasks]
- [List completed tests]

### 🚧 In Progress
- [Current task being worked on]
- [Partial implementations]
- [Draft code or configurations]

### ⏸️ Remaining
- [Uncompleted acceptance criteria]
- [Pending implementation tasks]
- [Required tests not yet written]

## Context for Resume

### Implementation Notes
- [Key implementation decisions made]
- [Architecture patterns used]
- [Dependencies added or modified]

### Blockers & Challenges
- [Any issues encountered]
- [Technical decisions pending]
- [External dependencies waiting]

### Next Steps
- [Immediate next task to pick up]
- [Priority order for remaining work]

## Files Modified
- [List of files changed during implementation]
- [Configuration files updated]
- [New files created]

## Resume Instructions
To resume this story, use the `implement:resume-story` prompt with this pause file.
```
</step3>

<step4>
Save the pause snapshot to: `docs/drafts/cards/in-progress/[STORY_NAME].md`
</step4>

## Instructions

- Reference original card location, don't duplicate content
- Focus on implementation state and technical context
- Capture specific decisions needed for seamless resumption
- Include files modified and patterns established