# 3787. Find Diameter Endpoints of a Tree

**Difficulty:** Medium
**Tags:** Tree, Breadth-First Search, Graph Theory
**Acceptance Rate:** 68.0%
**Access:** Premium
**URL:** https://leetcode.com/problems/find-diameter-endpoints-of-a-tree/

---

_Problem description unavailable (Premium required)._

**Hints:**
1. Start a breadth first search (BFS) from any node `start`; let the farthest node found be `A`.
2. Run BFS from `A`; a farthest node `B` is at the other end, and the path `A`-`B` is a diameter.
3. If several nodes tie as farthest from `start`, collect them into `cand_start`, each is a possible diameter endpoint.
4. Running BFS from any node in `cand_start` yields the opposite-end set `cand_other`, the other diameter endpoints.

---

## Solution

```python

```
