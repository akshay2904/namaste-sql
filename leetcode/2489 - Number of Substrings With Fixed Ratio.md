# 2489. Number of Substrings With Fixed Ratio

**Difficulty:** Medium
**Tags:** Hash Table, Math, String, Prefix Sum
**Acceptance Rate:** 57.0%
**Access:** Premium
**URL:** https://leetcode.com/problems/number-of-substrings-with-fixed-ratio/

---

_Problem description unavailable (Premium required)._

**Hints:**
1. Let Func(i) denote the number of 0’s in the prefix [0…i]. We want to find the number of pairs of indices L and R such that Func(R) - Func(L) : R - L - Func(R) + Func(L) = num1 : num2.
2. It is better to simplify the formula.
3. Func(R) * (num1 + num2) - R * num1 = Func(L) * (num1 + num2) - L * num1.
4. Iterate from left to right and use a hash map to count the number of indices having the same value for the above formula.

---

## Solution

```python

```
