# 3762. Minimum Operations to Equalize Subarrays

**Difficulty:** Hard
**Tags:** Array, Math, Binary Search, Segment Tree
**Acceptance Rate:** 20.2%
**Access:** Free
**URL:** https://leetcode.com/problems/minimum-operations-to-equalize-subarrays/

---

You are given an integer array `nums` and an integer `k`.

In one operation, you can **increase or decrease **any element of `nums` by **exactly** `k`.

You are also given a 2D integer array `queries`, where each `queries[i] = [li, ri]`.

For each query, find the **minimum** number of operations required to make **all** elements in the **subarray** `nums[li..ri]` **equal**. If it is impossible, the answer for that query is `-1`.

Return an array `ans`, where `ans[i]` is the answer for the `ith` query.

 

**Example 1:**

**Input:** nums = [1,4,7], k = 3, queries = [[0,1],[0,2]]

**Output:** [1,2]

**Explanation:**

One optimal set of operations:

	
		

			 | `i`
			 | `[li, ri]`
			 | `nums[li..ri]`
			 | Possibility
			 | Operations
			 | Final

			`nums[li..ri]`
			 | `ans[i]`
		

	
	
		

			 | 0
			 | [0, 1]
			 | [1, 4]
			 | Yes
			 | `nums[0] + k = 1 + 3 = 4 = nums[1]`
			 | [4, 4]
			 | 1
		

		

			 | 1
			 | [0, 2]
			 | [1, 4, 7]
			 | Yes
			 | `nums[0] + k = 1 + 3 = 4 = nums[1]

			nums[2] - k = 7 - 3 = 4 = nums[1]`
			 | [4, 4, 4]
			 | 2
		

	

Thus, `ans = [1, 2]`.

**Example 2:**

**Input:** nums = [1,2,4], k = 2, queries = [[0,2],[0,0],[1,2]]

**Output:** [-1,0,1]

**Explanation:**

One optimal set of operations:

	
		

			 | `i`
			 | `[li, ri]`
			 | `nums[li..ri]`
			 | Possibility
			 | Operations
			 | Final

			`nums[li..ri]`
			 | `ans[i]`
		

		

			 | 0
			 | [0, 2]
			 | [1, 2, 4]
			 | No
			 | -
			 | [1, 2, 4]
			 | -1
		

		

			 | 1
			 | [0, 0]
			 | [1]
			 | Yes
			 | Already equal
			 | [1]
			 | 0
		

		

			 | 2
			 | [1, 2]
			 | [2, 4]
			 | Yes
			 | `nums[1] + k = 2 + 2 = 4 = nums[2]`
			 | [4, 4]
			 | 1
		

	

Thus, `ans = [-1, 0, 1]`.

 

**Constraints:**

	
`1 <= n == nums.length <= 4 × 104`

	
`1 <= nums[i] <= 109`​​​​​​​

	
`1 <= k <= 109`

	
`1 <= queries.length <= 4 × 104`

	
`​​​​​​​queries[i] = [li, ri]`

	
`0 <= li <= ri <= n - 1`

**Hints:**
1. To make all elements in a subarray equal, they must all share the same remainder when divided by `k`.
2. The problem is equivalent to making `nums[i] / k` equal for all elements in the subarray. The minimum operations to achieve this is to make them all equal to the median of these `nums[i] / k` values.
3. To handle many queries efficiently, pre-process the array. Group elements by their remainder mod `k`. For each group, we need a data structure to find the median and sum of absolute differences for any given range.
4. A Persistent Segment Tree can answer range median and range sum queries in logarithmic time, making it suitable for this problem.

---

## Solution

```python

```
