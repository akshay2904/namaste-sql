# 2954. Count the Number of Infection Sequences

**Difficulty:** Hard
**Tags:** Array, Math, Combinatorics
**Acceptance Rate:** 37.7%
**Access:** Free
**URL:** https://leetcode.com/problems/count-the-number-of-infection-sequences/

---

You are given an integer `n` and an array `sick` sorted in increasing order, representing positions of infected people in a line of `n` people.

At each step, **one **uninfected person **adjacent** to an infected person gets infected. This process continues until everyone is infected.

An **infection sequence** is the order in which uninfected people become infected, excluding those initially infected.

Return the number of different infection sequences possible, modulo `109+7`.

 

**Example 1:**

**Input:** n = 5, sick = [0,4]

**Output:** 4

**Explanation:**

There is a total of 6 different sequences overall.

	
Valid infection sequences are `[1,2,3]`, `[1,3,2]`, `[3,2,1]` and `[3,1,2]`.

	
`[2,3,1]` and `[2,1,3]` are not valid infection sequences because the person at index 2 cannot be infected at the first step.

**Example 2:**

**Input:** n = 4, sick = [1]

**Output:** 3

**Explanation:**

There is a total of 6 different sequences overall.

	
Valid infection sequences are `[0,2,3]`, `[2,0,3]` and `[2,3,0]`.

	
`[3,2,0]`, `[3,0,2]`, and `[0,3,2]` are not valid infection sequences because the infection starts at the person at index 1, then the order of infection is 2, then 3, and hence 3 cannot be infected earlier than 2.

 

**Constraints:**

	
`2 <= n <= 105`

	
`1 <= sick.length <= n - 1`

	
`0 <= sick[i] <= n - 1`

	
`sick` is sorted in increasing order.

**Hints:**
1. Consider infected children as `0` and non-infected as `1`, then divide the array into segments with the same value.
2. For each segment of non-infected children whose indices are `[i, j]` and indices `(i - 1)` and `(j + 1)`, if they exist, are already infected. Then if `i == 0` or `j == n - 1`, each second there is only one kid that can be infected (which is at the other endpoint).
3. If `i > 0` and `j < n - 1`, we have two choices per second since the children at the two endpoints can both be the infect candidates. So there are `2j - i` orders to infect all children in the segment.
4. Each second we can select a segment and select one endpoint from it.
5. The answer is: 
`S! / (len[1]! * len[2]! * ... * len[m]! * lenstart! * lenend!) * 2k` 
where `len[1], len[2], ..., len[m]` are the lengths of each segment of non-infected children that have an infected child at both endpoints, `lenstart` and `lenend` denote the number of non-infected children with infected child at one endpoint, `S` is the total length of all segments of non-infected children, and `k = (len[1] - 1) + (len[2] - 1) + ... + (len[m] - 1)`.

---

## Solution

```python

```
