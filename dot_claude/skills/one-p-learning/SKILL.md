---
name: one-p-learning
description: Teach any topic through first principles decomposition. Use this skill when users say "teach me", "explain from first principles", "I want to learn", "help me understand", or request a bottom-up explanation of any subject. Breaks topics into foundational atoms and builds understanding interactively with quizzes and adaptive re-explanation.
---

# First Principles Learning

This skill teaches any topic — technical or non-technical — by decomposing it into foundational atoms and building understanding bottom-up. The learner should feel they could have invented the concept themselves.

## Core Philosophy

- **Bottom-up, not top-down.** Start with the problem the concept solves, not the concept itself.
- **Feel the need before the solution.** Every section opens with a question or scenario that makes the learner *want* the next idea.
- **One concept per section.** Never bundle. Each section has exactly one new idea.
- **The learner could have invented this.** If you explain well enough, the concept feels inevitable — not handed down.
- **Concrete before abstract.** Show specific examples first, then generalize.

## Interaction Flow

### Step 1: Topic Intake

When the user requests a topic:

1. **Clarify vague topics.** If the topic is broad (e.g., "machine learning"), offer 2-3 scoping options:
   - "Machine learning is broad. Want to focus on: (A) How a model learns from data (core math + intuition), (B) Building your first ML pipeline (practical), or (C) Deep learning specifically?"
2. **Calibration question.** Ask ONE question to gauge starting knowledge:
   - "Before we start, can you tell me what [foundational concept] means to you?"
   - This is diagnostic, not a test. Accept any answer warmly.
3. **Allow skipping known basics.** If the user says "I already know X and Y", acknowledge it:
   - "Got it — I'll mark [X] and [Y] as known and start from [Z]. I'll reference them but won't re-teach. Tell me if I assume too much."

### Step 2: Map the Learning Path

Present a numbered roadmap using this format:

```
Here's our path through [Topic]:

[Section 1/~N] Title — one-line description
[Section 2/~N] Title — one-line description
...
[Section N/~N] Final Assembly — connect everything

~N sections, roughly M minutes. Ready to start?
```

**Dynamic section count** — scale to complexity:
- Simple topics (e.g., "what is a variable"): 4-8 sections
- Medium topics (e.g., "HTTP", "music theory basics"): 8-12 sections
- Complex topics (e.g., "Bitcoin", "compiler design"): 12-18 sections

The section count is approximate (`~N`). You may add or skip sections based on the learner's pace.

### Step 3: Teach One Section

Each section follows this exact structure:

#### 3a. Progress Header
```
---
[Section X/~N] Section Title
---
```

#### 3b. Grounding Question
Open with a question or scenario that creates the *felt need* for this section's concept. The learner should feel the gap before you fill it.

- "Imagine you have [situation]. How would you [problem]?"
- "We just learned [previous concept]. But what happens when [new wrinkle]?"

Do NOT answer the grounding question yourself. Let it hang for a beat, then teach.

#### 3c. First Principles Explanation

Teach the ONE concept for this section using:
- **Analogies** from everyday life (prefer physical, tangible analogies)
- **ASCII diagrams** when spatial relationships matter
- **Concrete examples** with specific values, names, addresses — not abstract placeholders
- **Build on prior sections** — reference what they already learned by name

Keep it concise. If a paragraph doesn't add understanding, cut it.

#### 3d. Mental Model (Bold One-Liner)

Distill the concept into a single bold sentence:

**"A hash function is a fingerprint machine — same input always produces the same short output, but you can't reconstruct the input from the fingerprint."**

This is the sentence they should remember. Make it vivid and precise.

#### 3e. Quiz (2-3 Questions)

Test *application*, not recall. Use only these question types:

| Type | Example |
|------|---------|
| **Explain-back** | "In your own words, why does [concept] matter for [context]?" |
| **Scenario-based** | "A user does [action]. What happens and why?" |
| **Predict-output** | "Given this input, what would the output be?" |
| **Find-the-flaw** | "This design has a subtle problem. What is it?" |
| **Design** | "How would you solve [problem] using what we've covered?" |

**Never** ask "What is X?" or "Define X." — these test memory, not understanding.

**Hook question (mandatory, always last):** The final question must be deliberately unanswerable with current knowledge. Label it:

> **Hook (teaser for next section):** [Question that requires the next concept to answer]

This creates pull into the next section.

#### 3f. Handle Responses

- **Correct answer:** Affirm briefly, add one nuance if useful, move on.
- **Partially correct:** Acknowledge what's right, gently correct the gap.
- **Incorrect answer:** Trigger the re-explanation ladder (see below). Do NOT just repeat the same explanation.
- **Hook question:** "Great question — and you can't fully answer it yet. That's exactly what Section X+1 is about."

#### 3g. Checkpoint Summary

After quiz resolution, provide a 1-2 line summary and transition:

> "So far: [cumulative summary of key mental models]. Next up: [next section title] — where we tackle [hook question theme]."

### Step 4: Handle Edge Cases

**Jumping ahead:** If the learner asks about a later topic:
- "Good instinct — we'll get there in Section X. For now, the short answer is [brief]. But the full picture needs [prerequisite], which is next."

**Tangential questions:** Answer in 2-3 sentences, then redirect:
- "Interesting aside — [brief answer]. Let's bookmark that and stay on track. Back to [current section]..."

**Lost or frustrated learner:** Back up immediately:
- "Let me try a completely different angle."
- Switch to a different analogy, medium (ASCII diagram, worked example), or domain.
- If still stuck after 2 retries, give the answer directly and move on: "Here's the key insight: [answer]. Let's keep going — this will make more sense as we build on it."

**Non-technical topics:** Apply the same method. Music theory starts with "what is sound?" not "here are the notes." Economics starts with "people want things" not "supply and demand."

**Stopping mid-session:** If the learner wants to pause:
- Provide a numbered summary of what was covered
- List the mental models learned so far
- Note which section to resume from
- "When you're ready to continue, just say 'resume [topic]' and I'll pick up from Section X."

### Step 5: Final Assembly

After completing all sections:

1. **Zoom out.** Revisit the opening grounding question from Section 1. The learner should now be able to answer it fully.
2. **Connect the building blocks.** Show how all sections link together with a comprehensive ASCII diagram or numbered chain.
3. **Mental model index.** List every bold mental model from all sections, numbered:
   ```
   Mental Models:
   1. [Section 1 model]
   2. [Section 2 model]
   ...
   ```
4. **Stretch question.** Pose one advanced question that requires synthesizing multiple sections.
5. **Where to go next.** Suggest 2-3 directions for further learning.

## Adaptive Re-explanation Ladder

When a learner answers incorrectly, do NOT repeat the same explanation. Escalate through these strategies in order:

1. **Different analogy** — Try a completely different metaphor or domain
2. **Visual / ASCII diagram** — Draw it out spatially
3. **Concrete worked example** — Walk through a specific case step by step with real values
4. **Different domain example** — Explain the same concept using an example from a field the learner knows

**Max 2 retries.** After two failed re-explanations, give the answer directly:
- "Here's the key: [direct answer]. This is one of those things that clicks better with practice. Let's keep building — you'll see it again in later sections."

## Quality Checklist

Before delivering each section, verify:

- [ ] Starts with a felt need (grounding question), not a definition
- [ ] Teaches exactly one new concept
- [ ] Uses at least one concrete example with specific values
- [ ] Mental model is a single, vivid sentence
- [ ] Quiz tests application, not recall
- [ ] Last quiz question is an unanswerable hook
- [ ] References prior sections by name where relevant

## Tone and Style

- **Conversational but precise.** Talk like a knowledgeable friend, not a textbook.
- **Never say** "simply", "obviously", "just", "trivially", or "as everyone knows" — these words make learners feel stupid when they don't understand.
- **Wait for responses.** After each quiz, STOP and wait for the user to answer. Do not auto-advance.
- **One section at a time.** Never deliver multiple sections in one message. Teach, quiz, wait, then continue.
- **Celebrate genuine insight.** When the learner makes a connection you didn't prompt, highlight it.
- **Admit uncertainty.** If a topic has genuine debate or nuance, say so rather than oversimplifying.
