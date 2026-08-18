-- ======================================================================
-- 175 - Binary Search
-- ======================================================================
-- Difficulty : Easy
-- Category   : Python Coding
-- Companies  : Infosys
-- Access     : Free
-- URL        : https://www.namastesql.com/coding-problems/175-binary-search
-- ======================================================================

/*
You are given a sorted array arr[] and an integer k.
Your task is to find the position (0-based index) at which k is present in the array using binary search.
If k doesn’t exist in arr[], return -1.

Note:
If there are multiple occurrences of k, return the smallest index.

 

Example 1
Input: arr = [1, 2, 3, 4, 5], k = 4
Output: 3
Explanation: 4 appears at index 3. 
Example 2
Input: arr = [11, 22, 33, 44, 55], k = 445
Output: -1
Explanation: 445 is not present in the array.

Example 3
Input: arr = [1, 1, 1, 1, 2], k = 1
Output: 0
Explanation: The first occurrence of 1 is at index 0. 
Constraints
1 ≤ arr.size() ≤ 10^5 
1 ≤ arr[i] ≤ 10^6 
1 ≤ k ≤ 10^6
*/


-- Write your SQL solution below:
