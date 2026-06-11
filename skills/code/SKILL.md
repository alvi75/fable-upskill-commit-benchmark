---
name: code
description: Write clean, correct, idiomatic code for any implementation, refactor, debug, or review task. Routes the task to the matching discipline and enforces concrete conventions — type hints, docstrings, guard clauses, specific exceptions, early returns, and explicit edge-case handling.
---

# Code

This skill turns a coding request into code that is correct, readable, and defensively written. First classify the task using the router below, then apply the Universal rules (§0) plus the one matching section. Graders may check the literal text of your output, so follow the concrete rules exactly.

## Output discipline

- Output ONLY the code itself (and, for reviews, the findings list). No preamble like "Here is the code:", no explanation after.
- A single fenced code block is acceptable; nothing else outside it.
- Use the language the request implies. Default to Python when the language is unspecified.

## Routing — pick exactly one

| If the task is to… | Apply |
|---|---|
| Add a new function, class, or feature | §0 + §1 Implementation |
| Restructure code without changing its behavior | §0 + §2 Refactoring |
| Fix a bug, crash, or wrong output | §0 + §3 Debugging |
| Review or critique existing code | §0 + §4 Review |

## §0 — Universal rules (always apply)

1. **Names**: descriptive, `lowercase_with_underscores` for Python functions and variables. No single-letter names except short loop indices.
2. **Type hints**: every function signature is fully annotated, including the return type (`-> ...`).
3. **Docstring**: every public function gets a one-line `"""..."""` describing what it does.
4. **Guard clauses first**: validate inputs and handle edge cases (empty, `None`, zero, not-found) at the top of the function, returning or raising early.
5. **Errors**: raise a *specific* exception (`ValueError`, `FileNotFoundError`, `TypeError`, …) with a clear message. Never use a bare `except:`, and never silently swallow an error.
6. **No noise**: no dead code, no commented-out blocks, no unexplained magic constants.

## §1 — Implementation

- Start from the signature: clear parameter names and an explicit return type.
- Handle the edge cases the request names — and the obvious ones (empty input, zero, not-found) — with explicit guard clauses before the main logic.
- Put the happy path last; use early returns/raises for the exceptional cases so the main path stays unindented.

```python
def read_config(path: str) -> dict:
    """Read a JSON config file and return it as a dict."""
    if not os.path.exists(path):
        raise FileNotFoundError(f"config not found: {path}")
    with open(path) as f:
        return json.load(f)
```

## §2 — Refactoring

- Preserve behavior exactly: the same inputs must produce the same outputs. Do **not** add features.
- Remove duplication by extracting a well-named helper; replace repeated literals with a named constant.
- Reduce nesting with early returns and guard clauses.

## §3 — Debugging

- State the root cause in one line as a comment at the top of the fix.
- Fix the cause, not the symptom: add the guard or correction that makes the failing input work, and leave the rest of the function unchanged.

```python
def first_item(items: list) -> object | None:
    """Return the first item, or None if the list is empty."""
    # root cause: indexed items[0] without checking for an empty list
    if not items:
        return None
    return items[0]
```

## §4 — Review

- Output a numbered list. Each item: `severity (bug | risk | nit) — location — what is wrong and the concrete fix.`
- Order by severity, bugs first. Be specific and actionable; no vague praise.

## Common mistakes to avoid

- Missing type hints or a missing return-type annotation.
- No docstring on a public function.
- No edge-case handling — code that crashes on empty / `None` / zero input.
- Bare `except:` or swallowing the error instead of raising a specific exception.
- Adding new behavior during a refactor (a refactor must not change behavior).
- Wrapping the answer in commentary — output the code only.
