# 1692. Count Ways to Distribute Candies

**Difficulty:** Hard
**Tags:** Dynamic Programming
**Acceptance Rate:** 63.8%
**Access:** Premium
**URL:** https://leetcode.com/problems/count-ways-to-distribute-candies/

---

_Problem description unavailable (Premium required)._

**Hints:**
1. Try to define a recursive approach. For the ith candies, there will be one of the two following cases:
2. If the i - 1 previous candies are already distributed into k bags for the ith candy, you can have k * dp[n - 1][k] ways to distribute the ith candy. We need then to solve the state of (n - 1, k).
3. If the i - 1 previous candies are already distributed into k - 1 bags for the ith candy, you can have dp[n - 1][k - 1] ways to distribute the ith candy. We need then to solve the state of (n - 1, k - 1).
4. This approach will be too slow and will traverse some states more than once. We should use memoization to make the algorithm efficient.

---

## Solution

```python

```
