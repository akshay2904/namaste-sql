# 3844. Longest Almost-Palindromic Substring

**Difficulty:** Medium
**Tags:** Two Pointers, String, Dynamic Programming
**Acceptance Rate:** 22.5%
**Access:** Free
**URL:** https://leetcode.com/problems/longest-almost-palindromic-substring/

---

You are given a string `s` consisting of lowercase English letters.

A substring is **almost-palindromic** if it becomes a palindrome after removing **exactly** one character from it.

Return an integer denoting the length of the **longest** **almost-palindromic** substring in `s`.

 

**Example 1:**

**Input:** s = "abca"

**Output:** 4

**Explanation:**

Choose the substring `"**abca**"`.

	
Remove `"ab**c**a"`.

	
The string becomes `"aba"`, which is a palindrome.

	
Therefore, `"abca"` is almost-palindromic.

**Example 2:**

**Input:** s = "abba"

**Output:** 4

**Explanation:**

Choose the substring `"**abba**"`.

	
Remove `"a**b**ba"`.

	
The string becomes `"aba"`, which is a palindrome.

	
Therefore, `"abba"` is almost-palindromic.

**Example 3:**

**Input:** s = "zzabba"

**Output:** 5

**Explanation:**

Choose the substring `"z**zabba**"`.

	
Remove `"**z**abba"`.

	
The string becomes `"abba"`, which is a palindrome.

	
Therefore, `"zabba"` is almost-palindromic.

 

**Constraints:**

	
`2 <= s.length <= 2500`

	
`s` consists of only lowercase English letters.

**Hints:**
1. Solve greedily
2. Fix the center (consider both odd and even centers) and expand outwards
3. On the first mismatch, try skipping the left character and continue expanding, and also try skipping the right character; take the longer result
4. Track the maximum length found across all centers

---

## Solution

```python

```
