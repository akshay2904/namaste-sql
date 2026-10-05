# 2595. Number of Even and Odd Bits

**Difficulty:** Easy
**Tags:** Bit Manipulation
**Acceptance Rate:** 73.5%
**Access:** Free
**URL:** https://leetcode.com/problems/number-of-even-and-odd-bits/

---

You are given a **positive** integer `n`.

Let `even` denote the number of even indices in the binary representation of `n` with value 1.

Let `odd` denote the number of odd indices in the binary representation of `n` with value 1.

Note that bits are indexed from **right to left** in the binary representation of a number.

Return the array `[even, odd]`.

 

**Example 1:**

**Input:** n = 50

**Output:** [1,2]

**Explanation:**

The binary representation of 50 is `110010`.

It contains 1 on indices 1, 4, and 5.

**Example 2:**

**Input:** n = 2

**Output:** [0,1]

**Explanation:**

The binary representation of 2 is `10`.

It contains 1 only on index 1.

 

**Constraints:**

	
`1 <= n <= 1000`

**Hints:**
1. Maintain two integer variables, even and odd, to count the number of even and odd indices in the binary representation of integer n.
2. Divide n by 2 while n is positive, and if n modulo 2 is 1, add 1 to its corresponding variable.

---

## Solution

```python

```
