# Plan Gate

Treat the request that follows (or the most recent request if none is given) as a non-trivial task and enter the Plan Gate.

Do NOT write code, edit files, or run state-changing tools yet. Instead output a single `<plan>` block containing:

- **Goal** — the task restated as one verifiable outcome.
- **Approach** — the minimal steps; no speculative abstractions.
- **Pre-flight file list** — every file you will create, modify, or delete (full paths). If you later need a file not listed here, STOP and explain.
- **Verify** — the exact command(s) you will run to prove PASS/FAIL.
- **Edge cases** — empty/missing, malformed, and large-scale input behavior for any new function, CLI, or endpoint.

Then STOP and wait for the user to reply with the literal word `GO`. Do not proceed without it.
