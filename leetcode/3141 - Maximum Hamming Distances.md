# 3141. Maximum Hamming Distances

**Difficulty:** Hard
**Tags:** Array, Bit Manipulation, Breadth-First Search
**Acceptance Rate:** 49.4%
**Access:** Premium
**URL:** https://leetcode.com/problems/maximum-hamming-distances/

---

_Problem description unavailable (Premium required)._

**Hints:**
1. For each `nums[i]`, complement it (for each bit, if it is 1, it becomes 0 and vice-versa).
2. Instead of finding the maximum Hamming distance from `x = nums[i]`, let's think of finding the minimum Hamming distance from the complement of `x` to any element of the array.
3. Create a graph with `V = {0, 1, ..., 2m - 1}`. Put an edge between two vertices if they differ in exactly one bit.
4. Run a multi-source BFS from elements of `nums`.
5. Now for each `x`, to find its minimum Hamming distance from elements of the array, simply calculate its shortest path from array elements.

---

## Solution

```python

```
