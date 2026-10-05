# 3825. Longest Strictly Increasing Subsequence With Non-Zero Bitwise AND

**Difficulty:** Medium
**Tags:** Array, Binary Search, Bit Manipulation, Enumeration
**Acceptance Rate:** 50.6%
**Access:** Free
**URL:** https://leetcode.com/problems/longest-strictly-increasing-subsequence-with-non-zero-bitwise-and/

---

You are given an integer array `nums`.

Return the length of the **longest strictly increasing subsequence** in `nums` whose bitwise **AND** is **non-zero**. If no such **subsequence** exists, return 0.

 

**Example 1:**

**Input:** nums = [5,4,7]

**Output:** 2

**Explanation:**

One longest strictly increasing subsequence is `[5, 7]`. The bitwise AND is `5 AND 7 = 5`, which is non-zero.

**Example 2:**

**Input:** nums = [2,3,6]

**Output:** 3

**Explanation:**

The longest strictly increasing subsequence is `[2, 3, 6]`. The bitwise AND is `2 AND 3 AND 6 = 2`, which is non-zero.

**Example 3:**

**Input:** nums = [0,1]

**Output:** 1

**Explanation:**

One longest strictly increasing subsequence is `[1]`. The bitwise AND is 1, which is non-zero.

 

**Constraints:**

	
`1 <= nums.length <= 105`

	
`0 <= nums[i] <= 109`​​​​​​​

**Hints:**
1. Solve bit-by-bit for each `b` in `0..30`.
2. Filter: take elements with bit `b` set, preserving order.
3. On that filtered sequence compute the longest increasing subsequence (LIS).
4. Return the maximum LIS over all bits; if no candidates return `0`.

---

## Solution

```python

```
