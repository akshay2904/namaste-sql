# 2907. Maximum Profitable Triplets With Increasing Prices I

**Difficulty:** Medium
**Tags:** Array, Binary Indexed Tree, Segment Tree
**Acceptance Rate:** 55.9%
**Access:** Premium
**URL:** https://leetcode.com/problems/maximum-profitable-triplets-with-increasing-prices-i/

---

_Problem description unavailable (Premium required)._

**Hints:**
1. Let's fix the middle chosen item.
2. For a fixed item with an index `j`, iterate over items with an index `k > j` such that `prices[k] > prices[j]`.
3. Find the maximum `profit[k]` with the above condition. Let's call this maximum value `max_right`.
4. Do the same for items with an index `i < j` such that `prices[i] < prices[j]` and find the maximum `profit[i]` among them. Let's call this maximum value `max_left`.
5. Now the profit when an item with the index `j` is the middle one would be `profit[j] + max_right + max_left`.
6. Finally, do the above procedure for all `j`'s and find the maximum profit among them. That would be the final answer.

---

## Solution

```python

```
