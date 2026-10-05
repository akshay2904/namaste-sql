# 3702. Longest Subsequence With Non-Zero Bitwise XOR

**Difficulty:** Medium
**Tags:** Array, Bit Manipulation
**Acceptance Rate:** 37.3%
**Access:** Free
**URL:** https://leetcode.com/problems/longest-subsequence-with-non-zero-bitwise-xor/

---

You are given an integer array `nums`.

Return the length of the **longest subsequence** in `nums` whose bitwise **XOR** is **non-zero**. If no such **subsequence** exists, return 0.

 

**Example 1:**

**Input:** nums = [1,2,3]

**Output:** 2

**Explanation:**

One longest subsequence is `[2, 3]`. The bitwise XOR is computed as `2 XOR 3 = 1`, which is non-zero.

**Example 2:**

**Input:** nums = [2,3,4]

**Output:** 3

**Explanation:**

The longest subsequence is `[2, 3, 4]`. The bitwise XOR is computed as `2 XOR 3 XOR 4 = 5`, which is non-zero.

 

**Constraints:**

	
`1 <= nums.length <= 105`

	
`0 <= nums[i] <= 109`

**Hints:**
1. What happens if you take the entire array?
2. If the XOR of the entire array is 0, can removing one element help?
3. What if all elements are 0?

---

## Solution

```python

```
