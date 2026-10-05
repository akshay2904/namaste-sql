# 3004. Maximum Subtree of the Same Color

**Difficulty:** Medium
**Tags:** Array, Dynamic Programming, Tree, Depth-First Search
**Acceptance Rate:** 58.7%
**Access:** Premium
**URL:** https://leetcode.com/problems/maximum-subtree-of-the-same-color/

---

_Problem description unavailable (Premium required)._

**Hints:**
1. For each node, define a `flag[v]` indicating that the subtree of this node contains only one color or not.
2. In the DFS process, when you call `dfs(u)` from node `v`, after that DFS of `u` has finished, check if `flag[u] == false`, then `flag[v]` is also `false`.
3. Also if `color[v] != color[u]`, `flag[v]` becomes `false`.

---

## Solution

```python

```
