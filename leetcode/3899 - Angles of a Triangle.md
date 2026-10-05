# 3899. Angles of a Triangle

**Difficulty:** Medium
**Tags:** N/A
**Acceptance Rate:** 62.1%
**Access:** Free
**URL:** https://leetcode.com/problems/angles-of-a-triangle/

---

You are given a positive integer array `sides` of length 3.

Determine if there exists a triangle with **positive** area whose three side lengths are given by the elements of `sides`.

If such a triangle exists, return an array of three floating-point numbers representing its internal angles (in **degrees**), **sorted** in **non-decreasing** order. Otherwise, return an empty array.

Answers within `10-5` of the actual answer will be accepted.

 

**Example 1:**

**Input:** sides = [3,4,5]

**Output:** [36.86990,53.13010,90.00000]

**Explanation:**

You can form a right-angled triangle with side lengths 3, 4, and 5. The internal angles of this triangle are approximately 36.869897646, 53.130102354, and 90 degrees respectively.

**Example 2:**

**Input:** sides = [2,4,2]

**Output:** []

**Explanation:**

You cannot form a triangle with positive area using side lengths 2, 4, and 2.

 

**Constraints:**

	
`sides.length == 3`

	
`1 <= sides[i] <= 1000`

**Hints:**
1. Sort the sides first, then check the triangle inequality: after sorting, it is enough to verify `a + b > c`.
2. If valid, use the law of cosines to compute each angle in radians, then convert to degrees.
3. Sort the three angles before returning; if the triangle is invalid, return an empty array.

---

## Solution

```python

```
