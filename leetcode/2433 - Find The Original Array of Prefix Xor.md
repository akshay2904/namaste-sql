# 2433. Find The Original Array of Prefix Xor

**Difficulty:** Medium
**Tags:** Array, Bit Manipulation
**Acceptance Rate:** 88.4%
**Access:** Free
**URL:** https://leetcode.com/problems/find-the-original-array-of-prefix-xor/

---

You are given an **integer** array `pref` of size `n`. Find and return the array `arr` of size `n` that satisfies:

	
`pref[i] = arr[0] ^ arr[1] ^ ... ^ arr[i]`.

Note that `^` denotes the **bitwise-xor** operation.

It can be proven that the answer is **unique**.

 

**Example 1:**

**Input:** pref = [5,2,0,3,1]
**Output:** [5,7,2,3,2]
**Explanation:** From the array [5,7,2,3,2] we have the following:
- pref[0] = 5.
- pref[1] = 5 ^ 7 = 2.
- pref[2] = 5 ^ 7 ^ 2 = 0.
- pref[3] = 5 ^ 7 ^ 2 ^ 3 = 3.
- pref[4] = 5 ^ 7 ^ 2 ^ 3 ^ 2 = 1.

**Example 2:**

**Input:** pref = [13]
**Output:** [13]
**Explanation:** We have pref[0] = arr[0] = 13.

 

**Constraints:**

	
`1 <= pref.length <= 105`

	
`0 <= pref[i] <= 106`

**Hints:**
1. Consider the following equation: x ^ a = b. How can you find x?
2. Notice that arr[i] ^ pref[i-1] = pref[i]. This is the same as the previous equation.

---

## Solution

```python

```
