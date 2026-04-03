---
name: architecture-doc
description: Generate comprehensive ARCHITECTURE.md documentation for code repositories. Use this skill when users want to document the high-level architecture of a project, create architectural overviews for open-source projects, or need to understand and map the structure of an existing codebase. Produces well-structured documentation following industry best practices from the Rust ecosystem.
---

# Architecture Documentation Generator

This skill generates high-quality ARCHITECTURE.md files for code repositories, following the philosophy and structure advocated by matklad (rust-analyzer maintainer). The goal is to bridge the gap between occasional contributors and core developers by providing a mental map of the codebase.

## When to Use This Skill

Generate ARCHITECTURE.md documentation when:
- Users explicitly request "generate ARCHITECTURE.md" or "document the architecture"
- Users want to understand the high-level structure of a repository
- Creating documentation for open-source projects (10k-200k lines of code)
- Onboarding new contributors to a codebase
- Users ask "how is this project structured?" or "what's the architecture?"

## Core Philosophy

The ARCHITECTURE.md document serves a specific purpose: **provide a mental map of the codebase that answers "where's the thing that does X?" and "what does the thing I'm looking at do?"**

Key principles:
1. **Keep it short** - Every recurring contributor must read it
2. **Only document stable things** - Don't try to keep it synchronized with code; revisit a few times per year
3. **Focus on structure, not implementation** - Describe what modules do and how they relate, not how they work internally
4. **Make it navigable** - Help people find things by name using symbol search, not brittle links

## Document Structure

### 1. Bird's Eye Overview (Required)
Start with a high-level problem statement:
- What problem does this project solve?
- Who are the primary users/stakeholders?
- What is the fundamental approach or philosophy?

Keep this to 2-4 paragraphs maximum.

### 2. Codemap (Required)
The heart of the document. Create a hierarchical map of the codebase:

**Module Organization:**
- List coarse-grained modules/packages/directories
- Describe what each module is responsible for
- Show relationships and dependencies between modules
- Name important files, modules, and types (without linking directly)

**Navigation Guidance:**
- Answer: "Where do I find the code that does X?"
- Answer: "What does this module/directory do?"
- Organize logically, grouping related concepts together
- Match the actual tree structure where possible

**Naming Convention:**
- Name specific files, modules, types (e.g., "The `Parser` type in `src/parser/mod.rs`")
- Encourage using symbol search to find entities by name
- Avoid direct links that go stale
- This helps discover related, similarly-named things

### 3. Architectural Invariants (Critical)
Explicitly call out constraints and rules:

**What to include:**
- **Absence invariants** - "The model layer NEVER imports from the views layer"
- **Dependency rules** - "Core business logic has zero dependencies on framework code"
- **Data flow constraints** - "All external API calls go through the APIClient facade"
- **Concurrency rules** - "Database writes are serialized through a single writer thread"
- **Security boundaries** - "User input validation happens at the API boundary before any business logic"

**Why this matters:**
These constraints are invisible in the code (they're defined by absence) but are crucial for maintaining the architecture. New contributors won't know these unless explicitly stated.

### 4. Boundaries Between Layers/Systems (Important)
Identify and describe boundaries:

**System boundaries:**
- API boundaries between services
- Module boundaries within the application
- Abstraction layers (e.g., persistence layer, domain layer)
- External integrations

**Why boundaries matter:**
- A boundary implicitly constrains all implementations behind it
- Boundaries have "measure zero" - hard to find by randomly reading code
- Understanding boundaries helps reason about the system without reading everything

### 5. Cross-Cutting Concerns (Required)
After the codemap, add a separate section covering:

**Common patterns:**
- Error handling approach
- Logging and observability
- Configuration management
- Testing strategy and test organization
- Dependency injection patterns
- Common utilities and where to find them

**Infrastructure concerns:**
- Build system organization
- CI/CD pipeline structure
- Deployment architecture (if relevant to code organization)
- Development environment setup (only if it affects code structure)

## Analysis Methodology

When analyzing a repository, follow this systematic approach:

### Phase 1: Initial Reconnaissance
1. **Examine directory structure** - Run `tree -L 3 -I 'node_modules|target|build|dist|.git'` to understand layout
2. **Identify entry points** - Find main executables, CLI tools, API servers
3. **Check build configuration** - Look at Cargo.toml, package.json, CMakeLists.txt, etc.
4. **Read existing docs** - Review README.md, CONTRIBUTING.md, and any existing architecture docs

### Phase 2: Module Discovery
1. **Map top-level modules** - Identify primary directories/packages and their purposes
2. **Trace dependencies** - Understand import/require patterns between modules
3. **Find core abstractions** - Identify key types, interfaces, traits that define the architecture
4. **Locate data models** - Find where domain entities are defined

### Phase 3: Pattern Recognition
1. **Identify architectural style** - Layered, hexagonal, microkernel, event-driven, etc.
2. **Find repeated patterns** - How are common tasks handled consistently?
3. **Detect boundaries** - Where are clear separation points?
4. **Recognize invariants** - What dependencies DON'T exist? What patterns are avoided?

### Phase 4: Documentation Generation
1. **Write problem overview** - Synthesize the project's purpose
2. **Build the codemap** - Organize modules hierarchically with descriptions
3. **Document invariants** - Explicitly state architectural rules
4. **Mark boundaries** - Call out system and module boundaries
5. **Cover cross-cutting** - Describe common patterns and utilities

## Writing Style Guidelines

**Tone:**
- Direct and concise
- Assume the reader is intelligent but unfamiliar with this specific codebase
- Write in present tense
- Avoid speculation ("probably", "might be")

**Structure:**
- Use headers to organize (##, ###)
- Use bullet points for lists of items
- Use bold for emphasis on key concepts
- Keep paragraphs short (2-4 sentences)

**What to avoid:**
- Don't explain HOW things work (that's inline documentation)
- Don't include API references (that's generated docs)
- Don't describe algorithms or implementation details
- Don't include step-by-step tutorials
- Don't link directly to files (use names for symbol search instead)
- Don't document things that change frequently

**Example phrasing:**
- ✅ "The `Parser` module handles converting source text into an AST"
- ❌ "The Parser uses a recursive descent algorithm with lookahead tokens"
- ✅ "Network code never directly imports from the UI layer"
- ❌ "The network layer uses async/await for handling requests"

## Output Format

Generate a complete ARCHITECTURE.md file with:

```markdown
# Architecture

[Bird's Eye Overview - 2-4 paragraphs]

## Code Map

[Hierarchical description of modules with their responsibilities]

### Module Name
[What it does, key types, relationships]

### Another Module
[What it does, key types, relationships]

## Architectural Invariants

- [Invariant 1]
- [Invariant 2]
- ...

## Boundaries

[Description of key boundaries between layers/systems]

## Cross-Cutting Concerns

### Error Handling
[How errors are handled across the codebase]

### Testing
[How tests are organized]

### Configuration
[How configuration is managed]

[Other relevant cross-cutting concerns]
```

## Quality Checklist

Before presenting the final document, verify:

- [ ] Overview explains the problem clearly without technical jargon
- [ ] Codemap is hierarchical and maps to actual directory structure
- [ ] Important types and modules are named (but not linked)
- [ ] Architectural invariants include at least one "absence" rule
- [ ] Boundaries are explicitly called out
- [ ] Cross-cutting concerns cover common questions
- [ ] Total length is 500-1500 words (readable in 5-10 minutes)
- [ ] No implementation details or how-things-work explanations
- [ ] Uses symbol search guidance instead of direct links
- [ ] Reflects the actual current structure (not idealized future)

## Example Reference

For a reference implementation, see the rust-analyzer ARCHITECTURE.md:
https://github.com/rust-lang/rust-analyzer/blob/master/docs/dev/architecture.md

This demonstrates:
- Clear problem statement
- Well-organized codemap matching directory structure
- Explicit invariants ("nothing in the `ide` crate knows about LSP")
- Cross-cutting concerns (testing strategy, performance considerations)
- Concise, scannable format

## Interaction Flow

1. **Understand the repository:**
   - Ask for repository path or URL if not already provided
   - Confirm the primary language/framework
   - Check if any areas should be emphasized or excluded

2. **Analyze the codebase:**
   - Examine directory structure
   - Identify key modules and their relationships
   - Find architectural patterns and invariants
   - Note boundaries and cross-cutting concerns

3. **Generate the document:**
   - Create the ARCHITECTURE.md following the structure above
   - Save it to the repository root (or ask where to save it)
   - Present it to the user for review

4. **Iterate if needed:**
   - Address feedback on accuracy or emphasis
   - Adjust level of detail based on user preferences
   - Refine wording for clarity

## Notes for Claude

- This is a **documentation task**, not a coding task - focus on clarity and structure
- The value is in providing a **mental map**, not comprehensive coverage
- **Less is more** - err on the side of brevity
- Think like a **cartographer** creating a map, not an explorer writing a travelogue
- The reader should finish with a clear sense of "where things are" and "how to navigate"
