-- ======================================================================
-- 171 - Find Leaders in the Array
-- ======================================================================
-- Difficulty : Easy
-- Category   : Python Coding
-- Companies  : Adobe
-- Access     : Free
-- URL        : https://www.namastesql.com/coding-problems/171-find-leaders-in-the-array
-- ======================================================================

/*
You are given an array arr of positive integers.
Your task is to find all the leaders in the array.

An element is considered a leader if it is greater than or equal to all the elements to its right.
The rightmost element is always a leader.

Example 1
Input
[16, 17, 4, 3, 5, 2]

Output
[17, 5, 2]

Explanation:
17, 5, and 2 are leaders because no element on their right is greater than them.
Example 2
Input
[10, 4, 2, 4, 1]

Output
[10, 4, 4, 1]

Explanation:
Both 4s are leaders because equal values on the right are allowed.
Example 3
Input
[5, 10, 20, 40]

Output
[40]

Explanation:
In a strictly increasing array, only the rightmost element is a leader.
Example 4
Input
[30, 10, 10, 5]

Output
[30, 10, 10, 5]

Explanation:
In a non-increasing array, all elements are leaders.
Constraints
1 ≤ arr.size() ≤ 10⁶
0 ≤ arr[i] ≤ 10⁶
*/


-- Write your SQL solution below:
