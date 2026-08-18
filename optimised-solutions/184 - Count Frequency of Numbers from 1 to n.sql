-- ======================================================================
-- 184 - Count Frequency of Numbers from 1 to n
-- ======================================================================
-- Difficulty : Easy
-- Category   : Python Coding
-- Companies  : Paytm
-- Access     : Free
-- URL        : https://www.namastesql.com/coding-problems/184-count-frequency-of-numbers-from-1-to-n
-- ======================================================================

/*
You are given an array arr[] containing positive integers.
The elements in the array arr[] range from 1 to n (where n is the size of the array), and some numbers may be repeated or absent.

Your task is to count the frequency of all numbers in the range 1 to n
and return an array of size n such that result[i] represents the frequency of number (i+1) (1-based indexing).

Example 1
arr = [2, 3, 2, 3, 5]
Output: [0, 2, 2, 0, 1]
Explanation:
1 → 0 times, 2 → 2 times, 3 → 2 times, 4 → 0 times, 5 → 1 time.
Example 2
arr = [3, 3, 3, 3]
Output: [0, 0, 4, 0]
Explanation:
1 → 0 times, 2 → 0 times, 3 → 4 times, 4 → 0 times.
Example 3
arr = [1]
Output: [1]
Explanation:
1 → 1 time only.
Constraints
1 ≤ arr.size() ≤ 10^6
1 ≤ arr[i] ≤ arr.size()
*/


-- Write your SQL solution below:
