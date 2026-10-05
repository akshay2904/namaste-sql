# 1798. Maximum Number of Consecutive Values You Can Make

**Difficulty:** Medium
**Tags:** Array, Greedy, Sorting
**Acceptance Rate:** 64.0%
**Access:** Free
**URL:** https://leetcode.com/problems/maximum-number-of-consecutive-values-you-can-make/

---

You are given an integer array `coins` of length `n` which represents the `n` coins that you own. The value of the `ith` coin is `coins[i]`. You can **make** some value `x` if you can choose some of your `n` coins such that their values sum up to `x`.

Return the maximum number of consecutive integer values that you **can** **make** with your coins **starting** from and **including** `0`.

Note that you may have multiple coins of the same value.

 

**Example 1:**

**Input:** coins = [1,3]
**Output:** 2
**Explanation: **You can make the following values:
- 0: take []
- 1: take [1]
You can make 2 consecutive integer values starting from 0.

**Example 2:**

**Input:** coins = [1,1,1,4]
**Output:** 8
**Explanation: **You can make the following values:
- 0: take []
- 1: take [1]
- 2: take [1,1]
- 3: take [1,1,1]
- 4: take [4]
- 5: take [4,1]
- 6: take [4,1,1]
- 7: take [4,1,1,1]
You can make 8 consecutive integer values starting from 0.

**Example 3:**

**Input:** coins = [1,4,10,3,1]
**Output:** 20

 

**Constraints:**

	
`coins.length == n`

	
`1 <= n <= 4 * 104`

	
`1 <= coins[i] <= 4 * 104`

**Hints:**
1. If you can make the first x values and you have a value v, then you can make all the values ≤ v + x
2. Sort the array of coins. You can always make the value 0 so you can start with x = 0.
3. Process the values starting from the smallest and stop when there is a value that cannot be achieved with the current x.

---

## Solution

```python

```
