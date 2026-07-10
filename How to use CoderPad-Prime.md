# How to use CoderPad-Prime

给你（候选人）看的中文说明。**不要**把本文件拖进测评 pad。

**coderpad-prime** = cursor-prime 在 CoderPad（在线 IDE）上的适用版：含 Plan Gate、Loop、卡帕西纪律、命名等（`DISCIPLINE.md`），以及注释 / 根目录 NOTES 等可维护性（`MAINTAINABILITY.md`）。

## 上传包内容（`CoderPad-Prime/`）

| 文件 | 作用 |
|------|------|
| `SKILL.md` | 入口：环境、语言、两阶段、时间盒 |
| `DISCIPLINE.md` | Plan Gate / Loop / Simplicity / Surgical / 命名 / Verify / Delta |
| `MAINTAINABILITY.md` | 注释、API 文档、布局、**项目根** `NOTES.md` |
| `NOTES.template.md` | 复制到**项目根**变成正式 `NOTES.md` |

`CoderPad-Prime/` 是辅助包，**不算**正式交付；正式说明是**项目根目录的 `NOTES.md`**。

开考前看 pad **有没有文件树**，选情况 A 或 B。

---

## 环境与语言

- 环境：网页 CoderPad，不是本机 Cursor。  
- 对话：中文（计划、等 GO、Delta）。  
- 代码 / 注释 / 根目录 NOTES：英文。

---

## 情况 A：有文件树（推荐）

1. 把整个 `CoderPad-Prime/` 放到**项目根目录**下。  
2. **第 1 条**（只加载规则）：

```text
你现在是在 CoderPad（网页在线 IDE）里协助我，不是本地的 Cursor 或 VS Code。
请先阅读 CoderPad-Prime/ 目录下的全部文件（coderpad-prime），并在本次项目中遵守它们。
请用中文和我对话；代码、注释和项目根目录的 NOTES.md 必须用英文。
准备好后请确认——现在先不要阅读项目其余文件或题目要求。
只使用本 pad 里可用的工具和文件。
```

3. 等 AI 确认已读完四份文件、知道在 CoderPad。  
4. **第 2 条**：

```text
现在请阅读本次项目的文件以及 pad 里的题目说明/要求，然后按 DISCIPLINE 走 Plan Gate：用中文给出 <plan>，然后停住等我回复 GO。
始终留在 CoderPad 内操作。请把 CoderPad-Prime/NOTES.template.md 复制到项目根目录为 NOTES.md，并在实现过程中按 MAINTAINABILITY 用英文填写。
CoderPad-Prime/ 只是辅助；正式 NOTES 必须在项目根目录。
```

5. 你看完 plan 后回复 **`GO`**（或 `可以` / `继续`）。  
6. AI 实现 → 跑测 → 必要时你说「继续迭代」走 Loop → 更新根目录 NOTES → Delta。  
7. 交卷前确认根目录 `NOTES.md` 已填好。

---

## 情况 B：没有文件树，只能粘贴

1. 尽量新建并粘贴：`SKILL.md`、`DISCIPLINE.md`、`MAINTAINABILITY.md`、`NOTES.template.md`；或把四份全文分条贴进对话。  
2. 第 1 条改为「请先阅读我提供的 coderpad-prime 文件…」；确认后第 2 条同上（Plan Gate + 根目录 NOTES.md）。  
3. 在项目根创建并填写 `NOTES.md`。

---

## 和 Cursor 版 prime 的对应关系

| Cursor | CoderPad-Prime（本包） |
|--------|------------------------|
| `behavior.mdc` | `DISCIPLINE.md` |
| `maintainability.mdc` | `MAINTAINABILITY.md` |
| `/plan` `/loop` `/handoff` | 对话里的 Plan Gate / 继续迭代 / 根目录 NOTES |
| User Rules | 无（靠上传本文件夹） |

---

## 什么时候再提规则

- 第 1 条必须加载；Ask/Edit 重置后再锚一次。  
- 同一会话小修改不必每句提。  
- 等 plan 时你只要回 `GO`。

---

## 心态

全绿不够。阅卷看：解题、可维护代码、有信息量的注释与根目录 NOTES、以及你是否用 Plan Gate / 审查 AI 在主导。
