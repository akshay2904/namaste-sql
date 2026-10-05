# 3646. Next Special Palindrome Number

**Difficulty:** Hard
**Tags:** Backtracking, Bit Manipulation
**Acceptance Rate:** 28.1%
**Access:** Free
**URL:** https://leetcode.com/problems/next-special-palindrome-number/

---

You are given an integer `n`.

A number is called **special** if:

	
It is a **palindrome**.

	
Every digit `k` in the number appears **exactly** `k` times.

Return the **smallest** special number **strictly **greater than `n`.

 

**Example 1:**

**Input:** n = 2

**Output:** 22

**Explanation:**

22 is the smallest special number greater than 2, as it is a palindrome and the digit 2 appears exactly 2 times.

**Example 2:**

**Input:** n = 33

**Output:** 212

**Explanation:**

212 is the smallest special number greater than 33, as it is a palindrome and the digits 1 and 2 appear exactly 1 and 2 times respectively.

 

 

**Constraints:**

	
`0 <= n <= 1015`

**Hints:**
1. There are only a few special numbers; preprocess them.
2. Use bitmasking to brute‑force all valid selections of digits `k` for the number.
3. Generate all permutations of the first half of the digits, then mirror them to form the full palindrome.
4. For each `n`, use binary search to find the smallest special number strictly greater than `n`.

---

## Solution

```python

```
