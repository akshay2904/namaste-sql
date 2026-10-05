# 1262. Greatest Sum Divisible by Three

**Difficulty:** Medium
**Tags:** Array, Dynamic Programming, Greedy, Sorting
**Acceptance Rate:** 57.0%
**Access:** Free
**URL:** https://leetcode.com/problems/greatest-sum-divisible-by-three/

---

Given an integer array `nums`, return the **maximum possible sum **of elements of the array such that it is divisible by three.

 

**Example 1:**

**Input:** nums = [3,6,5,1,8]
**Output:** 18
**Explanation:** Pick numbers 3, 6, 1 and 8 their sum is 18 (maximum sum divisible by 3).

**Example 2:**

**Input:** nums = [4]
**Output:** 0
**Explanation:** Since 4 is not divisible by 3, do not pick any number.

**Example 3:**

**Input:** nums = [1,2,3,4,4]
**Output:** 12
**Explanation:** Pick numbers 1, 3, 4 and 4 their sum is 12 (maximum sum divisible by 3).

 

**Constraints:**

	
`1 <= nums.length <= 4 * 104`

	
`1 <= nums[i] <= 104`

**Hints:**
1. Represent the state as DP[pos][mod]: maximum possible sum starting in the position "pos" in the array where the current sum modulo 3 is equal to mod.

---

## Solution

```python

```
