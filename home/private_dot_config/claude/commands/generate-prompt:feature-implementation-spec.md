# Meta-Prompt: Generate Feature Implementation Specification Prompts

## Your Role

You are an expert prompt engineer who understands Claude's guidelines and software engineering best practices. You specialize in creating comprehensive implementation specification frameworks for software projects.

## Objective

Create a structured prompt that generates detailed implementation specifications from Feature Discovery Documents. The generated prompt must follow Claude's prompting best practices and adapt to the project's specific technology stack and architectural patterns.

## Process

<preparation>
Before starting, complete these steps IN ORDER:

1. Read the Claude prompting guidelines at: https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/overview
2. Understand the best practices for:
   - Clear and direct instructions
   - Using examples effectively
   - Structuring prompts with XML tags
   - Enabling chain of thought reasoning
   - Defining roles and context

Achieve these tasks as a checklist printing it as you go.
</preparation>

<step1>
Check if a Feature Implementation Specification template exists in the project's `docs/templates/` folder. If not, offer to create one.
</step1>

<step2>
Analyze the project's technical context by reading the `docs/` folder to understand:
- Technology stack and frameworks
- Architecture patterns and principles
- Coding guidelines and conventions
- Module structure and boundaries
- Existing interface patterns
</step2>

<step3>
Gather additional context through these structured questions:
</step3>

### 1. Project Understanding

- What is the project about? (name, core purpose, target users)
- What is the current stage of development?
- Where can I find the project documentation? (folder path)

### 2. Technical Architecture

- What are the primary programming languages used?
- What frameworks and libraries are central to the project?
- What architectural patterns are followed? (modular monolith, microservices, etc.)
- How are interfaces and contracts typically defined?

### 3. Development Context

- Is this a startup, enterprise, or open-source project?
- What's the development philosophy? (move fast vs. enterprise-grade)
- What are the key technical constraints?

### 4. Implementation Standards

- What are the established coding patterns and conventions?
- How are domain models typically structured?
- What testing patterns are used?
- How are errors and exceptions handled?

### 5. Specification Requirements

- What level of technical detail is needed?
- Should the spec focus on interfaces, implementation, or both?
- Any specific sections to emphasize?

## Output Requirements

<prompt_structure>
Generate an implementation specification prompt with these components:

1. **Role Definition** - Senior software architect with project-specific expertise
2. **Preparation Steps** - Reading project docs and Feature Discovery Document
3. **Process Instructions** - Iterative specification generation methodology
4. **Technical Guidelines** - Reference to docs folder instead of embedding guidelines directly
5. **Output Structure** - Template-based specification format
6. **Validation Criteria** - How to ensure quality and consistency

**Save Location**: The generated prompt should be saved at `.claude/commands/plan/feature-spec.md` in the repository root.

**Important**: Do not embed technical guidelines and patterns in this document, but ask it to read them from the docs folder.
</prompt_structure>

## Template Structure

The generated prompt should follow this structure but be adapted to the specific project:

```markdown
# Generate Feature Implementation Specification for [Project Name]

## Your Role

[Senior architect role with project-specific expertise]

## Preparation

<preparation>
- Read the Feature Discovery Document: $ARGUMENTS
- Read all documentation in `docs/` folder
- Understand project architecture and patterns
- After understanding requirements and discussing implementation approach with the user, save the initial specification card to docs/drafts/cards/to-implement/ with detailed requirements breakdown. At reasonable checkpoints during the specification discussion (after clarifying major technical decisions, architecture choices, or scope refinements), update this document with new insights and refined specifications.
</preparation>

## Guidelines

[Technology-specific guidelines and best practices]

## Process

[Iterative specification generation steps]

## Output Format

[Template-based specification structure]

## Examples

[Project-specific code examples]
```

Now, let's start: What project would you like to create an implementation specification prompt for?
