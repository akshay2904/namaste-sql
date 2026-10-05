# 3916. Number of ZigZag Arrays III

**Difficulty:** Hard
**Tags:** N/A
**Acceptance Rate:** 67.4%
**Access:** Premium
**URL:** https://leetcode.com/problems/number-of-zigzag-arrays-iii/

---

_Problem description unavailable (Premium required)._

**Hints:**
1. Let `m = r - l + 1`. The actual values do not matter, only how many distinct choices you have.
2. The answer as a function of `m` is a polynomial of degree at most `n`. So instead of working up to large `m`, compute values for small `m`.
3. Use Dynamic Programming: `dp[i][j][dir]` = number of arrays of length `i` ending at value `j` with last move direction `dir` (`up`/`down`). Use prefix sums to transition in `O(n^2)` total for all `m <= n+1`.
4. After computing answers for `m = 1, 2, ..., n+1`, use Lagrange interpolation to evaluate the polynomial at the actual `m` in `O(n)` or `O(n^2)` time.

---

## Solution

```python

```
