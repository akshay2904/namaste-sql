# 3247. Number of Subsequences with Odd Sum

**Difficulty:** Medium
**Tags:** Array, Math, Dynamic Programming, Combinatorics
**Acceptance Rate:** 47.2%
**Access:** Premium
**URL:** https://leetcode.com/problems/number-of-subsequences-with-odd-sum/

---

_Problem description unavailable (Premium required)._

**Hints:**
1. Define `dp[i][0]` as the answer for the subarray `[0, i]`.
2. Similarly define `dp[i][1]` as the answer for the subarray `[0, i]` if we wanted to count even-sum subsequences.
3. If `nums[i]` is odd, `dp[i][x] = 2i`.
4. Otherwise, `dp[i][x] = dp[i - 1][x] * 2`.
5. `dp[0][1] = 1` if `nums[0]` is odd, and 0 otherwise.
6. `dp[0][0] = 2` if `nums[0]` is even, and 1 otherwise (since an empty subsequence has an even sum).

---

## Solution

```python

```
