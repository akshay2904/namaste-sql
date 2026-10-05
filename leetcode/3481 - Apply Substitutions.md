# 3481. Apply Substitutions

**Difficulty:** Medium
**Tags:** Array, Hash Table, String, Depth-First Search, Breadth-First Search, Graph Theory, Topological Sort
**Acceptance Rate:** 77.4%
**Access:** Premium
**URL:** https://leetcode.com/problems/apply-substitutions/

---

_Problem description unavailable (Premium required)._

**Hints:**
1. Build a dependency graph where each key is a node, and add an edge from key `X` to key `Y` if the replacement value for `Y` contains the placeholder `%X%`. Then perform a topological sort to determine a valid order for substitution.
2. Process the keys in the topologically sorted order by replacing placeholders in each replacement value with its fully expanded value. Finally, substitute the placeholders in the text using these computed values.

---

## Solution

```python

```
