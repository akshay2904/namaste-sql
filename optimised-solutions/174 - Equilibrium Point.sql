-- ======================================================================
-- 174 - Equilibrium Point
-- ======================================================================
-- Difficulty : Easy
-- Category   : Python Coding
-- Companies  : Amazon
-- Access     : Free
-- URL        : https://www.namastesql.com/coding-problems/174-equilibrium-point-a8761c2c
-- ======================================================================

/*
You are given an array of integers arr[].
Your task is to find the first equilibrium index in the array.

An equilibrium point is an index (0-based indexing) such that the sum of all elements before it is equal to the sum of all elements after it.
If no such index exists, return -1.

Example 1
Input: arr = [1, 2, 0, 3]
Output: 2
Explanation: Left sum = 1 + 2 = 3, Right sum = 3 → Equal, equilibrium index is 2.
Example 2
Input: arr = [1, 1, 1, 1]
Output: -1
Explanation: No index exists where left and right sums are equal.

Example 3
Input: arr = [-7, 1, 5, 2, -4, 3, 0]
Output: 3
Explanation: Left sum = -7 + 1 + 5 = -1, Right sum = -4 + 3 + 0 = -1 → Equal, equilibrium index is 3. 
Constraints
3 <= arr.size() <= 10^5
-10^4 <= arr[i] <= 10^4
*/


-- Write your SQL solution below:
