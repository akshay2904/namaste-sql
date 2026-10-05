# 3073. Maximum Increasing Triplet Value

**Difficulty:** Medium
**Tags:** Array, Ordered Set
**Acceptance Rate:** 35.9%
**Access:** Premium
**URL:** https://leetcode.com/problems/maximum-increasing-triplet-value/

---

_Problem description unavailable (Premium required)._

**Hints:**
1. For each element, define `right[i]` as the value of the greatest element with an index greater than `i`.
2. Start iterating from the beginning, define a set containing the elements seen so far.
3. When you are at index `i`, use binary search on the set to find the greatest element on the left of index `i` that is smaller than `nums[i]` and name it `greatest_left`.
4. Also check that `nums[i] < right[i]`.
5. If the above conditions hold, then `ans = max(ans, greatest_left - nums[i] + right[i])`.

---

## Solution

```python

```
