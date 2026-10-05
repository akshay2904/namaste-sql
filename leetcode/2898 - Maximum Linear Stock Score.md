# 2898. Maximum Linear Stock Score

**Difficulty:** Medium
**Tags:** Array, Hash Table
**Acceptance Rate:** 61.8%
**Access:** Premium
**URL:** https://leetcode.com/problems/maximum-linear-stock-score/

---

_Problem description unavailable (Premium required)._

**Hints:**
1. Let's look at the condition as: `prices[indexes[i]] - indexes[i] == prices[indexes[j]] - indexes[j]`.
2. So now we define a new array named `group` and is constructed as `group[i] = prices[i] - i`.
3. A subarray of `prices` is linear if they belong to the same group.
4. Since all elements are positive, if we choose some index `i`, the optimum way is to choose all elements from `group[i]`.
5. So for each group, we calculate the sum of its prices and the answer would be the maximum sum over all groups.

---

## Solution

```python

```
