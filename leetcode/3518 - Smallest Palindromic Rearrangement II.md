# 3518. Smallest Palindromic Rearrangement II

**Difficulty:** Hard
**Tags:** Hash Table, Math, String, Combinatorics, Counting
**Acceptance Rate:** 14.6%
**Access:** Free
**URL:** https://leetcode.com/problems/smallest-palindromic-rearrangement-ii/

---

You are given a **palindromic** string `s` and an integer `k`.

Return the **k-th** **lexicographically smallest** palindromic permutation of `s`. If there are fewer than `k` distinct palindromic permutations, return an empty string.

**Note:** Different rearrangements that yield the same palindromic string are considered identical and are counted once.

 

**Example 1:**

**Input:** s = "abba", k = 2

**Output:** "baab"

**Explanation:**

	
The two distinct palindromic rearrangements of `"abba"` are `"abba"` and `"baab"`.

	
Lexicographically, `"abba"` comes before `"baab"`. Since `k = 2`, the output is `"baab"`.

**Example 2:**

**Input:** s = "aa", k = 2

**Output:** ""

**Explanation:**

	
There is only one palindromic rearrangement: `"aa"`.

	
The output is an empty string since `k = 2` exceeds the number of possible rearrangements.

**Example 3:**

**Input:** s = "bacab", k = 1

**Output:** "abcba"

**Explanation:**

	
The two distinct palindromic rearrangements of `"bacab"` are `"abcba"` and `"bacab"`.

	
Lexicographically, `"abcba"` comes before `"bacab"`. Since `k = 1`, the output is `"abcba"`.

 

**Constraints:**

	
`1 <= s.length <= 104`

	
`s` consists of lowercase English letters.

	
`s` is guaranteed to be palindromic.

	
`1 <= k <= 106`

**Hints:**
1. Only build `floor(n / 2)` characters (the rest are determined by symmetry).
2. Count character frequencies and use half the counts for construction.
3. Incrementally choose each character (from smallest to largest) and calculate how many valid arrangements result if that character is chosen at the current index.
4. If the count is at least `k`, fix that character; otherwise, subtract the count from `k` and try the next candidate.
5. Use combinatorics to compute the number of permutations at each step.

---

## Solution

```python

```
