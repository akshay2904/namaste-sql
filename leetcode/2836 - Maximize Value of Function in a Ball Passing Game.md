# 2836. Maximize Value of Function in a Ball Passing Game

**Difficulty:** Hard
**Tags:** Array, Dynamic Programming, Bit Manipulation
**Acceptance Rate:** 30.9%
**Access:** Free
**URL:** https://leetcode.com/problems/maximize-value-of-function-in-a-ball-passing-game/

---

You are given an integer array `receiver` of length `n` and an integer `k`. `n` players are playing a ball-passing game.

You choose the starting player, `i`. The game proceeds as follows: player `i` passes the ball to player `receiver[i]`, who then passes it to `receiver[receiver[i]]`, and so on, for `k` passes in total. The game's score is the sum of the indices of the players who touched the ball, including repetitions, i.e. `i + receiver[i] + receiver[receiver[i]] + ... + receiver(k)[i]`.

Return the **maximum** possible score.

**Notes:**

	
`receiver` may contain duplicates.

	
`receiver[i]` may be equal to `i`.

 

**Example 1:**

**Input:** receiver = [2,0,1], k = 4

**Output:** 6

**Explanation:**

Starting with player `i = 2` the initial score is 2:

	
		

			 | Pass
			 | Sender Index
			 | Receiver Index
			 | Score
		

		

			 | 1
			 | 2
			 | 1
			 | 3
		

		

			 | 2
			 | 1
			 | 0
			 | 3
		

		

			 | 3
			 | 0
			 | 2
			 | 5
		

		

			 | 4
			 | 2
			 | 1
			 | 6
		

	

**Example 2:**

**Input:** receiver = [1,1,1,2,3], k = 3

**Output:** 10

**Explanation:**

Starting with player `i = 4` the initial score is 4:

	
		

			 | Pass
			 | Sender Index
			 | Receiver Index
			 | Score
		

		

			 | 1
			 | 4
			 | 3
			 | 7
		

		

			 | 2
			 | 3
			 | 2
			 | 9
		

		

			 | 3
			 | 2
			 | 1
			 | 10
		

	

 

**Constraints:**

	
`1 <= receiver.length == n <= 105`

	
`0 <= receiver[i] <= n - 1`

	
`1 <= k <= 1010`

**Hints:**
1. We can solve the problem using binary lifting.
2. For each player with id `x` and for every `i` in the range `[0, ceil(log2k)]`, we can determine the last receiver's id and compute the sum of player ids who receive the ball after `2i` passes, starting from `x`.
3. Let `last_receiver[x][i] =` the last receiver's id after `2i` passes, and `sum[x][i] =` the sum of player ids who receive the ball after `2i` passes. For all `x` in the range `[0, n - 1]`, `last_receiver[x][0] = receiver[x]`, and `sum[x][0] = receiver[x]`.
4. Then for `i` in range `[1, ceil(log2k)]`, `last_receiver[x][i] = last_receiver[last_receiver[x][i - 1]][i - 1]` and `sum[x][i] = sum[x][i - 1] + sum[last_receiver[x][i - 1]][i - 1]`, for all `x` in the range `[0, n - 1]`.
5. Starting from each player id `x`, we can now go through the powers of `2` in the binary representation of `k` and make jumps corresponding to each power, using the pre-computed values, to compute `f(x)`.
6. The answer is the maximum `f(x)` from each player id.

---

## Solution

```python

```
