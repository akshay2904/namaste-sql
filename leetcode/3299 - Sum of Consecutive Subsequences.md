# 3299. Sum of Consecutive Subsequences

**Difficulty:** Hard
**Tags:** Array, Hash Table, Dynamic Programming
**Acceptance Rate:** 44.3%
**Access:** Premium
**URL:** https://leetcode.com/problems/sum-of-consecutive-subsequences/

---

_Problem description unavailable (Premium required)._

**Hints:**
1. Try to count the number of times each element occurred in a consecutive subsequence, then you can find the answer easily.
2. Think of dynamic programming as a solution to calculate the number in the previous hint.
3. Let `left_inc[i]` be the number of increasing consecutive subsequences ending at `nums[i]` (except for `nums[i]` itself).
4. Let `right_inc[i]` be the number of increasing consecutive subsequences starting at `nums[i]` (except for `nums[i]` itself).
5. Then `nums[i]` is in `left_inc[i] + right_inc[i] + left_inc[i] * right_inc[i] + 1` increasing subsequences.
6. Do the same for decreasing consecutive subsequences.

---

## Solution

```python

```
