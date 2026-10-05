# 2714. Find Shortest Path with K Hops

**Difficulty:** Hard
**Tags:** Graph Theory, Heap (Priority Queue), Shortest Path
**Acceptance Rate:** 68.7%
**Access:** Premium
**URL:** https://leetcode.com/problems/find-shortest-path-with-k-hops/

---

_Problem description unavailable (Premium required)._

**Hints:**
1. Let's construct a new graph and run Dijkstra on it to get the answer to the problem.
2. We define the new graph as follows: Each node of this graph is a pair (v, c) where v is a node from the given graph and c is any number between 0 and k (inclusive).
3. Try to make edges of the defined graph in such a way that if we run Dijkstra on the node (s, 0), then the shortest path to node (d, k) would be the final answer.
4. Edge type one: If the edge (v, u, w) belongs to the initial graph, we put an edge with the weight of w between nodes (v, c) and (u, c) for any c between 0 and k (inclusive) in the new graph.
5. Edge type two: If the edge (v, u, w) belongs to the initial graph, we put an edge with the weight of 0 between nodes (v, c) and (u, c + 1), also between (u, c) and (v, c + 1) for any c between 0 and k - 1 (inclusive) in the new graph.
6. For the matter of time complexity, note that you **don’t need** to literally construct the described graph.

---

## Solution

```python

```
