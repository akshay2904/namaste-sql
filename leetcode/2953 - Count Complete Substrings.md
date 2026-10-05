# 2953. Count Complete Substrings

**Difficulty:** Hard
**Tags:** Hash Table, String, Sliding Window
**Acceptance Rate:** 30.4%
**Access:** Free
**URL:** https://leetcode.com/problems/count-complete-substrings/

---

You are given a string `word` and an integer `k`.

A substring `s` of `word` is **complete** if:

	
Each character in `s` occurs **exactly** `k` times.

	
The difference between two adjacent characters is **at most** `2`. That is, for any two adjacent characters `c1` and `c2` in `s`, the absolute difference in their positions in the alphabet is **at most** `2`.

Return the number of **complete **substrings of `word`.

A **substring** is a **non-empty** contiguous sequence of characters in a string.

 

**Example 1:**

**Input:** word = "igigee", k = 2
**Output:** 3
**Explanation:** The complete substrings where each character appears exactly twice and the difference between adjacent characters is at most 2 are: **igig**ee, igig**ee**, **igigee**.

**Example 2:**

**Input:** word = "aaabbbccc", k = 3
**Output:** 6
**Explanation:** The complete substrings where each character appears exactly three times and the difference between adjacent characters is at most 2 are: **aaa**bbbccc, aaa**bbb**ccc, aaabbb**ccc**, **aaabbb**ccc, aaa**bbbccc**, **aaabbbccc**.

 

**Constraints:**

	
`1 <= word.length <= 105`

	
`word` consists only of lowercase English letters.

	
`1 <= k <= word.length`

**Hints:**
1. There are at most 26 different lengths of the complete substrings: `k *1, k * 2, … k * 26`.****
2. For each length, we can use sliding window to count the frequency of each letter in the window.
3. We still need to check for all characters in the window that `abs(word[i] - word[i - 1]) <= 2`. We do this by maintaining the values of `abs(word[i] - word[i - 1])` in the sliding window dynamically in an ordered multiset or priority queue, so that we know the maximum value at each iteration.

---

## Solution

```python

```
