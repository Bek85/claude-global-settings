---
name: explaining-code
description: Explains code with visual diagrams and analogies. Use when explaining how code works, teaching about a codebase, or when the user asks "how does this work?"
version: 1.0.0
---

# Explaining Code

When explaining code, follow this 4-step structure:

## 1. Start with an Analogy
Compare the code to something from everyday life before diving into details.

**Example**: "This middleware is like a security guard at a building entrance - it checks credentials before letting anyone through to the actual service."

## 2. Draw a Diagram
Use ASCII art to show flow, structure, or relationships. See `references/diagram-patterns.md` for templates.

## 3. Walk Through the Code
Explain step-by-step what happens, following the execution path:
- Use line numbers when referencing specific code
- Trace data transformations through the function
- Explain WHY, not just WHAT

## 4. Highlight a Gotcha
End with a common mistake or misconception developers face with this pattern.

**Example**: "A common mistake is forgetting that async/await doesn't make code run in parallel - it just makes async code look synchronous."

## References
- `references/analogies.md` - Common code pattern analogies
- `references/diagram-patterns.md` - ASCII diagram templates
