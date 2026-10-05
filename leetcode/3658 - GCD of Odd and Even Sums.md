# 3658. GCD of Odd and Even Sums

**Difficulty:** Easy
**Tags:** Math, Number Theory
**Acceptance Rate:** 85.0%
**Access:** Free
**URL:** https://leetcode.com/problems/gcd-of-odd-and-even-sums/

---

You are given an integer `n`. Your task is to compute the **GCD** (greatest common divisor) of two values:

	

	
`sumOdd`: the sum of the smallest `n` positive odd numbers.

	

	

	
`sumEven`: the sum of the smallest `n` positive even numbers.

	

Return the GCD of `sumOdd` and `sumEven`.

 

**Example 1:**

**Input:** n = 4

**Output:** 4

**Explanation:**

	
Sum of the first 4 odd numbers `sumOdd = 1 + 3 + 5 + 7 = 16`

	
Sum of the first 4 even numbers `sumEven = 2 + 4 + 6 + 8 = 20`

Hence, `GCD(sumOdd, sumEven) = GCD(16, 20) = 4`.

**Example 2:**

**Input:** n = 5

**Output:** 5

**Explanation:**

	
Sum of the first 5 odd numbers `sumOdd = 1 + 3 + 5 + 7 + 9 = 25`

	
Sum of the first 5 even numbers `sumEven = 2 + 4 + 6 + 8 + 10 = 30`

Hence, `GCD(sumOdd, sumEven) = GCD(25, 30) = 5`.

 

**Constraints:**

	
`1 <= n <= 10​​​​​​​00`

**Hints:**
1. The first `n` odd numbers sum to `n * n`
2. First `n` even numbers sum to `n * (n + 1)`
3. `gcd(n, n + 1) = 1`, so the answer is `n`

---

## Solution

```python

```
