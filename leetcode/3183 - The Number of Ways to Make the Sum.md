# 3183. The Number of Ways to Make the Sum

**Difficulty:** Medium
**Tags:** Array, Dynamic Programming
**Acceptance Rate:** 51.1%
**Access:** Premium
**URL:** https://leetcode.com/problems/the-number-of-ways-to-make-the-sum/

---

_Problem description unavailable (Premium required)._

**Hints:**
1. Consider using dynamic programming.
2. Define `dp[i][x]` as the number of ways to make the sum `x` using only the first `i` coins; and define `coin[i]` as the value of coin `i`.
3. We can calculate `dp[i][x]` as the sum of `dp[i - 1][x]` and `dp[i][x - coin[i]]`.
4. Remember that 4 can at most be multiplied twice, so we calculate the `dp` for our infinite coins and then manually handle the existence of 4.

---

## Solution

```python

```
