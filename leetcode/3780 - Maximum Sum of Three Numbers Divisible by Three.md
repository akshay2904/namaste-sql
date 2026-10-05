# 3780. Maximum Sum of Three Numbers Divisible by Three

**Difficulty:** Medium
**Tags:** Array, Greedy, Sorting, Heap (Priority Queue)
**Acceptance Rate:** 47.7%
**Access:** Free
**URL:** https://leetcode.com/problems/maximum-sum-of-three-numbers-divisible-by-three/

---

You are given an integer array `nums`.

Your task is to choose **exactly three** integers from `nums` such that their sum is divisible by three.

Return the **maximum** possible sum of such a triplet. If no such triplet exists, return 0.

 

**Example 1:**

**Input:** nums = [4,2,3,1]

**Output:** 9

**Explanation:**

The valid triplets whose sum is divisible by 3 are:

	
`(4, 2, 3)` with a sum of `4 + 2 + 3 = 9`.

	
`(2, 3, 1)` with a sum of `2 + 3 + 1 = 6`.

Thus, the answer is 9.

**Example 2:**

**Input:** nums = [2,1,5]

**Output:** 0

**Explanation:**

No triplet forms a sum divisible by 3, so the answer is 0.

 

**Constraints:**

	
`3 <= nums.length <= 105`

	
`1 <= nums[i] <= 105`

**Hints:**
1. Split numbers into groups by `x % 3`.
2. Only four valid combinations for `sum % 3 == 0`.
3. Possible combinations are `0 + 0 + 0`, `1 + 1 + 1`, `2 + 2 + 2`, `0 + 1 + 2`.
4. Sort groups descending, try each combo using top values.

---

## Solution

```python

```
