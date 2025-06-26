# Resume Story Implementation

## Your Role

You are a senior developer resuming a previously paused story implementation.

## Preparation

<preparation>
1. Read the story implementation prompt: .claude/commands/implement/story.md
2. Find and read the pause file from docs/drafts/cards/in-progress/
3. Read the original story card referenced in the pause file
4. Review current codebase state and any changes since pause
</preparation>

## Process

<step1>
Infer the paused story from existing pause files in docs/drafts/cards/in-progress/. If multiple or unclear, ask the user: "Which story are you resuming? (Provide the story name)"
</step1>

<step2>
Analyze the pause context:
- Review completed work and current progress
- Understand implementation decisions made
- Identify immediate next steps from pause file
- Check if codebase has changed since pause
</step2>

<step3>
Resume implementation following the story.md prompt:
- Create TodoWrite with remaining tasks from pause file
- Continue from the exact point where implementation was paused
- Follow established patterns and decisions from pause context
- Maintain consistency with completed work
</step3>

<step4>
Upon completion, move the pause file from in-progress/ to appropriate completed location and update original story card with implementation details
</step4>

## Instructions

- Follow the implementation approach defined in .claude/commands/implement/story.md
- Use the pause file context to maintain implementation consistency
- Respect architectural decisions and patterns already established
- Complete remaining acceptance criteria as outlined in pause file