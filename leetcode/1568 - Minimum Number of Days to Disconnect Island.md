# 1568. Minimum Number of Days to Disconnect Island

**Difficulty:** Hard
**Tags:** Array, Depth-First Search, Breadth-First Search, Matrix, Strongly Connected Component
**Acceptance Rate:** 58.7%
**Access:** Free
**URL:** https://leetcode.com/problems/minimum-number-of-days-to-disconnect-island/

---

You are given an `m x n` binary grid `grid` where `1` represents land and `0` represents water. An **island** is a maximal **4-directionally** (horizontal or vertical) connected group of `1`'s.

The grid is said to be **connected** if we have **exactly one island**, otherwise is said **disconnected**.

In one day, we are allowed to change **any **single land cell `(1)` into a water cell `(0)`.

Return the minimum number of days to disconnect the grid.

 

**Example 1:**

**Input:** grid = [[0,1,1,0],[0,1,1,0],[0,0,0,0]]

**Output:** 2
**Explanation:** We need at least 2 days to get a disconnected grid.
Change land grid[1][1] and grid[0][2] to water and get 2 disconnected island.

**Example 2:**

**Input:** grid = [[1,1]]
**Output:** 2
**Explanation:** Grid of full water is also disconnected ([[1,1]] -> [[0,0]]), 0 islands.

 

**Constraints:**

	
`m == grid.length`

	
`n == grid[i].length`

	
`1 <= m, n <= 30`

	
`grid[i][j]` is either `0` or `1`.

**Hints:**
1. Return 0 if the grid is already disconnected.
2. Return 1 if changing a single land to water disconnect the island.
3. Otherwise return 2.
4. We can disconnect the grid within at most 2 days.

---

## Solution

```python

```
