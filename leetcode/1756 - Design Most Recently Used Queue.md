# 1756. Design Most Recently Used Queue

**Difficulty:** Medium
**Tags:** Array, Linked List, Divide and Conquer, Design, Simulation, Doubly-Linked List
**Acceptance Rate:** 78.3%
**Access:** Premium
**URL:** https://leetcode.com/problems/design-most-recently-used-queue/

---

_Problem description unavailable (Premium required)._

**Hints:**
1. You can store the data in an array and apply each fetch by moving the ith element to the end of the array (i.e, O(n) per operation).
2. A better way is to use the square root decomposition technique.
3. You can build chunks of size sqrt(n). For each fetch operation, You can search for the chunk which has the ith element and update it (i.e., O(sqrt(n)) per operation), and move this element to an empty chunk at the end.

---

## Solution

```python

```
