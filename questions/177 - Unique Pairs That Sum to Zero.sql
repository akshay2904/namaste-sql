-- ======================================================================
-- 177 - Unique Pairs That Sum to Zero
-- ======================================================================
-- Difficulty : Easy
-- Category   : Python Coding
-- Companies  : Flipkart
-- Access     : Free
-- URL        : https://www.namastesql.com/coding-problems/177-unique-pairs-that-sum-to-zero
-- ======================================================================

/*
You are given an integer array arr.
Your task is to find all unique pairs [arr[i], arr[j]] such that:

 i != j

arr[i] + arr[j] == 0

The result should:

1- Contain no duplicate pairs

2- Be sorted in ascending order by both the pair elements and the list of pairs.

 

Example 1
Input: arr = [-1, 0, 1, 2, -1, -4]
Output: [[-1, 1]]
Explanation:
arr[0] + arr[2] = (-1) + 1 = 0  
arr[2] + arr[4] = 1 + (-1) = 0  
The distinct pair is [-1, 1].

Example 2
Input: arr = [6, 1, 8, 0, 4, -9, -1, -10, -6, -5]
Output: [[-6, 6], [-1, 1]]
Explanation:
The distinct pairs that sum to zero are [-1, 1] and [-6, 6].

Constraints
3 <= arr.size() <= 10^5 
-10^5 <= arr[i] <= 10^5
*/


-- Write your SQL solution below:
