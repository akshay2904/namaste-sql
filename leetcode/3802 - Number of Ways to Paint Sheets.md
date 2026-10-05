# 3802. Number of Ways to Paint Sheets

**Difficulty:** Hard
**Tags:** N/A
**Acceptance Rate:** 66.9%
**Access:** Premium
**URL:** https://leetcode.com/problems/number-of-ways-to-paint-sheets/

---

_Problem description unavailable (Premium required)._

**Hints:**
1. Sort `limit` and use binary search (`lower_bound`) to compute `num_ge(t)`, the number of colors with `limit >= t`.
2. For a split `x`, count ordered pairs `(i, j)` with `i != j` as `num_ge(x) * num_ge(n - x) - num_ge(max(x, n - x))`.
3. Note that `num_ge(x)` and `num_ge(n - x)` change only when `x` crosses `1`, `n - 1`, `L + 1`, or `n - L` for some `L` in `limit`.
4. Collect all such critical `x` values, sort and deduplicate them, and treat the answer as constant between consecutive values.

---

## Solution

```python

```
