# 2464. Minimum Subarrays in a Valid Split

**Difficulty:** Medium
**Tags:** Array, Math, Dynamic Programming, Number Theory
**Acceptance Rate:** 64.7%
**Access:** Premium
**URL:** https://leetcode.com/problems/minimum-subarrays-in-a-valid-split/

---

_Problem description unavailable (Premium required)._

**Hints:**
1. Find the minimum number of subarrays needed to validly split each prefix of the input array a.
2. Denote dp[i] as the minimum number of subarrays needed to validly split [a[0], a[1], … , a[i - 1]], where dp[0] = 0.
3. Think about the dynamic programming transitions.
4. If we split the first i elements of the array, the last subarray in this splitting will end with a[i - 1] and start with some a[j], where gcd(a[j], a[i - 1]) ≠ 1. Then, we need to validly split the first j elements of the array, or [a[0]…a[j - 1]].
5. Iterate over all possible j < i such that gcd(a[j], a[i - 1]) ≠ 1 and let dp[i] = min(dp[i], dp[j] + 1).

---

## Solution

```python

```
