# 3725. Count Ways to Choose Coprime Integers from Rows

**Difficulty:** Hard
**Tags:** Array, Math, Dynamic Programming, Matrix, Combinatorics, Number Theory
**Acceptance Rate:** 48.5%
**Access:** Free
**URL:** https://leetcode.com/problems/count-ways-to-choose-coprime-integers-from-rows/

---

You are given a `m x n` matrix `mat` of positive integers.

Return an integer denoting the number of ways to choose **exactly one** integer from each row of `mat` such that the **greatest common divisor** of all chosen integers is 1.

Since the answer may be very large, return it **modulo** `109 + 7`.

 

**Example 1:**

**Input:** mat = [[1,2],[3,4]]

**Output:** 3

**Explanation:**

	
		

			 | Chosen integer in the first row
			 | Chosen integer in the second row
			 | Greatest common divisor of chosen integers
		

		

			 | 1
			 | 3
			 | 1
		

		

			 | 1
			 | 4
			 | 1
		

		

			 | 2
			 | 3
			 | 1
		

		

			 | 2
			 | 4
			 | 2
		

	

3 of these combinations have a greatest common divisor of 1. Therefore, the answer is 3.

**Example 2:**

**Input:** mat = [[2,2],[2,2]]

**Output:** 0

**Explanation:**

Every combination has a greatest common divisor of 2. Therefore, the answer is 0.

 

**Constraints:**

	
`1 <= m == mat.length <= 150`

	
`1 <= n == mat[i].length <= 150`

	
`1 <= mat[i][j] <= 150`

**Hints:**
1. Use dynamic programming.
2. Use `dp[row][g]`, where `row` is the current row and `g` is the current gcd value.
3. Initialize the first row: for each value `v` in row 0 do `dp[0][v] += 1`.
4. For a row `i`, use the values from the previous row `i - 1` to build the values: for each previous gcd `g` and each value `v` in row `i`.
5. The final answer is `dp[n-1][1]` (number of ways with gcd 1).

---

## Solution

```python

```
