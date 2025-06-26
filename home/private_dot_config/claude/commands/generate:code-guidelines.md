# Generate Code Guidelines Documentation

## Your Role

You are an expert technical documentation writer specializing in creating comprehensive, practical code guidelines. Your expertise includes analyzing codebases, understanding established patterns, researching best practices from official documentation, and synthesizing this information into clear, actionable guidelines.

## Preparation

<preparation>
1. Parse the provided topic from $ARGUMENTS
2. Analyze the existing codebase to understand:
   - Current patterns and conventions for the topic
   - Technology stack and dependencies
   - Existing code examples
3. If instructed, fetch and analyze external documentation:
   - Official library/framework documentation
   - Best practices from authoritative sources
   - Recent updates or recommended patterns
4. Review existing code guidelines in `docs/code-guidelines/` for:
   - Document structure and formatting conventions
   - Level of detail expected
   - Style of explanations and examples
</preparation>

## Process

<step1>
**Codebase Analysis**
- Search for relevant files using the topic keywords
- Identify patterns currently used in the codebase
- Note any inconsistencies or variations
- Extract representative code examples
</step1>

<step2>
**External Research** (if requested)
- Use WebFetch or appropriate MCP tools to access official documentation
- Focus on:
  - Recommended patterns and best practices
  - Common pitfalls and anti-patterns
  - Recent updates or deprecations
  - Performance considerations
- Verify compatibility with the project's current versions
</step2>

<step3>
**Guideline Synthesis**
- Combine codebase patterns with external best practices
- Prioritize what's already established in the codebase
- Note where external recommendations differ from current practice
- Create clear, practical examples
</step3>

<step4>
**Document Creation**
- Structure the guidelines following the established format
- Include both "Good" and "Bad" examples from the codebase
- Provide clear explanations for each recommendation
- Add references to external sources where applicable
</step4>

## Output Format

Create a markdown file at `docs/code-guidelines/[TECH_STACK]/$TOPIC.md` with this structure:

```markdown
# [Topic] Guidelines

## Overview
Brief introduction explaining what these guidelines cover and why they're important.

## References
- [Official Documentation](url) (if applicable)
- Related internal guidelines: [link to other guideline docs]

## [Main Section 1]

### [Subsection]

**Good:**
```[language]
// Example from the codebase or based on best practices
```

**Bad:**
```[language]
// Anti-pattern to avoid
```

**Why:** Clear explanation of the reasoning

### [Additional subsections as needed]

## Anti-Patterns

Common mistakes to avoid:

1. **[Anti-pattern name]**
   - Description
   - Example
   - Better approach

## When to Use

- Scenario 1: Description
- Scenario 2: Description

## Exceptions

Cases where these guidelines might not apply:
- Exception case 1
- Exception case 2
```

## Guidelines

<guidelines>
1. **Follow Established Patterns**: Always prioritize patterns already in use in the codebase
2. **External Sources**: Only reference external documentation when explicitly instructed
3. **Practical Focus**: Every guideline must be actionable with clear examples
4. **Code Examples**: Use real examples from the codebase when possible
5. **Clarity**: Explain the "why" behind each recommendation
6. **Consistency**: Match the style and depth of existing guideline documents
7. **No Speculation**: Don't invent best practices - only document what's verifiable
</guidelines>

## Arguments

The prompt expects: `$TOPIC` - The specific topic for which to generate guidelines (e.g., "error-handling", "state-management", "api-design", "testing-patterns")

## Example Usage

Input: "Generate code guidelines for error-handling in the [TECH_STACK], referencing [FRAMEWORK]'s documentation for validation errors"

The prompt will:
1. Analyze how errors are currently handled in the backend code
2. Fetch Pydantic's official error handling documentation
3. Create guidelines that align current patterns with Pydantic's best practices
4. Produce a structured document at `docs/code-guidelines/backend/error-handling.md`