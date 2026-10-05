# 1363. Largest Multiple of Three

**Difficulty:** Hard
**Tags:** Array, Math, Dynamic Programming, Greedy, Sorting
**Acceptance Rate:** 33.2%
**Access:** Free
**URL:** https://leetcode.com/problems/largest-multiple-of-three/

---

Given an array of digits `digits`, return the largest multiple of **three** that can be formed by concatenating some of the given digits in **any order**. If there is no answer return an empty string.

Since the answer may not fit in an integer data type, return the answer as a string. Note that the returning answer must not contain unnecessary leading zeros.

 

**Example 1:**

**Input:** digits = [8,1,9]
**Output:** "981"

**Example 2:**

**Input:** digits = [8,6,7,1,0]
**Output:** "8760"

**Example 3:**

**Input:** digits = [1]
**Output:** ""

 

**Constraints:**

	
`1 <= digits.length <= 104`

	
`0 <= digits[i] <= 9`

**Hints:**
1. A number is a multiple of three if and only if its sum of digits is a multiple of three.
2. Use dynamic programming.
3. To find the maximum number, try to maximize the number of digits of the number.
4. Sort the digits in descending order to find the maximum number.

---

## Solution

```python

```
