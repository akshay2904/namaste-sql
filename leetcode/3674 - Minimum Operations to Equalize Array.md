# 3674. Minimum Operations to Equalize Array

**Difficulty:** Easy
**Tags:** Array, Bit Manipulation, Brainteaser
**Acceptance Rate:** 60.4%
**Access:** Free
**URL:** https://leetcode.com/problems/minimum-operations-to-equalize-array/

---

You are given an integer array `nums` of length `n`.

In one operation, choose any subarray `nums[l...r]` (`0 <= l <= r < n`) and **replace** each element in that subarray with the **bitwise AND** of all elements.

Return the **minimum** number of operations required to make all elements of `nums` equal.

A **subarray** is a contiguous **non-empty** sequence of elements within an array.

 

**Example 1:**

**Input:** nums = [1,2]

**Output:** 1

**Explanation:**

Choose `nums[0...1]`: `(1 AND 2) = 0`, so the array becomes `[0, 0]` and all elements are equal in 1 operation.

**Example 2:**

**Input:** nums = [5,5,5]

**Output:** 0

**Explanation:**

`nums` is `[5, 5, 5]` which already has all elements equal, so 0 operations are required.

 

**Constraints:**

	
`1 <= n == nums.length <= 100`

	
`1 <= nums[i] <= 105`

**Hints:**
1. If all elements of `nums` are already equal, how many operations are needed?
2. The answer is either `0` or `1`.
3. The answer is `0` if all values in the array are initially equal, and `1` otherwise, since you can apply the AND operation on the whole array in one step.

---

## Solution

```python

```
