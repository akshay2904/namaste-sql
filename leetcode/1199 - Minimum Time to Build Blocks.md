# 1199. Minimum Time to Build Blocks

**Difficulty:** Hard
**Tags:** Array, Math, Greedy, Heap (Priority Queue)
**Acceptance Rate:** 46.6%
**Access:** Premium
**URL:** https://leetcode.com/problems/minimum-time-to-build-blocks/

---

_Problem description unavailable (Premium required)._

**Hints:**
1. A greedy approach will not work as the examples show.
2. Try all possible moves using DP.
3. For the DP state, dp[i][j] is the minimum time cost to build the first i blocks using j workers.
4. In one step you can either assign a worker to a block or choose a number of workers to split.
5. If you choose to assign a worker to a block it is always better to assign him to the block with the maximum time so we sort the array before using DP.
6. To optimize the solution from O(n^3) to O(n^2) notice that if you choose to split, it is always better to split all the workers you have.

---

## Solution

```python

```
