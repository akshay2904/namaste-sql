# 2941. Maximum GCD-Sum of a Subarray

**Difficulty:** Hard
**Tags:** Array, Math, Binary Search, Number Theory
**Acceptance Rate:** 38.8%
**Access:** Premium
**URL:** https://leetcode.com/problems/maximum-gcd-sum-of-a-subarray/

---

_Problem description unavailable (Premium required)._

**Hints:**
1. Try to answer the query of asking GCD of a subarray in `O(1)` using sparse tables and preprocessing.
2. For every index `L`, let’s find the subarray starting at the index `L` and maximizing gcd-sum.
3. Use the fact that if `L` is fixed, then by adding one more element to the end of a subarray, two things can happen: the gcd remains the same as the last gcd or becomes at least half of the last one.
4. Now we can use binary search to find the last index `R` such that gcd of the elements of `nums[L..R]` would be equal to `nums[L]`.
5. Now add `nums[R + 1]` to the current subarray and continue the process to find the last index that has the same gcd as the current gcd of elements.

---

## Solution

```python

```
