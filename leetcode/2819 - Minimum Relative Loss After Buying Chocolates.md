# 2819. Minimum Relative Loss After Buying Chocolates

**Difficulty:** Hard
**Tags:** Array, Binary Search, Sorting, Prefix Sum
**Acceptance Rate:** 46.9%
**Access:** Premium
**URL:** https://leetcode.com/problems/minimum-relative-loss-after-buying-chocolates/

---

_Problem description unavailable (Premium required)._

**Hints:**
1. First sort `prices`.
2. For one query, imagine `mi` is `1`. It can be shown that Bob should select either the first one (the cheapest one) or the last one (the most expensive).
3. Now if `mi > 1`, separate the chocolates into two parts. The first part is chocolates having a price less than or equal to `k`, the rest would be in the second part.
4. Knowing how many chocolates Bob should pick from the first part is sufficient. Of course, Bob should select a prefix from this part and a suffix from the second part.
5. To find the number of chocolates from the first part, do a binary search on the first part.

---

## Solution

```python

```
