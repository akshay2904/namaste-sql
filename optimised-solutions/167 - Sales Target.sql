-- ======================================================================
-- 167 - Sales Target
-- ======================================================================
-- Difficulty : Easy
-- Category   : Python Coding
-- Companies  : Tredence
-- Access     : Free
-- URL        : https://www.namastesql.com/coding-problems/167-sales-target
-- ======================================================================

/*
You are given a list of daily sales amounts for a product and a target sales value.
Write a function to find the first day (1-indexed) when the cumulative sales crossed or equaled the given target.

If the sales never reach the target, return -1.

 

Example 1
Input:
sales = [100, 200, 300, 400, 500] target = 700
Output:
3
Explanation:
Day 1: 100
Day 2: 300
Day 3: 600
Day 4: 1000 ✅ (crossed 700)
First day cumulative sales ≥ target → Day 4
✅ Correct Output: 4
Example 2
Input:
sales = [50, 50, 50, 50] target = 200
Output:
4
Explanation:
50 + 50 + 50 + 50 = 200 → target reached on day 4.
Example 3
Input:
sales = [20, 40, 60] target = 200
Output:
-1
Explanation:
Cumulative never reaches target.
Constraints
. 1 <= len(sales) <= 10^5
. 0 <= sales[i] <= 10^4
. 1 <= target <= 10^9
*/


-- Write your SQL solution below:
