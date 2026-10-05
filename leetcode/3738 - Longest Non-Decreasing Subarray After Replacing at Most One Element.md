# 3738. Longest Non-Decreasing Subarray After Replacing at Most One Element

**Difficulty:** Medium
**Tags:** Array, Dynamic Programming
**Acceptance Rate:** 22.1%
**Access:** Free
**URL:** https://leetcode.com/problems/longest-non-decreasing-subarray-after-replacing-at-most-one-element/

---

You are given an integer array `nums`.

You are allowed to replace **at most** one element in the array with any other integer value of your choice.

Return the length of the **longest non-decreasing subarray** that can be obtained after performing at most one replacement.

An array is said to be **non-decreasing** if each element is greater than or equal to its previous one (if it exists).

 

**Example 1:**

**Input:** nums = [1,2,3,1,2]

**Output:** 4

**Explanation:**

Replacing `nums[3] = 1` with 3 gives the array [1, 2, 3, 3, 2].

The longest non-decreasing subarray is [1, 2, 3, 3], which has a length of 4.

**Example 2:**

**Input:** nums = [2,2,2,2,2]

**Output:** 5

**Explanation:**

All elements in `nums` are equal, so it is already non-decreasing and the entire `nums` forms a subarray of length 5.

 

**Constraints:**

	
`1 <= nums.length <= 105`

	
`-109 <= nums[i] <= 109`​​​​​​​

**Hints:**
1. Use prefix and suffix arrays
2. Create a prefix array where `pref[i]` denotes the maximum-length non-decreasing subarray ending at `i`
3. Create a suffix array where `suff[i]` denotes the maximum-length non-decreasing subarray starting at `i`
4. Let the initial maximum be `max(max(pref), max(suff))`
5. For each index `i`, try to combine the prefix ending at `i - 1` and the suffix starting at `i + 1` if possible; also consider the maximum without combining them

---

## Solution

```python

```
