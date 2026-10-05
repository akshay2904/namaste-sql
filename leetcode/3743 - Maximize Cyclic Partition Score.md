# 3743. Maximize Cyclic Partition Score

**Difficulty:** Hard
**Tags:** Array, Dynamic Programming
**Acceptance Rate:** 13.6%
**Access:** Free
**URL:** https://leetcode.com/problems/maximize-cyclic-partition-score/

---

You are given a **cyclic** array `nums` and an integer `k`.

**Partition** `nums` into **at most** `k`** **subarrays. As `nums` is cyclic, these subarrays may wrap around from the end of the array back to the beginning.

The **range** of a subarray is the difference between its **maximum** and **minimum** values. The **score** of a partition is the sum of subarray **ranges**.

Return the **maximum** possible **score** among all cyclic partitions.

 

**Example 1:**

**Input:** nums = [1,2,3,3], k = 2

**Output:** 3

**Explanation:**

	
Partition `nums` into `[2, 3]` and `[3, 1]` (wrapped around).

	
The range of `[2, 3]` is `max(2, 3) - min(2, 3) = 3 - 2 = 1`.

	
The range of `[3, 1]` is `max(3, 1) - min(3, 1) = 3 - 1 = 2`.

	
The score is `1 + 2 = 3`.

**Example 2:**

**Input:** nums = [1,2,3,3], k = 1

**Output:** 2

**Explanation:**

	
Partition `nums` into `[1, 2, 3, 3]`.

	
The range of `[1, 2, 3, 3]` is `max(1, 2, 3, 3) - min(1, 2, 3, 3) = 3 - 1 = 2`.

	
The score is 2.

**Example 3:**

**Input:** nums = [1,2,3,3], k = 4

**Output:** 3

**Explanation:**

Identical to Example 1, we partition `nums` into `[2, 3]` and `[3, 1]`. Note that `nums` may be partitioned into fewer than `k` subarrays.

 

**Constraints:**

	
`1 <= nums.length <= 1000`

	
`1 <= nums[i] <= 109`

	
`1 <= k <= nums.length`

**Hints:**
1. Use dynamic programming on the number of extreme picks: allow up to `2 * k` picks (each partition can supply a + and a -), so the problem becomes choosing which elements are + or -.
2. Model a partition by its max (+`nums[i]`) and min (-`nums[i]`) contributions; selecting an element as a max adds +`nums[i]`, and selecting it as a min adds -`nums[i]`.
3. Use a DP state `(picks, balance)` where `picks` is the total number of + and - chosen so far (<= `2 * k`), and `balance` represents the difference between the counts of + and - currently; at each `i`, you conceptually take +, take -, or skip.
4. Handle cyclicity by limiting `balance` to the range `[0, 2]`. You can show that such a balance is always achievable.

---

## Solution

```python

```
