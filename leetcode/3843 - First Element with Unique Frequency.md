# 3843. First Element with Unique Frequency

**Difficulty:** Medium
**Tags:** Array, Hash Table, Counting
**Acceptance Rate:** 70.1%
**Access:** Free
**URL:** https://leetcode.com/problems/first-element-with-unique-frequency/

---

You are given an integer array `nums`.

Return an integer denoting the **first** element (scanning from left to right) in `nums` whose **frequency** is **unique**. That is, no other integer appears the same number of times in `nums`. If there is no such element, return -1.

 

**Example 1:**

**Input:** nums = [20,10,30,30]

**Output:** 30

**Explanation:**

	
20 appears once.

	
10 appears once.

	
30 appears twice.

	
The frequency of 30 is unique because no other integer appears exactly twice.

**Example 2:**

**Input:** nums = [20,20,10,30,30,30]

**Output:** 20

**Explanation:**

	
20 appears twice.

	
10 appears once.

	
30 appears 3 times.

	
The frequency of 20, 10, and 30 are unique. The first element that has unique frequency is 20.

**Example 3:**

**Input:** nums = [10,10,20,20]

**Output:** -1

**Explanation:**

	
10 appears twice.

	
20 appears twice.

	
No element has a unique frequency.

 

**Constraints:**

	
`1 <= nums.length <= 105`

	
`1 <= nums[i] <= 105`

**Hints:**
1. Use two hash maps: one `freq` and one `freqCount`
2. First pass: for each `x` in `nums` do `freq[x] += 1`
3. Build counts of frequencies: for each `f` in values of `freq` do `freqCount[f] += 1`
4. Scan `nums` from left to right and return the first `x` with `freqCount[freq[x]] == 1`; return `-1` if none

---

## Solution

```python

```
