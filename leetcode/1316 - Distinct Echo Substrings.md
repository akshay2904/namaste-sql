# 1316. Distinct Echo Substrings

**Difficulty:** Hard
**Tags:** String, Trie, Rolling Hash, Hash Function
**Acceptance Rate:** 53.2%
**Access:** Free
**URL:** https://leetcode.com/problems/distinct-echo-substrings/

---

Return the number of **distinct** non-empty substrings of `text` that can be written as the concatenation of some string with itself (i.e. it can be written as `a + a` where `a` is some string).

 

**Example 1:**

**Input:** text = "abcabcabc"
**Output:** 3
**Explanation: **The 3 substrings are "abcabc", "bcabca" and "cabcab".

**Example 2:**

**Input:** text = "leetcodeleetcode"
**Output:** 2
**Explanation: **The 2 substrings are "ee" and "leetcodeleetcode".

 

**Constraints:**

	
`1 <= text.length <= 2000`

	
`text` has only lowercase English letters.

**Hints:**
1. Given a substring of the text, how to check if it can be written as the concatenation of a string with itself ?
2. We can do that in linear time, a faster way is to use hashing.
3. Try all substrings and use hashing to check them.

---

## Solution

```python

```
