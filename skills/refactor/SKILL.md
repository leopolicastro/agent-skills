---
name: refactor
description: Run a behavior-preserving cleanup pass over committed, verified code — first remove what isn't needed, then make what's left read well — with the test suite green before and after. Use when the user says "refactor", "clean this up", "simplify", or "trim the fat" after confirming changes work.
disable-model-invocation: true
allowed-tools: Read, Glob, Grep, Edit, Bash(git diff *)
---

This skill runs after code has been committed and verified. The goal is to make the code better without changing what it does: first take out what isn't needed, then make what's left read well.

The heuristics for both passes live in the `clean-code-and-refactoring` skill. Load it before you start: this skill is the procedure, that one is the checklist.

## Read the recent work

!`git diff HEAD~1 --name-only`
!`git diff HEAD~1`

Read each changed file in full before touching anything. Understand the intent before changing the shape.

## Get to green first

Resolve the test command the way the `tdd` skill does: the project's agent instructions (`AGENTS.md`, `CLAUDE.md`) and docs, then the `tdd` skill's `scripts/detect-tdd-context.sh`, and only then ask the user. Run the full suite and paste its summary line. It must be green before any edit. A red suite means stop and report; never refactor on red.

If a changed file has no test that exercises it, leave that file alone and say so. Offer to write characterization tests first; refactoring untested code is guessing.

## Pass 1: Subtract

Work the **Subtract first** section of `clean-code-and-refactoring`: results never used, work done twice, unused imports and dependencies, parameters that never vary, variables and layers that only forward, hand-rolled built-ins. Delete before you reorganize.

## Pass 2: Read it like prose

Apply the **60-second test**, then the **Naming**, **Functions**, and **Comments** heuristics. Use `smells-catalog.md` to find the move that fits a smell. Heed the anti-heuristics: don't merge code that only coincidentally looks alike, and don't add abstraction for a case that doesn't exist yet.

Write idiomatic code for the language — clean Ruby doesn't look like clean Go. Load the language's idiom skill (`idiomatic-ruby-and-rails`, `idiomatic-go`) when one is installed, and `sandi-metz-design` when class or module structure is in question.

## Ground rules

- **No behavior changes.** If an improvement would change what the code does, note it as a suggestion and move on.
- **Green to green, one file at a time.** Finish both passes on a file, re-run the suite, and paste the summary line before moving to the next. If a change turns a test red, revert it; don't patch forward.
- **If it's already good, say so.** Not every file needs changes. Don't invent them.
- **Proportional effort.** A 10-line script doesn't need the treatment a core service does.
- **Refactor only.** Leave committing to the user. Everything this pass changes should fit in one refactor commit, separate from any behavior change.

## When done

Summarize in plain language:

- One line per file touched: what changed and why.
- Files left alone, and why: already good, or no test covered them.
- Behavior changes and structural ideas you noted but didn't make.
- The test suite's summary line before and after.
