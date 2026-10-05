# 3821. Find Nth Smallest Integer With K One Bits

**Difficulty:** Hard
**Tags:** Math, Bit Manipulation, Combinatorics
**Acceptance Rate:** 34.9%
**Access:** Free
**URL:** https://leetcode.com/problems/find-nth-smallest-integer-with-k-one-bits/

---

You are given two positive integers `n` and `k`.

Return an integer denoting the `nth` smallest positive integer that has **exactly** `k` ones in its binary representation. It is guaranteed that the answer is **strictly less** than `250`.

 

**Example 1:**

**Input:** n = 4, k = 2

**Output:** 9

**Explanation:**

The 4 smallest positive integers that have exactly `k = 2` ones in their binary representations are:

	
`3 = 112`

	
`5 = 1012`

	
`6 = 1102`

	
`9 = 10012`

**Example 2:**

**Input:** n = 3, k = 1

**Output:** 4

**Explanation:**

The 3 smallest positive integers that have exactly `k = 1` one in their binary representations are:

	
`1 = 12`

	
`2 = 102`

	
`4 = 1002`

 

**Constraints:**

	
`1 <= n <= 250`

	
`1 <= k <= 50`

	
The answer is strictly less than `250`.

**Hints:**
1. Since the answer is strictly less than `250`, we can iterate over the number of bits (the length) of the result.
2. Precompute binomial coefficients `C(n, k)` to count how many numbers with exactly `k` set bits exist for a given length.
3. Determine the position of the most significant bit first, then greedily determine the remaining bits from MSB to LSB based on the remaining count `n`.

---

## Solution

```python

```
