# 3430. Maximum and Minimum Sums of at Most Size K Subarrays

**Difficulty:** Hard
**Tags:** Array, Math, Stack, Monotonic Stack
**Acceptance Rate:** 25.6%
**Access:** Free
**URL:** https://leetcode.com/problems/maximum-and-minimum-sums-of-at-most-size-k-subarrays/

---

You are given an integer array `nums` and a **positive** integer `k`. Return the sum of the **maximum** and **minimum** elements of all subarrays with **at most** `k` elements.

 

**Example 1:**

**Input:** nums = [1,2,3], k = 2

**Output:** 20

**Explanation:**

The subarrays of `nums` with at most 2 elements are:

	
		

			 | **Subarray**
			 | Minimum
			 | Maximum
			 | Sum
		

		

			 | `[1]`
			 | 1
			 | 1
			 | 2
		

		

			 | `[2]`
			 | 2
			 | 2
			 | 4
		

		

			 | `[3]`
			 | 3
			 | 3
			 | 6
		

		

			 | `[1, 2]`
			 | 1
			 | 2
			 | 3
		

		

			 | `[2, 3]`
			 | 2
			 | 3
			 | 5
		

		

			 | **Final Total**
			 |  
			 |  
			 | 20
		

	

The output would be 20.

**Example 2:**

**Input:** nums = [1,-3,1], k = 2

**Output:** -6

**Explanation:**

The subarrays of `nums` with at most 2 elements are:

	
		

			 | **Subarray**
			 | Minimum
			 | Maximum
			 | Sum
		

		

			 | `[1]`
			 | 1
			 | 1
			 | 2
		

		

			 | `[-3]`
			 | -3
			 | -3
			 | -6
		

		

			 | `[1]`
			 | 1
			 | 1
			 | 2
		

		

			 | `[1, -3]`
			 | -3
			 | 1
			 | -2
		

		

			 | `[-3, 1]`
			 | -3
			 | 1
			 | -2
		

		

			 | **Final Total**
			 |  
			 |  
			 | -6
		

	

The output would be -6.

 

**Constraints:**

	
`1 <= nums.length <= 80000`

	
`1 <= k <= nums.length`

	
`-106 <= nums[i] <= 106`

**Hints:**
1. Use a monotonic stack.
2. How can we calculate the number of subarrays where an element is the largest?
3. Enforce the condition on size too.

---

## Solution

```python

```
