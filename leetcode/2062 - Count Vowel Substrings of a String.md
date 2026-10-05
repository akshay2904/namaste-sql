# 2062. Count Vowel Substrings of a String

**Difficulty:** Easy
**Tags:** Hash Table, String
**Acceptance Rate:** 73.2%
**Access:** Free
**URL:** https://leetcode.com/problems/count-vowel-substrings-of-a-string/

---

A **substring** is a contiguous (non-empty) sequence of characters within a string.

A **vowel substring** is a substring that **only** consists of vowels (`'a'`, `'e'`, `'i'`, `'o'`, and `'u'`) and has **all five** vowels present in it.

Given a string `word`, return the number of **vowel substrings** in `word`.

 

**Example 1:**

**Input:** word = "aeiouu"
**Output:** 2
**Explanation:** The vowel substrings of word are as follows (underlined):
- "**aeiou**u"
- "**aeiouu**"

**Example 2:**

**Input:** word = "unicornarihan"
**Output:** 0
**Explanation:** Not all 5 vowels are present, so there are no vowel substrings.

**Example 3:**

**Input:** word = "cuaieuouac"
**Output:** 7
**Explanation:** The vowel substrings of word are as follows (underlined):
- "c**uaieuo**uac"
- "c**uaieuou**ac"
- "c**uaieuoua**c"
- "cu**aieuo**uac"
- "cu**aieuou**ac"
- "cu**aieuoua**c"
- "cua**ieuoua**c"

 

**Constraints:**

	
`1 <= word.length <= 100`

	
`word` consists of lowercase English letters only.

**Hints:**
1. While generating substrings starting at any index, do you need to continue generating larger substrings if you encounter a consonant?
2. Can you store the count of characters to avoid generating substrings altogether?

---

## Solution

```python

```
