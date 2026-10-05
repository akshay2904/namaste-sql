# 1160. Find Words That Can Be Formed by Characters

**Difficulty:** Easy
**Tags:** Array, Hash Table, String, Counting
**Acceptance Rate:** 71.6%
**Access:** Free
**URL:** https://leetcode.com/problems/find-words-that-can-be-formed-by-characters/

---

You are given an array of strings `words` and a string `chars`.

A string is **good** if it can be formed by characters from `chars` (each character can only be used once for **each** word in `words`).

Return the sum of lengths of all good strings in words.

 

**Example 1:**

**Input:** words = ["cat","bt","hat","tree"], chars = "atach"
**Output:** 6
**Explanation:** The strings that can be formed are "cat" and "hat" so the answer is 3 + 3 = 6.

**Example 2:**

**Input:** words = ["hello","world","leetcode"], chars = "welldonehoneyr"
**Output:** 10
**Explanation:** The strings that can be formed are "hello" and "world" so the answer is 5 + 5 = 10.

 

**Constraints:**

	
`1 <= words.length <= 1000`

	
`1 <= words[i].length, chars.length <= 100`

	
`words[i]` and `chars` consist of lowercase English letters.

**Hints:**
1. Solve the problem for each string in `words` independently.
2. Now try to think in frequency of letters.
3. Count how many times each character occurs in string `chars`.
4. To form a string using characters from `chars`, the frequency of each character in `chars` must be greater than or equal the frequency of that character in the string to be formed.

---

## Solution

```python

```
