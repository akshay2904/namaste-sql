# 3233. Find the Count of Numbers Which Are Not Special

**Difficulty:** Medium
**Tags:** Array, Math, Number Theory
**Acceptance Rate:** 27.7%
**Access:** Free
**URL:** https://leetcode.com/problems/find-the-count-of-numbers-which-are-not-special/

---

You are given 2 **positive** integers `l` and `r`. For any number `x`, all positive divisors of `x` except `x` are called the **proper divisors** of `x`.

A number is called **special** if it has exactly 2 **proper divisors**. For example:

	
The number 4 is special because it has proper divisors 1 and 2.

	
The number 6 is not special because it has proper divisors 1, 2, and 3.

Return the count of numbers in the range `[l, r]` that are **not** **special**.

 

**Example 1:**

**Input:** l = 5, r = 7

**Output:** 3

**Explanation:**

There are no special numbers in the range `[5, 7]`.

**Example 2:**

**Input:** l = 4, r = 16

**Output:** 11

**Explanation:**

The special numbers in the range `[4, 16]` are 4 and 9.

 

**Constraints:**

	
`1 <= l <= r <= 109`

**Hints:**
1. A special number must be a square of a prime number.
2. We need to find all primes in the range `[sqrt(l), sqrt(r)]`.
3. Use sieve to find primes till `sqrt(109)`.

---

## Solution

```python

```
