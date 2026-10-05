# 3142. Check if Grid Satisfies Conditions

**Difficulty:** Easy
**Tags:** Array, Matrix
**Acceptance Rate:** 45.3%
**Access:** Free
**URL:** https://leetcode.com/problems/check-if-grid-satisfies-conditions/

---

You are given a 2D matrix `grid` of size `m x n`. You need to check if each cell `grid[i][j]` is:

	
Equal to the cell below it, i.e. `grid[i][j] == grid[i + 1][j]` (if it exists).

	
Different from the cell to its right, i.e. `grid[i][j] != grid[i][j + 1]` (if it exists).

Return `true` if **all** the cells satisfy these conditions, otherwise, return `false`.

 

**Example 1:**

**Input:** grid = [[1,0,2],[1,0,2]]

**Output:** true

**Explanation:**

****

All the cells in the grid satisfy the conditions.

**Example 2:**

**Input:** grid = [[1,1,1],[0,0,0]]

**Output:** false

**Explanation:**

****

All cells in the first row are equal.

**Example 3:**

**Input:** grid = [[1],[2],[3]]

**Output:** false

**Explanation:**

Cells in the first column have different values.

 

**Constraints:**

	
`1 <= n, m <= 10`

	
`0 <= grid[i][j] <= 9`

**Hints:**
1. Check if each column has same value in each cell.
2. If the previous condition is satisfied, we can simply check the first cells in adjacent columns.

---

## Solution

```python

```
