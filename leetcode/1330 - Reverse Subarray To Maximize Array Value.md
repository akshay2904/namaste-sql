# 1330. Reverse Subarray To Maximize Array Value

**Difficulty:** Hard
**Tags:** Array, Math, Greedy
**Acceptance Rate:** 43.9%
**Access:** Free
**URL:** https://leetcode.com/problems/reverse-subarray-to-maximize-array-value/

---

You are given an integer array `nums`. The value of this array is defined as the sum of `|nums[i] - nums[i + 1]|` for all `0 <= i < nums.length - 1`.

You are allowed to select any subarray of the given array and reverse it. You can perform this operation **only once**.

Find maximum possible value of the final array.

 

**Example 1:**

**Input:** nums = [2,3,1,5,4]
**Output:** 10
**Explanation: **By reversing the subarray [3,1,5] the array becomes [2,5,1,3,4] whose value is 10.

**Example 2:**

**Input:** nums = [2,4,9,24,2,1,10]
**Output:** 68

 

**Constraints:**

	
`2 <= nums.length <= 3 * 104`

	
`-105 <= nums[i] <= 105`

	
The answer is guaranteed to fit in a 32-bit integer.

**Hints:**
1. What's the score after reversing a sub-array [L, R] ?
2. It's the score without reversing it + abs(a[R] - a[L-1]) + abs(a[L] - a[R+1]) - abs(a[L] - a[L-1]) - abs(a[R] - a[R+1])
3. How to maximize that formula given that abs(x - y) = max(x - y, y - x) ?
4. This can be written as max(max(a[R] - a[L - 1], a[L - 1] - a[R]) + max(a[R + 1] - a[L], a[L] - a[R + 1]) - value(L) - value(R + 1)) over all L < R where value(i) = abs(a[i] - a[i-1])
5. This can be divided into 4 cases.

---

## Solution

```python

```
