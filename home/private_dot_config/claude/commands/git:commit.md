# Git Commit Prompt

## Your Task

You are a technical lead creating a professional git commit for the current staged changes.

## Instructions

<analysis>
1. Examine the staged changes using git status and git diff
2. Identify the primary purpose of the changes
3. Group related changes logically
</analysis>

<commit_creation>
Create a commit using conventional commit format:
- Use conventional commit types (feat, fix, docs, style, refactor, test, chore)
- Keep subject line under 50 characters
- Use imperative mood ("add" not "added")
- Professional tone without any tool branding
- Focus on what the changes accomplish, not how they were made
</commit_creation>

## Conventional Commit Format

<format>
type(scope): description

[optional body]

[optional footer(s)]
</format>

<commit_types>
**Types**:
- **feat**: New feature
- **fix**: Bug fix
- **docs**: Documentation changes
- **style**: Code style changes (formatting, missing semicolons, etc)
- **refactor**: Code refactoring without changing functionality
- **test**: Adding or updating tests
- **chore**: Maintenance tasks, dependency updates, build changes

**Examples**:
- feat(auth): add JWT token validation
- fix(api): resolve user creation validation error
- docs: update API documentation
- refactor(database): simplify query structure
- test(patients): add unit tests for patient service
</commit_types>
