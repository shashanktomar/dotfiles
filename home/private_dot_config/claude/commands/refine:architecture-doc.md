# Architecture Document Refinement Prompt

## Your Task

You are a principal engineer reviewing and refining architecture documentation to ensure it accurately reflects the current codebase implementation.

## Instructions

<preparation>
First, carefully read the architecture document provided in $ARGUMENTS. Then systematically analyze the current codebase to identify discrepancies.
</preparation>

<codebase_analysis>
1. **Module Structure Analysis**
   - Map the documented modules/components against actual directory structure
   - Identify new modules not mentioned in the documentation
   - Flag documented modules that no longer exist

2. **Dependencies & Relationships Analysis**
   - Verify inter-module dependencies described in the architecture
   - Check actual import statements and service dependencies
   - Validate data flow patterns described vs implemented

3. **Technology Stack Verification**
   - Confirm all mentioned technologies are actually in use
   - Identify new technologies adopted since documentation was written
   - Check version compatibility and configuration details

4. **API & Interface Analysis**
   - Verify API endpoints described match actual implementations
   - Check data models and schemas against current code
   - Validate service interfaces and contracts
</preparation>

<refinement_process>
For each discrepancy found:
1. **Document the Gap**: Clearly state what the architecture doc says vs what the code shows
2. **Analyze Impact**: Determine if this affects system understanding or future development
3. **Provide Correction**: Suggest specific text changes to align with current implementation
4. **Explain Rationale**: Brief explanation of why this change improves accuracy
</refinement_process>

## Output Requirements

<format>
Structure your response as follows:

### 📋 Architecture Document Analysis Summary
- Brief overview of the document scope and current accuracy level
- Number of discrepancies found (High/Medium/Low severity)

### 🔍 Discrepancies Found

For each issue, use this format:

**[SEVERITY] Section: [Document Section Name]**

**Current Documentation States:**
> [Quote relevant excerpt from architecture doc]

**Actual Implementation Shows:**
[Description of what the code actually implements]

**Recommended Change:**
[Specific text replacement or addition needed]

**Impact:** [Brief explanation of why this matters]

---

### ✅ Verified Sections
- List sections that accurately reflect the current implementation

### 🆕 Missing Documentation
- Components/modules/patterns found in code but not documented
- Suggest where these should be added to the architecture doc

### 📝 Refined Architecture Document
[Provide the corrected version of the architecture document with all identified issues fixed]
</format>

## Interactive Application Process

<interactive_application>
After presenting the analysis, offer to apply the recommendations interactively:

1. **Present each recommendation individually** in order of severity (High → Medium → Low)
2. **Show progress**: Display "[X/Y] Reviewing recommendation X of Y total"
3. **For each recommendation**:
   - Present the specific change clearly
   - Ask: "Would you like to apply this change? (yes/no)"
   - If yes: Apply the change to the document
   - If no: Skip to the next recommendation
   - Track which changes were applied
4. **At completion**: Summarize which recommendations were applied and which were skipped
</interactive_application>

## Analysis Guidelines

<focus_areas>
- **Accuracy**: Does the doc reflect what's actually built?
- **Completeness**: Are all significant architectural elements documented?
- **Clarity**: Would a new team member understand the system from this doc?
- **Currency**: Is the information up-to-date with recent changes?
</focus_areas>

<severity_levels>
- **High**: Major architectural misrepresentation that could mislead developers
- **Medium**: Outdated information that affects development decisions
- **Low**: Minor inconsistencies or missing details
</severity_levels>