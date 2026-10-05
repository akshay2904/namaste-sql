# 3517. Smallest Palindromic Rearrangement I

**Difficulty:** Medium
**Tags:** String, Sorting, Counting Sort
**Acceptance Rate:** 63.7%
**Access:** Free
**URL:** https://leetcode.com/problems/smallest-palindromic-rearrangement-i/

---

You are given a **palindromic** string `s`.

Return the **lexicographically smallest** palindromic permutation of `s`.

 

**Example 1:**

**Input:** s = "z"

**Output:** "z"

**Explanation:**

A string of only one character is already the lexicographically smallest palindrome.

**Example 2:**

**Input:** s = "babab"

**Output:** "abbba"

**Explanation:**

Rearranging `"babab"` → `"abbba"` gives the smallest lexicographic palindrome.

**Example 3:**

**Input:** s = "daccad"

**Output:** "acddca"

**Explanation:**

Rearranging `"daccad"` → `"acddca"` gives the smallest lexicographic palindrome.

 

**Constraints:**

	
`1 <= s.length <= 105`

	
`s` consists of lowercase English letters.

	
`s` is guaranteed to be palindromic.

**Hints:**
1. Consider a palindrome as composed of two mirror-image halves.
2. Construct one half (using `s`), and then the other half is its reverse to obtain the lexicographically smallest permutation.

---

## Solution

```python

```
