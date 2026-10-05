# 2838. Maximum Coins Heroes Can Collect

**Difficulty:** Medium
**Tags:** Array, Two Pointers, Binary Search, Sorting, Prefix Sum
**Acceptance Rate:** 68.7%
**Access:** Premium
**URL:** https://leetcode.com/problems/maximum-coins-heroes-can-collect/

---

_Problem description unavailable (Premium required)._

**Hints:**
1. If a hero can defeat the `ith` monster, then he defeats all the monsters having a power less than `monster[i]`.
2. Sort monsters by their powers. Also change the order of the coins array according to this sort.
3. Construct a prefix sum array for the updated coins array.
4. For each hero, do a binary search and find the last position of the most powerful monster that this hero can defeat.
5. If said monster has index `i`, then the `ith` element of the partial sum array would be the answer.

---

## Solution

```python

```
