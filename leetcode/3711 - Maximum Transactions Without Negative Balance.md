# 3711. Maximum Transactions Without Negative Balance

**Difficulty:** Medium
**Tags:** Array, Greedy, Heap (Priority Queue)
**Acceptance Rate:** 46.3%
**Access:** Premium
**URL:** https://leetcode.com/problems/maximum-transactions-without-negative-balance/

---

_Problem description unavailable (Premium required)._

**Hints:**
1. Scan the list left to right, keeping a running `balance` and a container `accepted` that tracks the sizes of negative transactions you have taken.
2. Always take nonnegative transactions; they increase `balance` and the total count.
3. If a negative `t` can be paid (`balance + t >= 0`), accept it and record its absolute value in `accepted`.
4. If a negative would make the balance go below zero, but you previously accepted a larger negative, replace that larger one with the current smaller one (restore balance, swap in the smaller): this trade increases the number of transactions you can keep.

---

## Solution

```python

```
