# 1960. Maximum Product of the Length of Two Palindromic Substrings

**Difficulty:** Hard
**Tags:** Two Pointers, String, Rolling Hash, Hash Function
**Acceptance Rate:** 31.0%
**Access:** Free
**URL:** https://leetcode.com/problems/maximum-product-of-the-length-of-two-palindromic-substrings/

---

You are given a **0-indexed** string `s` and are tasked with finding two **non-intersecting palindromic **substrings of **odd** length such that the product of their lengths is maximized.

More formally, you want to choose four integers `i`, `j`, `k`, `l` such that `0 <= i <= j < k <= l < s.length` and both the substrings `s[i...j]` and `s[k...l]` are palindromes and have odd lengths. `s[i...j]` denotes a substring from index `i` to index `j` **inclusive**.

Return the **maximum** possible product of the lengths of the two non-intersecting palindromic substrings.

A **palindrome** is a string that is the same forward and backward. A **substring** is a contiguous sequence of characters in a string.

 

**Example 1:**

**Input:** s = "ababbb"
**Output:** 9
**Explanation:** Substrings "aba" and "bbb" are palindromes with odd length. product = 3 * 3 = 9.

**Example 2:**

**Input:** s = "zaaaxbbby"
**Output:** 9
**Explanation:** Substrings "aaa" and "bbb" are palindromes with odd length. product = 3 * 3 = 9.

 

**Constraints:**

	
`2 <= s.length <= 105`

	
`s` consists of lowercase English letters.

**Hints:**
1. You can use Manacher's algorithm to get the maximum palindromic substring centered at each index
2. After using Manacher's for each center use a line sweep from the center to the left and from the center to the right to find for each index the farthest center to it with distance ≤ palin[center]
3. After that, find the maximum palindrome size for each prefix in the string and for each suffix and the answer would be max(prefix[i] * suffix[i + 1])

---

## Solution

```python

```
