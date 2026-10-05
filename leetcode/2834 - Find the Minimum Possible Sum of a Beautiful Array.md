# 2834. Find the Minimum Possible Sum of a Beautiful Array

**Difficulty:** Medium
**Tags:** Math, Greedy
**Acceptance Rate:** 35.0%
**Access:** Free
**URL:** https://leetcode.com/problems/find-the-minimum-possible-sum-of-a-beautiful-array/

---

You are given positive integers `n` and `target`.

An array `nums` is **beautiful** if it meets the following conditions:

	
`nums.length == n`.

	
`nums` consists of pairwise **distinct** **positive** integers.

	
There doesn't exist two **distinct** indices, `i` and `j`, in the range `[0, n - 1]`, such that `nums[i] + nums[j] == target`.

Return the **minimum** possible sum that a beautiful array could have modulo `109 + 7`.

 

**Example 1:**

**Input:** n = 2, target = 3
**Output:** 4
**Explanation:** We can see that nums = [1,3] is beautiful.
- The array nums has length n = 2.
- The array nums consists of pairwise distinct positive integers.
- There doesn't exist two distinct indices, i and j, with nums[i] + nums[j] == 3.
It can be proven that 4 is the minimum possible sum that a beautiful array could have.

**Example 2:**

**Input:** n = 3, target = 3
**Output:** 8
**Explanation:** We can see that nums = [1,3,4] is beautiful.
- The array nums has length n = 3.
- The array nums consists of pairwise distinct positive integers.
- There doesn't exist two distinct indices, i and j, with nums[i] + nums[j] == 3.
It can be proven that 8 is the minimum possible sum that a beautiful array could have.

**Example 3:**

**Input:** n = 1, target = 1
**Output:** 1
**Explanation:** We can see, that nums = [1] is beautiful.

 

**Constraints:**

	
`1 <= n <= 109`

	
`1 <= target <= 109`

**Hints:**
1. Greedily try to add the smallest possible number in the array `nums`, such that `nums` contains distinct positive integers, and there are no two indices `i` and `j` with `nums[i] + nums[j] == target`.

---

## Solution

```python

```
