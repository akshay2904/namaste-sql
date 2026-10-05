# 3795. Minimum Subarray Length With Distinct Sum At Least K

**Difficulty:** Medium
**Tags:** Array, Hash Table, Sliding Window
**Acceptance Rate:** 31.8%
**Access:** Free
**URL:** https://leetcode.com/problems/minimum-subarray-length-with-distinct-sum-at-least-k/

---

You are given an integer array `nums` and an integer `k`.

Return the **minimum** length of a **subarray** whose sum of the **distinct** values present in that subarray (each value counted once) is **at least** `k`. If no such subarray exists, return -1.

 

**Example 1:**

**Input:** nums = [2,2,3,1], k = 4

**Output:** 2

**Explanation:**

The subarray `[2, 3]` has distinct elements `{2, 3}` whose sum is `2 + 3 = 5`, which is ​​​​​​​at least `k = 4`. Thus, the answer is 2.

**Example 2:**

**Input:** nums = [3,2,3,4], k = 5

**Output:** 2

**Explanation:**

The subarray `[3, 2]` has distinct elements `{3, 2}` whose sum is `3 + 2 = 5`, which is ​​​​​​​at least `k = 5`. Thus, the answer is 2.

**Example 3:**

**Input:** nums = [5,5,4], k = 5

**Output:** 1

**Explanation:**

The subarray `[5]` has distinct elements `{5}` whose sum is `5`, which is at least `k = 5`. Thus, the answer is 1.

 

**Constraints:**

	
`1 <= nums.length <= 105`

	
`1 <= nums[i] <= 105`

	
`1 <= k <= 109`

**Hints:**
1. Use a two-pointer sliding window that expands the right end until the window's sum of values that occur exactly once reaches at least `k`.
2. When that happens, greedily advance the left pointer to shrink the window as much as possible while keeping the unique-sum `>= k`, updating the minimum length.
3. Maintain a frequency counter to update the unique-sum when an element's count flips between unique and non-unique

---

## Solution

```python

```
