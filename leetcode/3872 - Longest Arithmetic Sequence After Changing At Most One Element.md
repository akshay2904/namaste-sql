# 3872. Longest Arithmetic Sequence After Changing At Most One Element

**Difficulty:** Medium
**Tags:** Array, Enumeration
**Acceptance Rate:** 21.1%
**Access:** Free
**URL:** https://leetcode.com/problems/longest-arithmetic-sequence-after-changing-at-most-one-element/

---

You are given an integer array `nums`.

A subarray is **arithmetic** if the difference between consecutive elements in the subarray is constant.

You can replace **at most one** element in `nums` with any **integer**. Then, you select an arithmetic subarray from `nums`.

Return an integer denoting the **maximum** length of the arithmetic subarray you can select.

 

**Example 1:**

**Input:** nums = [9,7,5,10,1]

**Output:** 5

**Explanation:**

	
Replace `nums[3] = 10` with 3. The array becomes `[9, 7, 5, 3, 1]`.

	
Select the subarray `[**9, 7, 5, 3, 1**]`, which is arithmetic because consecutive elements have a common difference of -2.

**Example 2:**

**Input:** nums = [1,2,6,7]

**Output:** 3

**Explanation:**

	
Replace `nums[0] = 1` with -2. The array becomes `[-2, 2, 6, 7]`.

	
Select the subarray `[**-2, 2, 6**, 7]`, which is arithmetic because consecutive elements have a common difference of 4.

 

**Constraints:**

	
`4 <= nums.length <= 105`

	
`1 <= nums[i] <= 105`

**Hints:**
1. Precompute `L[i]` = length of longest arithmetic subarray ending at `i` using fixed differences.
2. Precompute `R[i]` = length of longest arithmetic subarray starting at `i`.
3. For each index `i` as the replaced element, check if neighbors allow a common difference `d = (nums[i+1] - nums[i-1]) / 2` and combine `L[i-1]` and `R[i+1]`.
4. Also consider extending only left or only right, and take the maximum over all positions.

---

## Solution

```python

```
