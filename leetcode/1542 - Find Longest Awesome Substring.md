# 1542. Find Longest Awesome Substring

**Difficulty:** Hard
**Tags:** Hash Table, String, Bit Manipulation
**Acceptance Rate:** 46.8%
**Access:** Free
**URL:** https://leetcode.com/problems/find-longest-awesome-substring/

---

You are given a string `s`. An **awesome** substring is a non-empty substring of `s` such that we can make any number of swaps in order to make it a palindrome.

Return the length of the maximum length **awesome substring** of `s`.

 

**Example 1:**

**Input:** s = "3242415"
**Output:** 5
**Explanation:** "24241" is the longest awesome substring, we can form the palindrome "24142" with some swaps.

**Example 2:**

**Input:** s = "12345678"
**Output:** 1

**Example 3:**

**Input:** s = "213123"
**Output:** 6
**Explanation:** "213123" is the longest awesome substring, we can form the palindrome "231132" with some swaps.

 

**Constraints:**

	
`1 <= s.length <= 105`

	
`s` consists only of digits.

**Hints:**
1. Given the character counts, under what conditions can a palindrome be formed ?
2. From left to right, use bitwise xor-operation to compute for any prefix the number of times modulo 2 of each digit.  (mask ^= (1<<(s[i]-'0')).
3. Expected complexity is O(n*A) where A is the alphabet (10).

---

## Solution

```python

```
