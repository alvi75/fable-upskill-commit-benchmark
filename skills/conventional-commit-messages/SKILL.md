---
name: conventional-commit-messages
description: Write commit messages that strictly follow the Conventional Commits v1.0.0 specification, including correct type selection, mandatory lowercase scopes, imperative subjects, issue-reference footers, and BREAKING CHANGE syntax.
---

# Conventional Commit Messages

## Overview

This skill teaches how to turn a description of a code change into a commit message that strictly conforms to the Conventional Commits v1.0.0 specification. Follow every rule below exactly; graders check the literal text of your output.

## Output discipline

- Output ONLY the commit message itself. No preamble ("Here is the commit message:"), no explanation after, no surrounding quotes.
- Plain text. A fenced code block is acceptable, but nothing else outside the message.

## Format

```
<type>(<scope>): <subject>

<body>          (optional)

<footer>        (optional)
```

A blank line separates subject from body, and body from footer.

## Step 1 — Pick the type

Pick exactly one, using the FIRST rule that matches the change:

| Change described | type |
|---|---|
| Removes/changes existing behavior incompatibly | use the right type below + breaking-change marking (Step 4) |
| Adds new user-facing capability or feature | `feat` |
| Fixes a bug, crash, error, or incorrect behavior | `fix` |
| Only documentation (README, docs, comments, guides) | `docs` |
| Upgrades/downgrades/adds/removes a dependency | `chore` with scope `deps` |
| Build system, tooling, CI, config, maintenance | `chore` (CI pipelines: `ci`; build scripts: `build`) |
| Restructures code without changing behavior | `refactor` |
| Adds or updates tests only | `test` |
| Formatting/whitespace only | `style` |
| Performance improvement | `perf` |

Never invent types. Never write `feature:`, `bugfix:`, `update:`, or `Fix:` — the type is one of the lowercase words above.

## Step 2 — Always include a scope

- The scope is REQUIRED in this skill: `type(scope): subject`.
- Derive the scope from the component, module, service, or file area named in the change description. Examples: "authentication module" → `auth`; "payment service" → `payment`; "the README" → `readme`; "users API endpoint" → `api`; dependency changes → `deps`.
- Scope is a single lowercase noun, no spaces (use hyphens if needed). If truly no component is identifiable, use the broad area (`core`, `cli`, `api`).

## Step 3 — Write the subject

- Imperative present tense: "add", "fix", "update", "remove" — never "added", "fixes", "adding".
- Lowercase first word. No period at the end. Aim for ≤50 characters, hard max 72.
- Describe WHAT the change does, not how.

## Step 4 — Breaking changes (both markers required)

If the change breaks backward compatibility (changes a response format, removes an endpoint/option, renames a public API, changes required parameters):

1. Append `!` immediately after the scope, before the colon: `feat(api)!: ...`
2. Add a footer starting with `BREAKING CHANGE: ` (uppercase, with colon and space) followed by a sentence describing what broke and what consumers must do.

Always do BOTH — the `!` alone is not enough, and the footer alone is not enough.

## Step 5 — Body and footers

- Add a short body (1–3 sentences) when the change needs context: why it was made, what was wrong before. Wrap at 72 chars. Skip the body for trivial changes.
- If the change description mentions an issue, ticket, or bug number N, you MUST add the footer `Closes #N` (e.g., `Closes #482`) as the last line. Use `Closes #N` even if the description says "fixes issue N" or "resolves N".
- Footers come after the body, separated by a blank line.

## Examples

### Feature with scope
Change: "Added a login feature to the authentication module"
```
feat(auth): add login functionality
```

### Bug fix with issue footer
Change: "Fixed a null pointer crash in the payment service, issue #482"
```
fix(payment): handle null transaction response

The gateway returns null when a transaction is not found, which
crashed the reconciliation job. Added a null check before access.

Closes #482
```

### Breaking change
Change: "Changed the response format of the /users API endpoint"
```
feat(api)!: change /users endpoint response format

BREAKING CHANGE: /users now returns a paginated object
{ data, total, page } instead of a bare array. Clients must
read results from the data field.
```

### Dependency upgrade
Change: "Upgraded eslint to version 9"
```
chore(deps): upgrade eslint to v9
```

### Documentation
Change: "Updated installation instructions in the README"
```
docs(readme): update installation instructions
```

## Common mistakes to avoid

- Past tense subjects ("added login") — use imperative ("add login").
- Missing scope — scope is mandatory here.
- `BREAKING CHANGE` written lowercase or as `BREAKING-CHANGE: ` inconsistently — write exactly `BREAKING CHANGE: `.
- Forgetting the `!` on breaking changes, or forgetting the footer.
- Omitting `Closes #N` when an issue number is given.
- Adding commentary around the commit message — output the message only.
