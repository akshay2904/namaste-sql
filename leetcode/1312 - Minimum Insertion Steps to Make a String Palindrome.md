# 1312. Minimum Insertion Steps to Make a String Palindrome

**Difficulty:** Hard
**Tags:** String, Dynamic Programming
**Acceptance Rate:** 73.9%
**Access:** Free
**URL:** https://leetcode.com/problems/minimum-insertion-steps-to-make-a-string-palindrome/

---

Given a string `s`. In one step you can insert any character at any index of the string.

Return the minimum number of steps to make `s` palindrome.

A **Palindrome String** is one that reads the same backward as well as forward.

 

**Example 1:**

**Input:** s = "zzazz"
**Output:** 0
**Explanation:** The string "zzazz" is already palindrome we do not need any insertions.

**Example 2:**

**Input:** s = "mbadm"
**Output:** 2
**Explanation:** String can be "mbdadbm" or "mdbabdm".

**Example 3:**

**Input:** s = "leetcode"
**Output:** 5
**Explanation:** Inserting 5 characters the string becomes "leetcodocteel".

 

**Constraints:**

	
`1 <= s.length <= 500`

	
`s` consists of lowercase English letters.

**Hints:**
1. Is dynamic programming suitable for this problem ?
2. If we know the longest palindromic sub-sequence is x and the length of the string is n then, what is the answer to this problem? It is n - x as we need n - x insertions to make the remaining characters also palindrome.

---

## Solution

```python

```
