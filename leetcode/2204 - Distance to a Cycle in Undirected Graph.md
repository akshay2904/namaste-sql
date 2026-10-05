# 2204. Distance to a Cycle in Undirected Graph

**Difficulty:** Hard
**Tags:** Depth-First Search, Breadth-First Search, Graph Theory, Topological Sort
**Acceptance Rate:** 73.8%
**Access:** Premium
**URL:** https://leetcode.com/problems/distance-to-a-cycle-in-undirected-graph/

---

_Problem description unavailable (Premium required)._

**Hints:**
1. This problem can be broken down into two parts: finding the cycle, and finding the distance between each node and the cycle.
2. How can we find the cycle? We can use DFS and keep track of the nodes we’ve seen, and the order that we see them in. Once we see a node we’ve already visited, we know that the cycle contains the node that was seen twice and all the nodes that we visited in between.
3. Now that we know which nodes are part of the cycle, how can we find the distances? We can run a multi-source BFS starting from the nodes in the cycle and expanding outward.

---

## Solution

```python

```
