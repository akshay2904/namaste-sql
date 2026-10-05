# 1163. Last Substring in Lexicographical Order

**Difficulty:** Hard
**Tags:** Two Pointers, String
**Acceptance Rate:** 35.0%
**Access:** Free
**URL:** https://leetcode.com/problems/last-substring-in-lexicographical-order/

---

Given a string `s`, return the last substring of `s` in lexicographical order.

 

**Example 1:**

**Input:** s = "abab"
**Output:** "bab"
**Explanation:** The substrings are ["a", "ab", "aba", "abab", "b", "ba", "bab"]. The lexicographically maximum substring is "bab".

**Example 2:**

**Input:** s = "leetcode"
**Output:** "tcode"

 

**Constraints:**

	
`1 <= s.length <= 4 * 105`

	
`s` contains only lowercase English letters.

**Hints:**
1. Assume that the answer is a sub-string from index i to j. If you add the character at index j+1 you get a better answer.
2. The answer is always a suffix of the given string.
3. Since the limits are high, we need an efficient data structure.
4. Use suffix array.

---

## Solution

```python

```
