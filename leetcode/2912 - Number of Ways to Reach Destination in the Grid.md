# 2912. Number of Ways to Reach Destination in the Grid

**Difficulty:** Hard
**Tags:** Math, Dynamic Programming, Combinatorics
**Acceptance Rate:** 57.7%
**Access:** Premium
**URL:** https://leetcode.com/problems/number-of-ways-to-reach-destination-in-the-grid/

---

_Problem description unavailable (Premium required)._

**Hints:**
1. We are asked to count the number of sequences of length `k + 1` that start from `(xs, ys)` and end with `(xd, yd)`. i.e., `(xs, ys), (x1, y1), ..., (xk - 1, yk - 1), (xd, yd)`.
2. The key point is to see `x` and `y` separately.
3. Suppose we do `i` vertical moves and `k - i` horizontal moves.
4. In each vertical move, we change only `y`. Now let's count the number of sequences of length `i + 1` that start with `source[2]` and end with `dest[2]`. Let's call this number `vertical_count`.
5. Do the same for horizontal moves and let it be `horizontal_count`.
6. For each `i`, the number of ways would be `vertical_count * horizontal_count * C(n, i)` since the order of vertical and horizontal moves could be arbitrary.

---

## Solution

```python

```
