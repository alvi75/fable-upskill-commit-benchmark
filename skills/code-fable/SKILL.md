---
name: clean-idiomatic-code
description: Write clean, correct, idiomatic code with clear names, type hints, guard clauses, and specific exceptions.
---

# Clean, Idiomatic Code

## Overview

This guide defines core habits for implementation, refactoring, debugging, and review tasks. Apply these standards to all code you write or modify.

## Key Principles

1. **Clear names** – Use descriptive, intention-revealing names. Avoid abbreviations and single letters (except loop indices).
2. **Type hints** – Annotate all function parameters and return values.
3. **Docstrings** – Document every public function, class, and module with purpose, args, returns, and raises.
4. **Guard clauses** – Handle edge cases early; return or raise immediately instead of nesting logic.
5. **Specific exceptions** – Raise and catch precise exception types, never bare `except:` or generic `Exception`.

## Example: Applying All Principles

```python
def calculate_discount(price: float, discount_percent: float) -> float:
    """Apply a percentage discount to a price.

    Args:
        price: Original price, must be non-negative.
        discount_percent: Discount between 0 and 100.

    Returns:
        The discounted price.

    Raises:
        ValueError: If price is negative or discount is out of range.
    """
    if price < 0:
        raise ValueError(f"Price must be non-negative, got {price}")
    if not 0 <= discount_percent <= 100:
        raise ValueError(f"Discount must be 0-100, got {discount_percent}")

    return price * (1 - discount_percent / 100)
```

## Refactoring: Replace Nesting with Guard Clauses

```python
# Before: deeply nested
def process(user):
    if user is not None:
        if user.is_active:
            return user.profile

# After: flat and clear
def process(user: User | None) -> Profile:
    if user is None:
        raise ValueError("User is required")
    if not user.is_active:
        raise InactiveUserError(f"User {user.id} is inactive")
    return user.profile
```

## Review Checklist

When reviewing or debugging code, check for:

- Vague names (`data`, `temp`, `do_stuff`) → rename to express intent.
- Missing type hints or docstrings → add them.
- Deep nesting → flatten with guard clauses.
- Broad exception handling → narrow to specific types.
- Silent failures → log or raise with context.

## Best Practices

- Keep functions small and single-purpose.
- Include actual values in error messages for easier debugging.
- Prefer standard library idioms over custom solutions.
- Make invalid states unrepresentable through validation at boundaries.