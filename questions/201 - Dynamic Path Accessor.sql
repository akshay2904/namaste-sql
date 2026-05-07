-- ======================================================================
-- 201 - Dynamic Path Accessor
-- ======================================================================
-- Difficulty : Easy
-- Category   : Python Coding
-- Companies  : Hackerrank
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/201-dynamic-path-accessor
-- ======================================================================

/*
You are given a dictionary dct and a string path representing nested keys separated by dots.
Your task is to write a function named get_dict_value that:

Accepts two parameters:

dct: A dictionary
path: A string representing nested keys separated by dots

Returns:

The value found at the specified path
None if the path is not valid

 

Example 1:

Input:
dct = {"a": {"b": {"c": 42}}}
path = "a.b.c"
Output:
42
Explanation:
The path "a.b.c" navigates through nested dictionaries and returns the value 42.

Example 2:

Input:
dct = {"a": {"b": {"c": 42}}}
path = "a.b.d"
Output:
None
Explanation:
The key "d" does not exist inside "b", so the function returns None.

Example 3:

Input:
dct = {"x": 10}
path = "x"
Output:
10
Explanation:
The key "x" exists at the top level, so the function returns 10.
*/


-- Write your SQL solution below:
