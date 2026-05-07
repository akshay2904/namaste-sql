-- ======================================================================
-- 183 - Move All Zeros to the End
-- ======================================================================
-- Difficulty : Easy
-- Category   : Python Coding
-- Companies  : Paytm
-- Access     : Free
-- URL        : https://www.namastesql.com/coding-problems/183-move-all-zeros-to-the-end
-- ======================================================================

/*
You are given an array arr[] of non-negative integers.
Your task is to move all the zeros in the array to the right end
while maintaining the relative order of the non-zero elements.

The operation must be performed in place, meaning you should not use extra space for another array.

Example 1
arr = [1, 2, 0, 4, 3, 0, 5, 0]
Output: [1, 2, 4, 3, 5, 0, 0, 0]
Explanation:
There are three 0s that are moved to the end while keeping other elements in order.
Example 2
arr = [10, 20, 30]
Output: [10, 20, 30]
Explanation:
No zeros are present, so the array remains unchanged.
Example 3
arr = [0, 0]
Output: [0, 0]
Explanation:
All elements are zeros, so no change is required.
Constraints
1 ≤ arr.size() ≤ 10^5
0 ≤ arr[i] ≤ 10^5
*/


-- Write your SQL solution below:
