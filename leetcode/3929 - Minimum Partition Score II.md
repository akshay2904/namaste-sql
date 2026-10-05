# 3929. Minimum Partition Score II

**Difficulty:** Hard
**Tags:** N/A
**Acceptance Rate:** 50.0%
**Access:** Premium
**URL:** https://leetcode.com/problems/minimum-partition-score-ii/

---

_Problem description unavailable (Premium required)._

**Hints:**
1. Use prefix sums to rewrite the value of any subarray in O(1).
2. Consider DP transitions of the form: `dp[i] = min(dp[j] + cost(j + 1, i))`.
Expand the cost formula algebraically. The transition can be rewritten as a minimum over linear functions.
3. Instead of DP on the number of partitions, add a penalty for creating a subarray and binary search that penalty.

---

## Solution

```python

```
