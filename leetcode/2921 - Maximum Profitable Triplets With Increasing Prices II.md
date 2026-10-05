# 2921. Maximum Profitable Triplets With Increasing Prices II

**Difficulty:** Hard
**Tags:** Array, Binary Indexed Tree, Segment Tree
**Acceptance Rate:** 45.9%
**Access:** Premium
**URL:** https://leetcode.com/problems/maximum-profitable-triplets-with-increasing-prices-ii/

---

_Problem description unavailable (Premium required)._

**Hints:**
1. Let's fix the middle chosen item for instance index `j`.
2. Let’s define an array `max_right`, where `max_right[j]` represents the maximum `profit[k]` for every index `k > j` such that `prices[k] > prices[j]`.
3. Consider using a Fenwick tree to fill the `max_right`.
4. Do the same for items with an index `i < j` such that `prices[i] < prices[j]` and find the maximum `profit[i]` among them. Let's call this array `max_left`.
5. Now the profit when an item with the index `j` is the middle one would be `profit[j] + max_right[j] + max_left[j]`.
6. Finally, do the above procedure for all `j`'s and find the maximum profit among them. That would be the final answer.

---

## Solution

```python

```
