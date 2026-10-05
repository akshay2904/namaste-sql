# 1579. Remove Max Number of Edges to Keep Graph Fully Traversable

**Difficulty:** Hard
**Tags:** Union-Find, Graph Theory
**Acceptance Rate:** 70.2%
**Access:** Free
**URL:** https://leetcode.com/problems/remove-max-number-of-edges-to-keep-graph-fully-traversable/

---

Alice and Bob have an undirected graph of `n` nodes and three types of edges:

	
Type 1: Can be traversed by Alice only.

	
Type 2: Can be traversed by Bob only.

	
Type 3: Can be traversed by both Alice and Bob.

Given an array `edges` where `edges[i] = [typei, ui, vi]` represents a bidirectional edge of type `typei` between nodes `ui` and `vi`, find the maximum number of edges you can remove so that after removing the edges, the graph can still be fully traversed by both Alice and Bob. The graph is fully traversed by Alice and Bob if starting from any node, they can reach all other nodes.

Return the maximum number of edges you can remove, or return `-1` if Alice and Bob cannot fully traverse the graph.

 

**Example 1:**

****

**Input:** n = 4, edges = [[3,1,2],[3,2,3],[1,1,3],[1,2,4],[1,1,2],[2,3,4]]
**Output:** 2
**Explanation: **If we remove the 2 edges [1,1,2] and [1,1,3]. The graph will still be fully traversable by Alice and Bob. Removing any additional edge will not make it so. So the maximum number of edges we can remove is 2.

**Example 2:**

****

**Input:** n = 4, edges = [[3,1,2],[3,2,3],[1,1,4],[2,1,4]]
**Output:** 0
**Explanation: **Notice that removing any edge will not make the graph fully traversable by Alice and Bob.

**Example 3:**

****

**Input:** n = 4, edges = [[3,2,3],[1,1,2],[2,3,4]]
**Output:** -1
**Explanation: **In the current graph, Alice cannot reach node 4 from the other nodes. Likewise, Bob cannot reach 1. Therefore it's impossible to make the graph fully traversable.

 

 

**Constraints:**

	
`1 <= n <= 105`

	
`1 <= edges.length <= min(105, 3 * n * (n - 1) / 2)`

	
`edges[i].length == 3`

	
`1 <= typei <= 3`

	
`1 <= ui < vi <= n`

	
All tuples `(typei, ui, vi)` are distinct.

**Hints:**
1. Build the network instead of removing extra edges.
2. Suppose you have the final graph (after removing extra edges). Consider the subgraph with only the edges that Alice can traverse. What structure does this subgraph have? How many edges are there?
3. Use disjoint set union data structure for both Alice and Bob.
4. Always use Type 3 edges first, and connect the still isolated ones using other edges.

---

## Solution

```python

```
