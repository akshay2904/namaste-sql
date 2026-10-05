# 3733. Minimum Time to Complete All Deliveries

**Difficulty:** Medium
**Tags:** Math, Binary Search
**Acceptance Rate:** 35.3%
**Access:** Free
**URL:** https://leetcode.com/problems/minimum-time-to-complete-all-deliveries/

---

You are given two integer arrays of size 2: `d = [d1, d2]` and `r = [r1, r2]`.

Two delivery drones are tasked with completing a specific number of deliveries. Drone `i` must complete `di` deliveries.

Each delivery takes **exactly** one hour and **only one** drone can make a delivery at any given hour.

Additionally, both drones require recharging at specific intervals during which they cannot make deliveries. Drone `i` must recharge every `ri` hours (i.e. at hours that are multiples of `ri`).

Return an integer denoting the **minimum** total time (in hours) required to complete all deliveries.

 

**Example 1:**

**Input:** d = [3,1], r = [2,3]

**Output:** 5

**Explanation:**

	
The first drone delivers at hours 1, 3, 5 (recharges at hours 2, 4).

	
The second drone delivers at hour 2 (recharges at hour 3).

**Example 2:**

**Input:** d = [1,3], r = [2,2]

**Output:** 7

**Explanation:**

	
The first drone delivers at hour 3 (recharges at hours 2, 4, 6).

	
The second drone delivers at hours 1, 5, 7 (recharges at hours 2, 4, 6).

**Example 3:**

**Input:** d = [2,1], r = [3,4]

**Output:** 3

**Explanation:**

	
The first drone delivers at hours 1, 2 (recharges at hour 3).

	
The second drone delivers at hour 3.

 

**Constraints:**

	
`d = [d1, d2]`

	
`1 <= di <= 109`

	
`r = [r1, r2]`

	
`2 <= ri <= 3 * 104`

**Hints:**
1. Use binary search on the total time `T`.
2. At hours divisible by `lcm(r1, r2)`, both drones are recharging (unavailable).
3. For a fixed `T`, recharge counts are `floor(T / r1)` and `floor(T / r2)`.
4. Available hours: `c1 = T - floor(T / r1)`, `c2 = T - floor(T / r2)`; shared hours = `T - floor(T / r1) - floor(T / r2) + floor(T / lcm(r1,r2))`.
5. Assign each drone its exclusive/available hours first; remaining deliveries must fit into the `shared` hours.

---

## Solution

```python

```
