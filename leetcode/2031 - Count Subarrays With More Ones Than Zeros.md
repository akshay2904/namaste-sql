# 2031. Count Subarrays With More Ones Than Zeros

**Difficulty:** Medium
**Tags:** Array, Hash Table, Binary Search, Divide and Conquer, Binary Indexed Tree, Segment Tree, Merge Sort, Ordered Set
**Acceptance Rate:** 49.3%
**Access:** Premium
**URL:** https://leetcode.com/problems/count-subarrays-with-more-ones-than-zeros/

---

_Problem description unavailable (Premium required)._

**Hints:**
1. Change the zeros in nums to -1 and create a prefix sum array prefixSum using the new nums.
2. If prefixSum[i] for any index i in the range 0 <= i < prefixSum.length is positive, that means that there are more ones than zeros in the prefix ending at index i.
3. If prefixSum[j] > prefixSum[i] for two indexes i and j such that 0 <= i < j < prefixSum.length, that means that there are more ones than zeros in nums in the range [i + 1 : j] (inclusive)

---

## Solution

```python

```
