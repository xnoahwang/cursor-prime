# Verify Against Plan

Audit the work just completed (or in progress) against the active plan and pre-flight file list. Be adversarial — surface drift, not a clean bill of health.

Do NOT make new edits unless the user asks you to fix findings.

## Prerequisites

If there is no plan or pre-flight file list in this conversation, say so and stop:
> No plan to verify against. Run `/plan` or complete Plan Gate first.

## Checklist

1. **Pre-flight compliance** — list every file created, modified, deleted, or read in full. Flag any file outside the pre-flight list.
2. **Out of scope** — list any work that matches "Out of scope" from the plan.
3. **Done when** — PASS or FAIL against the stated stop condition; if FAIL, what remains.
4. **Hard verifier** — were verify commands actually **run** with transcript in Verify Receipt? FAIL if only claimed or self-graded.
5. **Surgical** — adjacent code, comments, or formatting touched without request?
6. **Protected paths** — if `@project` defines protected paths, were any edited without being on the pre-flight list?

## Output

```
Verify Report
- Pre-flight: PASS | FAIL — <files outside list, if any>
- Out of scope: PASS | FAIL — <items, if any>
- Done when: PASS | FAIL — <what remains, if FAIL>
- Hard verifier: PASS | FAIL — <missing transcript or self-grade only, if FAIL>
- Surgical: PASS | FAIL — <issues, if any>
- Protected paths: PASS | N/A | FAIL — <issues, if any>
```

Then one sentence: proceed to Delta, fix findings first, send `/loop` to iterate (if hard gate exists and under max iterations), or re-plan.
