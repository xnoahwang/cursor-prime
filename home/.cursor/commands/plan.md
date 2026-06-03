# Plan Gate

Treat the request that follows (or the most recent request if none is given) as a non-trivial task and enter the Plan Gate.

**Non-trivial includes any file edit** — code, docs, README, markdown, config, or multi-line comment changes. Only read-only Q&A or a single-line typo in one known location is trivial.

Do NOT call Write, StrReplace, Delete, or any state-changing tool yet. Instead output a single `<plan>` block containing:

- **Goal** — the task restated as one verifiable outcome.
- **Approach** — the minimal steps; no speculative abstractions.
- **Out of scope** — what you will explicitly NOT do (even if related or "nice to have").
- **Done when** — the verifiable stop condition; the task is incomplete until this is met.
- **Scale** — `trivial` | `single-context` | `workflow-scale` (if workflow-scale, include phased steps and note token/credit cost).
- **Pre-flight file list** — every file you will create, modify, delete, or **read in full** (full paths). If you later need a file not listed here, STOP and explain.
- **Pattern grounding** — before finalizing the plan, search the codebase for conventions to mirror (one example each with path): naming, error handling, test location/style. If none exist, say so — do not invent patterns.
- **Verify** — the exact command(s) you will run to prove PASS/FAIL (prefer commands from `@project` when defined).
- **Edge cases** — empty/missing, malformed, and large-scale input behavior for any new function, CLI, or endpoint (one line each).

Then STOP and wait for the user to reply with the literal word `GO`. Do not proceed without it.
