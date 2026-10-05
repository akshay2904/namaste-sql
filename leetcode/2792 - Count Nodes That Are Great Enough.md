# 2792. Count Nodes That Are Great Enough

**Difficulty:** Hard
**Tags:** Divide and Conquer, Tree, Depth-First Search, Binary Tree
**Acceptance Rate:** 56.6%
**Access:** Premium
**URL:** https://leetcode.com/problems/count-nodes-that-are-great-enough/

---

_Problem description unavailable (Premium required)._

**Hints:**
1. For each node, calculate a list of `k` values representing `k` smallest values in the subtree of that node.
2. To check if a node is great enough, get the described list in the first hint for its children and merge them. Since the resulting list may contain more than `k` elements, pick `k` smallest values and discard the extra ones.
3. Now check if the merged list has exactly `k` elements, and the current node's value is greater than the greatest element in the list, then that node is great enough.

---

## Solution

```python

```
