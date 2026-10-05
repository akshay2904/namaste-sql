# 3018. Maximum Number of Removal Queries That Can Be Processed I

**Difficulty:** Hard
**Tags:** Array, Dynamic Programming
**Acceptance Rate:** 44.8%
**Access:** Premium
**URL:** https://leetcode.com/problems/maximum-number-of-removal-queries-that-can-be-processed-i/

---

_Problem description unavailable (Premium required)._

**Hints:**
1. Think of dynamic programming.
2. The definition of `dp` is a little unusual. Try to think more.
3. Let `dp[l][r]` be the maximum number of queries we can process if we want `a[l], a[l + 1], ..., a[r - 1]` not to be removed after processing `dp[l][r]` queries.
4. So `dp[0][n] = 0` since we can not remove anything.
5. The answer would be `max(dp[i][i])`.

---

## Solution

```python

```
