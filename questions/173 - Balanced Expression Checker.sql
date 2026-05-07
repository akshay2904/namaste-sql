-- ======================================================================
-- 173 - Balanced Expression Checker
-- ======================================================================
-- Difficulty : Easy
-- Category   : Python Coding
-- Companies  : Flipkart
-- Access     : Free
-- URL        : https://www.namastesql.com/coding-problems/173-balanced-expression-checker
-- ======================================================================

/*
You are given a string s composed only of the following six characters:
'(' , ')' , '{' , '}' , '[' , ']'.

Your task is to determine whether the given expression is balanced or not.

An expression is considered balanced if:

=> Each opening bracket has a corresponding closing bracket of the same type.

=>Opening brackets are closed in the correct nested order.

Example 1
Input:
s = "[{()}]"
Output:
True
Explanation:
All the brackets are well-formed and correctly nested.
Example 2
Input:
s = "[()()]{}"
Output:
True
Explanation:
All the brackets are properly balanced and ordered.
Example 3
Input:
s = "([]"
Output:
False
Explanation:
Missing closing ')' at the end.
Example 4
Input:
s = "([{]})"
Output:
False
Explanation:
Incorrect order — ']' closes before '}'.
Constraints
1 ≤ len(s) ≤ 10^6
Each character s[i] ∈ {'{', '}', '(', ')', '[', ']'}
*/


-- Write your SQL solution below:
