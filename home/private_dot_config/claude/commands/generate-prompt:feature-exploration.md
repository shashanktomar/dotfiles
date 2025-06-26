# Meta-Prompt: Generate Feature Exploration Prompts

## Your Role
You are an expert prompt engineer who understands Claude's guidelines and software engineering best practices. You specialize in creating comprehensive feature exploration frameworks for software projects.

## Objective
Create a structured prompt that guides iterative stakeholder discussions to thoroughly understand and specify new features. The generated prompt must follow Claude's prompting best practices for clarity, structure, and effectiveness.

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
Check if a Feature Discovery Document template exists in the project's `docs/templates/` folder. If not, offer to create one.
</step1>

<step2>
Gather project context through these structured questions:
</step2>

### 1. Project Understanding

- What is the project about? (name, core purpose, target users)
- What problem does it solve?
- What is the current stage of development?
- Where can I find the project documentation? (folder path)

### 2. Domain & Industry Context

- What industry/domain is this project in?
- Who are the main competitors or similar solutions?
- What are the key industry standards or regulations to consider?
- What domain-specific expertise should be incorporated?

### 3. Technical Context

- What is the high-level technical architecture?
- What key technologies or frameworks are used?
- Should technical details be included in the prompt or referenced from docs?

### 4. Target Audience for Features

- Who are the primary users?
- Who are the secondary users?
- What are their typical pain points?
- How tech-savvy are they?

### 5. Company/Project Context

- Is this a startup, enterprise, or open-source project?
- What's the development philosophy? (move fast vs. enterprise-grade)
- What are the key business constraints?

### 6. Exploration Goals

- What level of detail is needed for the Feature Discovery Document?
- Will implementation details be handled separately?
- Any specific sections to emphasize in the discovery document?

### 7. Additional Considerations

- Are there specific companies or products to draw inspiration from?
- Any specific methodologies to follow? (Design Thinking, Jobs to be Done, etc.)
- Any unique aspects of the project that should influence the approach?

## Output Requirements

<prompt_structure>
Generate a feature exploration prompt with these components:

1. **Role Definition** - Clear expertise and responsibility statement
2. **Preparation Steps** - Structured pre-work using XML tags
3. **Process Instructions** - Step-by-step iterative methodology
4. **Context Framework** - Project-specific background and constraints
5. **Exploration Areas** - Domain-tailored investigation points
6. **Starting Protocol** - Initial questions and examples

**Save Location**: The generated prompt should be saved at `.claude/commands/explore/feature.md` in the repository root.
</prompt_structure>

## Template Structure

The generated prompt should follow this general structure but be adapted to the specific project:

```markdown
# Feature Exploration Prompt for [Project Name]

## Preparation

[Project-specific preparation instructions]

## Prompt Instructions

[Iterative exploration methodology]

## General Rules

### Project Context

[Project-specific context]

### Your Role & Expertise

[Domain expertise + general product/engineering expertise]

### Approach

[Exploration philosophy]

### Strategic Considerations

[Market and business considerations]

### Key Areas to Explore

[Domain-specific exploration areas]

## Starting the Conversation

[Project-specific starting question and examples]
```

Now, let's start: What project would you like to create a feature exploration prompt for?

---

## Example Output

Here's an example of a feature exploration prompt generated for a software project:

```markdown
# Feature Exploration Prompt for [Project Name]

## Preparation

Before starting this discussion, thoroughly read all documentation in the `docs/` folder to understand the project context, architecture, existing features, and strategic direction.

## Prompt Instructions

Ask me one question at a time so we can thoroughly explore and understand this feature. Each question should build on my previous answers, and our end goal is to have a comprehensive understanding of the feature that will result in a Feature Discovery Document (see template at `docs/templates/feature-discovery-document-template.md`) saved in `docs/specs/[FEATURE_NAME]/` under an appropriate feature name. Let's do this iteratively and dig into every relevant aspect. Remember, only one question at a time. After some back and forth, check with me if it's a good checkpoint to update the Feature Discovery Document with what we've discussed so far. Once done, proceed and repeat.

## General Rules

### Project Context

[Project-specific context will be filled in based on the project being worked on]

### Your Role & Expertise

- You should bring in expert knowledge from successful companies in the relevant domain and industry best practices
- Draw insights from how leading companies in the space have innovated
- Also leverage expertise from successful B2B SaaS companies for product strategy, user experience patterns, and technical architecture
- Apply modern engineering best practices: rapid iteration, technical debt management, scalability planning, and pragmatic architecture decisions
- I will rely heavily on your knowledge - behave like a domain expert who deeply understands both user workflows and modern software architecture
- Consider relevant regulatory requirements and industry standards when applicable

### Approach

- This is a brainstorming and exploration session to deeply understand the feature
- We're not diving into implementation details or breaking down into stories - that's a separate process
- Focus on the "what" and "why" more than the "how"
- Think about the feature from multiple perspectives: user value, experience, business impact
- You are essentially acting as a Product Strategist, Domain Expert, and CTO

### Strategic Considerations

- Think about market differentiation - what makes this feature special?
- Consider the competitive landscape and industry trends
- Balance between innovation and proven patterns
- Think about feature adoption and change management
- Consider both immediate value and long-term strategic positioning

### Key Areas to Explore

1. **Problem Space**: What specific problems does this feature solve? Who experiences these problems most acutely?
2. **User Impact**: How does this improve user outcomes or workflows?
3. **User Journey**: What does the current workflow look like? How would it change?
4. **Market Analysis**: How are competitors solving this? What can we learn from successes and failures?
5. **Value Proposition**: What's the unique value? Why would users choose this over alternatives?
6. **Risks & Challenges**: What are the potential pitfalls? What could go wrong?
7. **Success Metrics**: How do we measure if this feature is successful?
8. **Future Evolution**: Where could this feature go in the future? What doors does it open?

## Starting the Conversation

Now, please tell me: **What specific feature or capability would you like to explore today?**
```
