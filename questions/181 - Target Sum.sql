-- ======================================================================
-- 181 - Target Sum
-- ======================================================================
-- Difficulty : Easy
-- Category   : Python Coding
-- Companies  : Flipkart
-- Access     : Free
-- URL        : https://www.namastesql.com/coding-problems/181-target-sum
-- ======================================================================

/*
Given an integer array arr[] and another integer target.
Determine if there exist two distinct indices such that the sum of their elements equals the target.

Return True if such a pair exists, otherwise False.

Example 1
arr = [0, -1, 2, -3, 1], target = -2
Output: True
Explanation: arr[3] + arr[4] = -3 + 1 = -2
Example 2
arr = [1, -2, 1, 0, 5], target = 0
Output: False
Explanation: None of the pairs add up to 0.
Example 3
arr = [11], target = 11
Output: False
Explanation: Only one element present — no pair possible.
Constraints
1 ≤ arr.size ≤ 10^5
-10^5 ≤ arr[i] ≤ 10^5
-2 × 10^5 ≤ target ≤ 2 × 10^5
*/


-- Write your SQL solution below:
