# 2719. Count of Integers

**Difficulty:** Hard
**Tags:** Math, String, Dynamic Programming
**Acceptance Rate:** 38.5%
**Access:** Free
**URL:** https://leetcode.com/problems/count-of-integers/

---

You are given two numeric strings `num1` and `num2` and two integers `max_sum` and `min_sum`. We denote an integer `x` to be good if:

	
`num1 <= x <= num2`

	
`min_sum <= digit_sum(x) <= max_sum`.

Return the number of good integers. Since the answer may be large, return it modulo `109 + 7`.

Note that `digit_sum(x)` denotes the sum of the digits of `x`.

 

**Example 1:**

**Input:** num1 = "1", num2 = "12", `min_sum` = 1, max_sum = 8
**Output:** 11
**Explanation:** There are 11 integers whose sum of digits lies between 1 and 8 are 1,2,3,4,5,6,7,8,10,11, and 12. Thus, we return 11.

**Example 2:**

**Input:** num1 = "1", num2 = "5", `min_sum` = 1, max_sum = 5
**Output:** 5
**Explanation:** The 5 integers whose sum of digits lies between 1 and 5 are 1,2,3,4, and 5. Thus, we return 5.

 

**Constraints:**

	
`1 <= num1 <= num2 <= 1022`

	
`1 <= min_sum <= max_sum <= 400`

**Hints:**
1. Let f(n, l, r) denotes the number of integers from 1 to n with the sum of digits between l and r.
2. The answer is f(num2, min_sum, max_sum) - f(num1-1, min_sum, max_sum).
3. You can calculate f(n, l, r) using digit dp.

---

## Solution

```python

```
