# 2638. Count the Number of K-Free Subsets

**Difficulty:** Medium
**Tags:** Array, Math, Dynamic Programming, Sorting, Combinatorics
**Acceptance Rate:** 47.3%
**Access:** Premium
**URL:** https://leetcode.com/problems/count-the-number-of-k-free-subsets/

---

_Problem description unavailable (Premium required)._

**Hints:**
1. Split all numbers into several groups, with each group being an arithmetic sequence with a common difference of k.
2. How many K-free subsets are there for each group? This can be solved by dp: dp[i] = dp[i-1] + dp[i-2], meaning if we choose ith element, we cannot choose (i-1)th; otherwise we can choose (i-1)th element.
3. After solving the problem for every group, the final result is just the product of the sub-problems.

---

## Solution

```python

```
