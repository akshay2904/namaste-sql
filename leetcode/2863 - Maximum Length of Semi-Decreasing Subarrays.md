# 2863. Maximum Length of Semi-Decreasing Subarrays

**Difficulty:** Medium
**Tags:** Array, Stack, Sorting, Monotonic Stack
**Acceptance Rate:** 70.0%
**Access:** Premium
**URL:** https://leetcode.com/problems/maximum-length-of-semi-decreasing-subarrays/

---

_Problem description unavailable (Premium required)._

**Hints:**
1. First, solve the problem assuming `nums` contains distinct values.
2. Make a new array with each element being the pair `(nums[i], i)` for every `i` and call it `num_ind`.
3. Sort `num_ind` in decreasing order.
4. Iterate over `num_ind` and store a variable that represents the minimum index (i.e. min of `num_ind[i].second`) that has been iterated until now. Call it `min_index`
5. Now if you are currently on pair `(nums[x], x)`, then `ans = max(ans, min_index - x)`.
6. Now try to remove the first assumption.

---

## Solution

```python

```
