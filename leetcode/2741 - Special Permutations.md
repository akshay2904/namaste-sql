# 2741. Special Permutations

**Difficulty:** Medium
**Tags:** Array, Dynamic Programming, Bit Manipulation, Bitmask
**Acceptance Rate:** 29.6%
**Access:** Free
**URL:** https://leetcode.com/problems/special-permutations/

---

You are given a **0-indexed** integer array `nums` containing `n` **distinct** positive integers. A permutation of `nums` is called special if:

	
For all indexes `0 <= i < n - 1`, either `nums[i] % nums[i+1] == 0` or `nums[i+1] % nums[i] == 0`.

Return the total number of special permutations. As the answer could be large, return it **modulo **`109 + 7`.

 

**Example 1:**

**Input:** nums = [2,3,6]
**Output:** 2
**Explanation:** [3,6,2] and [2,6,3] are the two special permutations of nums.

**Example 2:**

**Input:** nums = [1,4,3]
**Output:** 2
**Explanation:** [3,1,4] and [4,1,3] are the two special permutations of nums.

 

**Constraints:**

	
`2 <= nums.length <= 14`

	
`1 <= nums[i] <= 109`

**Hints:**
1. Can we solve this problem using DP with bit masking?
2. You just need two states in DP which are last_ind in the permutation and the mask of numbers already used.

---

## Solution

```python

```
