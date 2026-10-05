# 2533. Number of Good Binary Strings

**Difficulty:** Medium
**Tags:** Dynamic Programming
**Acceptance Rate:** 52.9%
**Access:** Premium
**URL:** https://leetcode.com/problems/number-of-good-binary-strings/

---

_Problem description unavailable (Premium required)._

**Hints:**
1. If we maintain DP(i, x) where i denotes the length and x denotes the last written integer (0 or 1), then it is not hard to solve in O(maxLength * max(zeroGroup, oneGroup)).
2. Notice that from DP(i, 0) we only have a transition to DP(j, 1) where (j - i) mod oneGroup == 0 and j > i. Similarly with DP(i,1). So we can use prefix sum to optimize our DP and solve it in O(maxLength).

---

## Solution

```python

```
