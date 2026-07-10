# coderpad-prime — Maintainability

Handoff-ready standards adapted for **CoderPad**. This is the CoderPad equivalent of cursor-prime `maintainability.mdc`.

Code must run **and** be readable by the next human and the next AI (and by assessment reviewers). Obey together with `DISCIPLINE.md` and `SKILL.md`.

In-line comments, docstrings, and root `NOTES.md` are **English**. Chat with the candidate may be Chinese.

---

## Intensity tiers

| Tier | When | Required |
|------|------|----------|
| **A — Trivial** | Read-only Q&A, or single-line typo in one known place | No extra docs |
| **B — Edit existing** | Change existing files; no new public API | Surgical only; update docs only if behavior/layout/conventions changed and listed in pre-flight |
| **C — New surface** | New file, module, or public function/CLI/endpoint | Full checklist below for everything you add |
| **D — Interview / handoff deliverable** | Timed assessment, ship, or candidate asks for handoff quality | Full checklist + **project root `NOTES.md`** filled (multi-aspect) + refresh README only if the project already relies on it |

**Not scope creep:** For tier C/D, module headers, public API docs, and root `NOTES.md` are part of the deliverable — even if the candidate only named the feature.

Default for CoderPad assessments after Phase 2 starts: treat the overall submission as **tier D**.

---

## Public API documentation (in-line)

Every new **public** function, class, CLI command, or HTTP endpoint must have the language-idiomatic docstring / doc comment covering:

- **Why / responsibility** (not a line-by-line restatement of the body)
- **Parameters and return** when non-obvious
- **Errors / failure modes** the caller must handle
- **Invariants** or important constraints

Private helpers: document only non-obvious rules. Prefer clear names over noise comments.

---

## Module / file headers

Every **new** source file that owns a concern gets a short file-level comment (~2–5 lines):

- What this file is responsible for
- What it deliberately does **not** own (if helpful)

---

## Comments (quality bar)

- Write comments for **why**, tradeoffs, and non-obvious business rules.
- Do **not** write comments that only restate the next line of code.
- Do **not** comment nearly every line.
- Do **not** leave commented-out dead code in the deliverable.

---

## Layout and naming

- Follow the language’s common layout and **this pad project’s** existing tree. Do not dump unrelated modules at repo root without a reason recorded in root `NOTES.md`.
- Names: clear and conventional. No `var1`, `tmp2`, `data2`, `helper`.
- Keep **Logic / IO / Action** separable where the codebase already does (or when greenfield and time allows).

---

## Project root `NOTES.md` (required for tier D)

The `CoderPad-Prime/` folder is **not** part of the formal project. Reviewers care about **`NOTES.md` at the project root**.

1. Copy `CoderPad-Prime/NOTES.template.md` → **project root** `NOTES.md` early in Phase 2 (after plan `GO`).
2. Fill sections in **English** as work progresses; finish before submit.
3. Cover multiple aspects (thought process, what did not work, what was easy, **etc.**) — do not reduce to only hard/easy. See template headings.
4. Keep sections short; delete unused optional sections if cleaner.
5. Never treat notes left only under `CoderPad-Prime/` as the submission.

---

## Repository entry docs (pad-adapted)

- Prefer updating an existing project `README.md` if run/test steps changed.
- Do **not** require Cursor `AGENTS.md` / `project.mdc` unless the pad project already has them.
- Greenfield with no conventions: establish naming / errors / test location, write them into root `NOTES.md` (and README if present), then follow them.

---

## Greenfield / no prior convention

When pattern grounding finds **no** existing convention:

1. Establish naming, error handling, test location, and layout for this project.
2. Write them down in root `NOTES.md` (and README if appropriate).
3. Follow that convention for the rest of the task.

Do **not** invent an undocumented one-off style.

---

## Done when (maintainability)

For tier C/D non-trivial work, incomplete until:

- [ ] New public APIs have proper docstrings / doc comments
- [ ] New modules have file headers
- [ ] Layout matches stated conventions (or conventions written in root `NOTES.md`)
- [ ] Root `NOTES.md` filled for tier D (assessment)
- [ ] A successor could find “where to start” and “how to verify” from code + NOTES without chatting with you

Tier A/B: skip unless your change made docs wrong.

---

## Relationship to Plan Gate / Surgical Changes

- Plan Gate, pre-flight lists, verify receipts, and loops still apply (`DISCIPLINE.md`).
- Surgical Changes still apply to **existing** code you were not asked to reformat.
- Maintainability for **new** surfaces overrides “only what was asked” when the ask implies a shippable / assessable deliverable.
