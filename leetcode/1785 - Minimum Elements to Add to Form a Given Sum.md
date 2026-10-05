# 1785. Minimum Elements to Add to Form a Given Sum

**Difficulty:** Medium
**Tags:** Array, Greedy
**Acceptance Rate:** 45.1%
**Access:** Free
**URL:** https://leetcode.com/problems/minimum-elements-to-add-to-form-a-given-sum/

---

You are given an integer array `nums` and two integers `limit` and `goal`. The array `nums` has an interesting property that `abs(nums[i]) <= limit`.

Return the minimum number of elements you need to add to make the sum of the array equal to `goal`. The array must maintain its property that `abs(nums[i]) <= limit`.

Note that `abs(x)` equals `x` if `x >= 0`, and `-x` otherwise.

 

**Example 1:**

**Input:** nums = [1,-1,1], limit = 3, goal = -4
**Output:** 2
**Explanation:** You can add -2 and -3, then the sum of the array will be 1 - 1 + 1 - 2 - 3 = -4.

**Example 2:**

**Input:** nums = [1,-10,9,1], limit = 100, goal = 0
**Output:** 1

 

**Constraints:**

	
`1 <= nums.length <= 105`

	
`1 <= limit <= 106`

	
`-limit <= nums[i] <= limit`

	
`-109 <= goal <= 109`

**Hints:**
1. Try thinking about the problem as if the array is empty. Then you only need to form goal using elements whose absolute value is <= limit.
2. You can greedily set all of the elements except one to limit or -limit, so the number of elements you need is ceil(abs(goal)/ limit).
3. You can "normalize" goal by offsetting it by the sum of the array. For example, if the goal is 5 and the sum is -3, then it's exactly the same as if the goal is 8 and the array is empty.
4. The answer is ceil(abs(goal-sum)/limit) = (abs(goal-sum)+limit-1) / limit.

---

## Solution

```python

```
