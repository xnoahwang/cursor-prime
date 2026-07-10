# coderpad-prime — Entry (SKILL)

**coderpad-prime** = cursor-prime adapted for **CoderPad** (online web IDE), plus assessment maintainability (in-line docs + project-root `NOTES.md`).

This folder is **helper scaffolding**, not part of the formal project deliverable.

| File | Role |
|------|------|
| `SKILL.md` (this file) | Environment, language, load order, time box, checklist |
| `DISCIPLINE.md` | Plan Gate, Loop, Karpathy simplicity/surgical, naming, verify, Delta |
| `MAINTAINABILITY.md` | Comments, API docs, layout, root `NOTES.md` |
| `NOTES.template.md` | Copy to **project root** as `NOTES.md` and fill in English |

**You must read all files in `CoderPad-Prime/` before confirming ready** (Phase 1).

---

## Environment (hard)

You are inside **CoderPad** — a browser-based IDE for **this project**.

**Do:** use the pad file tree, Run/Preview, built-in terminal (if any), AI Assist; keep deliverables in this workspace.

**Do not:** assume local Cursor/VS Code; suggest User Rules, `/plan`, `/prime-init`, `/loop` slash commands, or laptop-only paths; invent tools the pad does not have.

If something needs a local-only step, say so in Chinese and propose a pad-native alternative.

---

## Language (hard)

| Surface | Language |
|---------|----------|
| Chat with candidate (plans, GO wait, Delta, questions) | **Chinese (中文)** |
| Source code, identifiers, tests | **English** |
| In-line / API comments, file headers | **English** |
| Project root `NOTES.md` | **English** |
| User-visible UI/CLI strings | **English** (unless the prompt requires otherwise) |

---

## Mission (assessment)

~60-minute continuous technical assessment on this project.

Reviewers score **problem-solving** and **maintainability**. Passing every test does **not** guarantee approval. Clear explanation and potential matter.

Deliver:

1. Working, readable code under `DISCIPLINE.md` + `MAINTAINABILITY.md`.
2. Multi-aspect **`NOTES.md` at project root** (from template).
3. Deliberate AI use (candidate directs; you wait for `GO`; they review edits).

---

## Load in two steps

**Phase 1 — rules only.** After `CoderPad-Prime/` is present (or files pasted), the candidate’s first message loads rules. Confirm you have read **all** of `SKILL.md`, `DISCIPLINE.md`, `MAINTAINABILITY.md`, and `NOTES.template.md`. **Do not** read the rest of the project or requirements yet.

Example (Chinese):

> 你现在是在 CoderPad（网页在线 IDE）里协助我，不是本地的 Cursor 或 VS Code。请先阅读 CoderPad-Prime/ 目录下的全部文件（coderpad-prime），并在本次项目中遵守它们。请用中文和我对话；代码、注释和项目根目录 NOTES.md 必须用英文。准备好后请确认——现在先不要阅读项目其余文件或题目要求。只使用本 pad 里可用的工具和文件。

**Phase 2 — project.** When asked, read this project and pad instructions, then enter **Plan Gate** (`DISCIPLINE.md`): output `<plan>`, **STOP**, wait for `GO` / `可以` / `继续`. After approval: implement, verify, loop if needed, keep root `NOTES.md` updated, finish with Delta.

Do not require “per SKILL” on every small step in the same chat after Phase 1.

---

## Time box (~60 minutes)

| Phase | Focus |
|-------|--------|
| ~5 min | Phase 1 + skim after GO into Phase 2 |
| ~35 min | Plan → GO → minimal path that can pass tests |
| ~15 min | Comments + root `NOTES.md` |
| ~5 min | Re-verify + checklist |

If behind: tests + root NOTES skeleton filled enough + public API comments beat stretch goals.

---

## Submission checklist

- [ ] Plan Gate honored (no silent big edits before `GO`)
- [ ] Verify run with transcript when tests exist; loop used if needed under cap
- [ ] Code: simplicity, surgical, clear naming, Logic/IO/Action where appropriate
- [ ] Maintainability: API docs, headers, comment quality bar
- [ ] Root `NOTES.md` multi-aspect (not only hard/easy); not only under `CoderPad-Prime/`
- [ ] Language rules respected
- [ ] Delta Report produced
