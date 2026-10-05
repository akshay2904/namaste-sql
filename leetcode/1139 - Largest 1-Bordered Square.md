# 1139. Largest 1-Bordered Square

**Difficulty:** Medium
**Tags:** Array, Dynamic Programming, Matrix
**Acceptance Rate:** 52.1%
**Access:** Free
**URL:** https://leetcode.com/problems/largest-1-bordered-square/

---

Given a 2D `grid` of `0`s and `1`s, return the number of elements in the largest **square** subgrid that has all `1`s on its **border**, or `0` if such a subgrid doesn't exist in the `grid`.



 


**Example 1:**




**Input:** grid = [[1,1,1],[1,0,1],[1,1,1]]
**Output:** 9




**Example 2:**




**Input:** grid = [[1,1,0,0]]
**Output:** 1




 


**Constraints:**



	
`1 <= grid.length <= 100`

	
`1 <= grid[0].length <= 100`

	
`grid[i][j]` is `0` or `1`

**Hints:**
1. For each square, know how many ones are up, left, down, and right of this square. You can find it in O(N^2) using dynamic programming.
2. Now for each square ( O(N^3) ), we can evaluate whether that square is 1-bordered in O(1).

---

## Solution

```python

```
