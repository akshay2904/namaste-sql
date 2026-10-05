# 2185. Counting Words With a Given Prefix

**Difficulty:** Easy
**Tags:** Array, String, String Matching
**Acceptance Rate:** 84.4%
**Access:** Free
**URL:** https://leetcode.com/problems/counting-words-with-a-given-prefix/

---

You are given an array of strings `words` and a string `pref`.

Return the number of strings in `words` that contain `pref` as a **prefix**.

A **prefix** of a string `s` is any leading contiguous substring of `s`.

 

**Example 1:**

**Input:** words = ["pay","**at**tention","practice","**at**tend"], `pref `= "at"
**Output:** 2
**Explanation:** The 2 strings that contain "at" as a prefix are: "**at**tention" and "**at**tend".

**Example 2:**

**Input:** words = ["leetcode","win","loops","success"], `pref `= "code"
**Output:** 0
**Explanation:** There are no strings that contain "code" as a prefix.

 

**Constraints:**

	
`1 <= words.length <= 100`

	
`1 <= words[i].length, pref.length <= 100`

	
`words[i]` and `pref` consist of lowercase English letters.

**Hints:**
1. Go through each word in words and increment the answer if pref is a prefix of the word.

---

## Solution

```python

```
