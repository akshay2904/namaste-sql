# 3671. Sum of Beautiful Subsequences

**Difficulty:** Hard
**Tags:** Array, Math, Binary Indexed Tree, Number Theory
**Acceptance Rate:** 31.6%
**Access:** Free
**URL:** https://leetcode.com/problems/sum-of-beautiful-subsequences/

---

You are given an integer array `nums` of length `n`.

For every **positive** integer `g`, we define the **beauty** of `g` as the **product** of `g` and the number of **strictly increasing** **subsequences** of `nums` whose greatest common divisor (GCD) is exactly `g`.

Return the **sum** of **beauty** values for all positive integers `g`.

Since the answer could be very large, return it modulo `109 + 7`.

 

**Example 1:**

**Input:** nums = [1,2,3]

**Output:** 10

**Explanation:**

All strictly increasing subsequences and their GCDs are:

	
		

			 | Subsequence
			 | GCD
		

	
	
		

			 | [1]
			 | 1
		

		

			 | [2]
			 | 2
		

		

			 | [3]
			 | 3
		

		

			 | [1,2]
			 | 1
		

		

			 | [1,3]
			 | 1
		

		

			 | [2,3]
			 | 1
		

		

			 | [1,2,3]
			 | 1
		

	

Calculating beauty for each GCD:

	
		

			 | GCD
			 | Count of subsequences
			 | Beauty (GCD × Count)
		

	
	
		

			 | 1
			 | 5
			 | 1 × 5 = 5
		

		

			 | 2
			 | 1
			 | 2 × 1 = 2
		

		

			 | 3
			 | 1
			 | 3 × 1 = 3
		

	

Total beauty is `5 + 2 + 3 = 10`.

**Example 2:**

**Input:** nums = [4,6]

**Output:** 12

**Explanation:**

All strictly increasing subsequences and their GCDs are:

	
		

			 | Subsequence
			 | GCD
		

	
	
		

			 | [4]
			 | 4
		

		

			 | [6]
			 | 6
		

		

			 | [4,6]
			 | 2
		

	

Calculating beauty for each GCD:

	
		

			 | GCD
			 | Count of subsequences
			 | Beauty (GCD × Count)
		

	
	
		

			 | 2
			 | 1
			 | 2 × 1 = 2
		

		

			 | 4
			 | 1
			 | 4 × 1 = 4
		

		

			 | 6
			 | 1
			 | 6 × 1 = 6
		

	

Total beauty is `2 + 4 + 6 = 12`.

 

**Constraints:**

	
`1 <= n == nums.length <= 104`

	
`1 <= nums[i] <= 7 * 104`

**Hints:**
1. Fix a candidate GCD `g` and keep, in the original order, only those array elements divisible by `g`; scale them down to `x / g` so any increasing subsequence here corresponds to a subsequence whose elements are all multiples of `g`.
2. Count strictly increasing subsequences of that scaled list by assigning ranks (coordinate compression) and maintaining prefix sums of ways for smaller ranks (you may use a Fenwick tree).
3. The count you get, call it `cnt_g`, includes subsequences whose GCD is `g` or any multiple of `g`; it is therefore an overcount for "exactly g".
4. To get the number with GCD exactly `g`, process `g` from `max(nums)` down to `1` and subtract counts already assigned to multiples: `F[g] = cnt_g - sum{k=2g,3g,...}*F[k]` (do arithmetic mod `MOD`); descending order ensures multiples are known.
5. The final answer is the sum of contributions `g * F[g]` for all `g`.

---

## Solution

```python

```
