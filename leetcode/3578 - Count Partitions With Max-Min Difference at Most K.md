# 3578. Count Partitions With Max-Min Difference at Most K

**Difficulty:** Medium
**Tags:** Array, Dynamic Programming, Queue, Sliding Window, Prefix Sum, Monotonic Queue
**Acceptance Rate:** 58.6%
**Access:** Free
**URL:** https://leetcode.com/problems/count-partitions-with-max-min-difference-at-most-k/

---

You are given an integer array `nums` and an integer `k`. Your task is to partition `nums` into one or more **non-empty** contiguous segments such that in each segment, the difference between its **maximum** and **minimum** elements is **at most** `k`.

Return the total number of ways to partition `nums` under this condition.

Since the answer may be too large, return it **modulo** `109 + 7`.

 

**Example 1:**

**Input:** nums = [9,4,1,3,7], k = 4

**Output:** 6

**Explanation:**

There are 6 valid partitions where the difference between the maximum and minimum elements in each segment is at most `k = 4`:

	
`[[9], [4], [1], [3], [7]]`

	
`[[9], [4], [1], [3, 7]]`

	
`[[9], [4], [1, 3], [7]]`

	
`[[9], [4, 1], [3], [7]]`

	
`[[9], [4, 1], [3, 7]]`

	
`[[9], [4, 1, 3], [7]]`

**Example 2:**

**Input:** nums = [3,3,4], k = 0

**Output:** 2

**Explanation:**

There are 2 valid partitions that satisfy the given conditions:

	
`[[3], [3], [4]]`

	
`[[3, 3], [4]]`

 

**Constraints:**

	
`2 <= nums.length <= 5 * 104`

	
`1 <= nums[i] <= 109`

	
`0 <= k <= 109`

**Hints:**
1. Use dynamic programming.
2. Let `dp[idx]` be the count of ways to partition the array with the last partition ending at index `idx`.
3. Try using a sliding window; we can track the minimum and maximum in the window using deques.

---

## Solution

```python

```
