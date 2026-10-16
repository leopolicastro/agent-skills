---
name: clean-code-and-refactoring
description: Write code that other people (and future-you) can change cheaply. Use when authoring new code, reviewing a PR, smelling duplication or long methods, picking names, deciding whether to refactor before adding a feature, or when the user says code feels messy or asks to clean it up, simplify it, or make it nicer. Distills Clean Code (Martin), 99 Bottles of OOP (Metz), and Code Complete 2e (McConnell).
---

# Clean Code & Refactoring

The single thesis: **the cost of code is the cost of changing it.** Clarity beats cleverness; small reversible steps beat big rewrites; tests are how you make refactors safe.

## Decision-time heuristics

**The 60-second test**

- Could an engineer new to this code say what a function does — without reading how it does it — in about a minute? If not, start there. A function should read like a sentence; a file like a chapter, high-level flow first.

**Naming**

- A good name encodes intent so the body of the function isn't required to understand it. If you have to read the body to remember what it does, rename.
- Replace magic numbers and booleans with named constants/enums. `paint(true)` is unreadable; `paint(forceRefresh: true)` or `paint.force()` is.
- Pair-of-opposites should be lexically opposite: `add/remove`, `open/close`, never `add/destroy`.
- Class names: nouns for things, not verbs. Method names: verbs. Booleans read as predicates: `is*`, `has*`, `can*`.

**Functions**

- Do one thing, at one level of abstraction. If you can extract a meaningful name for a block, extract it.
- Arguments: 0 ideal, 1–2 fine, 3 suspect, 4+ almost always wrong. Long arg lists are unextracted objects.
- No flag arguments; split into two functions.
- Prefer return values to side effects; prefer pure functions to mutation when the choice is free.

**Comments**

- A comment is a failure to express intent in code. Most "what" comments should become better names. Keep "why" comments — context the code can't carry (regulatory reason, performance trick, surprising bug).
- Never check in commented-out code. `git` remembers.

**Subtract first**

- Prefer deletion over addition. The best refactor often removes code rather than reorganizing it.
- Unnecessary work: a call or computation whose result is never used; the same thing fetched, computed, or built twice when once would do.
- Dead weight: unused imports and dependencies; a parameter that gets the same value at every call site, counting the tests as call sites (remove it and let the function own the value).
- A variable that is only returned or passed straight on: inline it — unless its name explains something the expression doesn't (Clean Code's *explanatory variable*).
- A hand-rolled block that a built-in already does: use the built-in — unless the shorter version takes study to read (99 Bottles' *Incomprehensibly Concise*).
- A method, class, or wrapper that only forwards, adding indirection but no meaning: inline it.

**Refactoring discipline**

- **Make the change easy, then make the easy change.** If a feature is hard to add, refactor toward shape that makes it trivial first; commit the refactor; then add the feature.
- **Shameless Green** (Metz): start with the dumbest code that passes the tests. Don't preempt structure. Refactor when a *second* concrete case reveals the abstraction. Three is even safer.
- **Flocking Rules** (Metz):
  1. Find things that are most alike.
  2. Find the smallest difference between them.
  3. Make the smallest change that removes that difference.
- One refactor per commit; one behavior change per commit; never both at once.

**Smells worth chasing**

- Duplication (the prime smell — almost always points at a missing abstraction).
- Long method, long parameter list, long class.
- Feature envy (method that uses another object's data more than its own).
- Data clumps (same 3+ params travel together — make them a class).
- Primitive obsession (passing a `String email`/`int dollars` everywhere — wrap it).
- Shotgun surgery (one change → many files). Suggests a missing module boundary.
- Divergent change (one file changes for many reasons). Same diagnosis from the other side.

**When NOT to refactor**

- You don't have tests. Write characterization tests first.
- You're under deadline and the code is already shipped-and-works. Note the debt; come back.
- You'd be designing for a third use case that doesn't exist yet. Wait for it.

## Triggers (when to load this skill)

- "Review this code" / "what could be cleaner here?"
- About to add a feature to a messy file.
- About to name something (variable, function, class, file).
- See duplication, a 200-line function, or a method with 5+ args.
- Choosing between "fix it now" vs. "refactor first."
- The user says the code feels messy, or asks to clean it up, simplify it, or make it nicer.
- Running a `/refactor` pass — its checklists live here.

## Anti-heuristics (common mistakes)

- DRYing up code that *coincidentally* looks similar. The shape matters less than the reason for change. Two pieces of code are duplicates only if they will change for the same reason.
- "Clean = lots of small classes." Smallness is a side effect, not a goal. Small classes that hide nothing are noise.
- Over-applying SOLID. SRP, OCP, LSP, ISP, DIP are guides, not laws. Apply when you feel the corresponding pain.
- Treating tests as an afterthought to clean up later. Tests *enable* refactoring; without them you're frozen.
- Polishing everything to the same standard. A 10-line script doesn't need the treatment a core service does; calibrate the effort to what the code is.
- Inventing changes. If the code is already clear, say so and leave it.

See `lessons.md` for the long-form lessons and chapter-by-chapter highlights from the four sources.
