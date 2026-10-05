# 1314. Matrix Block Sum

**Difficulty:** Medium
**Tags:** Array, Matrix, Prefix Sum
**Acceptance Rate:** 76.5%
**Access:** Free
**URL:** https://leetcode.com/problems/matrix-block-sum/

---

Given a `m x n` matrix `mat` and an integer `k`, return a matrix `answer` where each `answer[i][j]` is the sum of all elements `mat[r][c]` for:

	
`i - k <= r <= i + k,`

	
`j - k <= c <= j + k`, and

	
`(r, c)` is a valid position in the matrix.

 

**Example 1:**

**Input:** mat = [[1,2,3],[4,5,6],[7,8,9]], k = 1
**Output:** [[12,21,16],[27,45,33],[24,39,28]]

**Example 2:**

**Input:** mat = [[1,2,3],[4,5,6],[7,8,9]], k = 2
**Output:** [[45,45,45],[45,45,45],[45,45,45]]

 

**Constraints:**

	
`m == mat.length`

	
`n == mat[i].length`

	
`1 <= m, n, k <= 100`

	
`1 <= mat[i][j] <= 100`

**Hints:**
1. How to calculate the required sum for a cell (i,j) fast ?
2. Use the concept of cumulative sum array.
3. Create a cumulative sum matrix where dp[i][j] is the sum of all cells in the rectangle from (0,0) to (i,j), use inclusion-exclusion idea.

---

## Solution

```python

```
