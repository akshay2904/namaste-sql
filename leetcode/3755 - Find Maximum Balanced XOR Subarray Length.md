# 3755. Find Maximum Balanced XOR Subarray Length

**Difficulty:** Medium
**Tags:** Array, Hash Table, Bit Manipulation, Prefix Sum
**Acceptance Rate:** 50.9%
**Access:** Free
**URL:** https://leetcode.com/problems/find-maximum-balanced-xor-subarray-length/

---

Given an integer array `nums`, return the **length** of the **longest subarray** that has a bitwise XOR of zero and contains an **equal** number of **even** and **odd** numbers. If no such subarray exists, return 0.

 

**Example 1:**

**Input:** nums = [3,1,3,2,0]

**Output:** 4

**Explanation:**

The subarray `[1, 3, 2, 0]` has bitwise XOR `1 XOR 3 XOR 2 XOR 0 = 0` and contains 2 even and 2 odd numbers.

**Example 2:**

**Input:** nums = [3,2,8,5,4,14,9,15]

**Output:** 8

**Explanation:**

The whole array has bitwise XOR `0` and contains 4 even and 4 odd numbers.

**Example 3:**

**Input:** nums = [0]

**Output:** 0

**Explanation:**

No non-empty subarray satisfies both conditions.

 

**Constraints:**

	
`1 <= nums.length <= 105`

	
`0 <= nums[i] <= 109`

**Hints:**
1. In one pass maintain prefix `pxor` and prefix `diff` = (#evens − #odds) and record in a hash‑map the earliest index where each state (`pxor,diff`) occurs.
2. At each index, if the current state (`pxor,diff`) is already in the map, update the max length as the current index minus the recorded index.

---

## Solution

```python

```
