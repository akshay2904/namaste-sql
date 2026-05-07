-- ======================================================================
-- 165 - First Non-Repeating Character
-- ======================================================================
-- Difficulty : Easy
-- Category   : Python Coding
-- Companies  : Practice question
-- Access     : Free
-- URL        : https://www.namastesql.com/coding-problems/165-first-non-repeating-character
-- ======================================================================

/*
Given a string, find and return the first character that does not repeat anywhere in the string.

If all characters repeat or the string is empty, return None.

The comparison should be case-sensitive -
for example, 'A' and 'a' are considered different characters.

 

Example 1:
Input:
s = "swiss" 
Output:
'w' 
Explanation:
Frequency of characters:
s → 3, w → 1, i → 1
The first character that appears only once is 'w'.
Example 1:
Input:
s = "aabbcc" 
Output:
None 
Explanation:
All characters repeat, so there’s no non-repeating character.
Example 2:
Input:
s = "aAbBABac" 
Output:
'b' 
Explanation:
'a' and 'A' are different (case-sensitive).
Character frequencies: a → 2, A → 2, b → 1, B → 1, c → 1
The first non-repeating character is 'b'.
Constraints
. 0 <= len(s) <= 10^5
. The string may contain lowercase and uppercase English letters.
*/


-- Write your SQL solution below:
