# 3710. Maximum Partition Factor

**Difficulty:** Hard
**Tags:** Array, Binary Search, Depth-First Search, Breadth-First Search, Union-Find, Graph Theory
**Acceptance Rate:** 31.7%
**Access:** Free
**URL:** https://leetcode.com/problems/maximum-partition-factor/

---

You are given a 2D integer array `points`, where `points[i] = [xi, yi]` represents the coordinates of the `ith` point on the Cartesian plane.

The **Manhattan distance** between two points `points[i] = [xi, yi]` and `points[j] = [xj, yj]` is `|xi - xj| + |yi - yj|`.

Split the `n` points into **exactly two non-empty** groups. The **partition factor** of a split is the **minimum** Manhattan distance among all unordered pairs of points that lie in the same group.

Return the **maximum** possible **partition factor** over all valid splits.

Note: A group of size 1 contributes no intra-group pairs. When `n = 2` (both groups size 1), there are no intra-group pairs, so define the partition factor as 0.

 

**Example 1:**

**Input:** points = [[0,0],[0,2],[2,0],[2,2]]

**Output:** 4

**Explanation:**

We split the points into two groups: `{[0, 0], [2, 2]}` and `{[0, 2], [2, 0]}`.

	

	
In the first group, the only pair has Manhattan distance `|0 - 2| + |0 - 2| = 4`.

	

	

	
In the second group, the only pair also has Manhattan distance `|0 - 2| + |2 - 0| = 4`.

	

The partition factor of this split is `min(4, 4) = 4`, which is maximal.

**Example 2:**

**Input:** points = [[0,0],[0,1],[10,0]]

**Output:** 11

**Explanation:​​​​​​​**

We split the points into two groups: `{[0, 1], [10, 0]}` and `{[0, 0]}`.

	

	
In the first group, the only pair has Manhattan distance `|0 - 10| + |1 - 0| = 11`.

	

	

	
The second group is a singleton, so it contributes no pairs.

	

The partition factor of this split is `11`, which is maximal.

 

**Constraints:**

	
`2 <= points.length <= 500`

	
`points[i] = [xi, yi]`

	
`-108 <= xi, yi <= 108`

**Hints:**
1. Use binary search
2. Binary-search the partition factor `D` to maximize it
3. For a candidate `D`, add an edge between points `i` and `j` iff `Manhattan(i,j) < D` (they must be in different groups)
4. Check whether the resulting graph is bipartite

---

## Solution

```python

```
