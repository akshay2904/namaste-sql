# 2832. Maximal Range That Each Element Is Maximum in It

**Difficulty:** Medium
**Tags:** Array, Stack, Monotonic Stack
**Acceptance Rate:** 75.4%
**Access:** Premium
**URL:** https://leetcode.com/problems/maximal-range-that-each-element-is-maximum-in-it/

---

_Problem description unavailable (Premium required)._

**Hints:**
1. For each index, we must find the nearest bigger element on both its left and right sides.
2. First, find the nearest bigger element on the left side of each element. To do that, use a stack of pairs `(value, index)`.
3. Start iterating from the beginning of the array.
4. Whenever we reach an element `nums[index]`, while the top of the stack is smaller than `nums[index]`, we pop from the stack.
5. If there is an element left in the stack, `top.index + 1` would be the answer. Otherwise, `0` is the answer.
6. After that, we push `(nums[index], index)` to the stack and go for the next element.

---

## Solution

```python

```
