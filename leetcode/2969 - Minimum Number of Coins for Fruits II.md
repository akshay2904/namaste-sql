# 2969. Minimum Number of Coins for Fruits II

**Difficulty:** Hard
**Tags:** Array, Dynamic Programming, Queue, Heap (Priority Queue), Monotonic Queue
**Acceptance Rate:** 47.5%
**Access:** Premium
**URL:** https://leetcode.com/problems/minimum-number-of-coins-for-fruits-ii/

---

_Problem description unavailable (Premium required)._

**Hints:**
1. Use DP + Fenwick tree.
2. There is another creative solution using multiset instead of Fenwick.
3. Imagine we want to calculate `dp[i]` which is the answer to the problem for the first `i` fruits.
4. If we buy `lth` fruit from the set of indices: `[(i + 1) / 2, (i + 1) / 2 + 1, (i + 1) / 2 + 2, ..., i - 1]`, then we can get fruits `l + 1, l + 2, ..., i` for free.
5. We just need to get all the first `l - 1` fruits as well and the minimum price for that, is `dp[l - 1]`.
6. So at the index `i`, we are looking for such an index `l` that `dp[l - 1] + prices[l]` is as minimum as possible.
7. We can store these values in a multiset and update the values in it.

---

## Solution

```python

```
