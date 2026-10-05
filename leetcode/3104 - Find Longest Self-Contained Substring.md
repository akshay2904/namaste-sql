# 3104. Find Longest Self-Contained Substring

**Difficulty:** Hard
**Tags:** Hash Table, String, Sorting
**Acceptance Rate:** 58.8%
**Access:** Premium
**URL:** https://leetcode.com/problems/find-longest-self-contained-substring/

---

_Problem description unavailable (Premium required)._

**Hints:**
1. Fix the start index of the substring.
2. For some fixed index `start`, let's try to find some index `end` such that this substring satisfies the property and also `end` is as maximum as possible.
3. Write some recursive function `shrink(start, end)` that gives a substring. If the substring is valid, then return `end`. Otherwise, it reduces <`end` to reach some valid `end`.
4. For some `shrink(start, end)`, if the substring is not valid, it means there is some character that is both inside and outside of the substring. Now try to reduce `end` such that it does not contain that character anymore.
5. If you implement the `shrink(start, end)` function optimally, you'll achieve `O(n * 26 * 26)` by using partial sum.

---

## Solution

```python

```
