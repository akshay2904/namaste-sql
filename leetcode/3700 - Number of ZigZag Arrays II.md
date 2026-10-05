# 3700. Number of ZigZag Arrays II

**Difficulty:** Hard
**Tags:** Math, Dynamic Programming
**Acceptance Rate:** 57.5%
**Access:** Free
**URL:** https://leetcode.com/problems/number-of-zigzag-arrays-ii/

---

You are given three integers `n`, `l`, and `r`.

A **ZigZag** array of length `n` is defined as follows:

	
Each element lies in the range `[l, r]`.

	
No **two** adjacent elements are equal.

	
No **three** consecutive elements form a **strictly increasing** or **strictly decreasing** sequence.

Return the total number of valid **ZigZag** arrays.

Since the answer may be large, return it **modulo** `109 + 7`.

A **sequence** is said to be **strictly increasing** if each element is strictly greater than its previous one (if exists).

A **sequence** is said to be **strictly decreasing** if each element is strictly smaller than its previous one (if exists).

 

**Example 1:**

**Input:** n = 3, l = 4, r = 5

**Output:** 2

**Explanation:**

There are only 2 valid ZigZag arrays of length `n = 3` using values in the range `[4, 5]`:

	
`[4, 5, 4]`

	
`[5, 4, 5]`

**Example 2:**

**Input:** n = 3, l = 1, r = 3

**Output:** 10

**Explanation:**

​​​​​​​There are 10 valid ZigZag arrays of length `n = 3` using values in the range `[1, 3]`:

	
`[1, 2, 1]`, `[1, 3, 1]`, `[1, 3, 2]`

	
`[2, 1, 2]`, `[2, 1, 3]`, `[2, 3, 1]`, `[2, 3, 2]`

	
`[3, 1, 2]`, `[3, 1, 3]`, `[3, 2, 3]`

All arrays meet the ZigZag conditions.

 

**Constraints:**

	
`3 <= n <= 109`

	
`1 <= l < r <= 75`​​​​​​​

**Hints:**
1. Use matrix exponentiation
2. Encode states in a vector of length `2*m` where `m = r - l + 1`: first `m` entries = "next compare = down" for values, next `m` = "next compare = up".
3. Build a transition matrix `T` (size `2*m × 2*m`): from an `up,x` state go to `down,y` for every `y > x`, and from `down,x` go to `up,y` for every `y < x`.
4. Use fast matrix exponentiation to compute `T^(n-1)`, apply it to the initial vector (ones in the block for starting `up` and separately for starting `down`), sum final entries, and add both results (for `n=1` return `m`).

---

## Solution

```python

```
