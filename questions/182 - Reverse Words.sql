-- ======================================================================
-- 182 - Reverse Words
-- ======================================================================
-- Difficulty : Easy
-- Category   : Python Coding
-- Companies  : Paytm
-- Access     : Free
-- URL        : https://www.namastesql.com/coding-problems/182-reverse-words
-- ======================================================================

/*
Given a string s, reverse the string without reversing its individual words.
Words are separated by dots (.).

Note:
The string may contain leading, trailing, or multiple dots between words.
The returned string should have:

Only a single dot (.) separating words.

No extra leading or trailing dots.

Example 1
s = "i.like.this.program.very.much"
Output: "much.very.program.this.like.i"
Explanation:
Words in the input string are reversed while maintaining the dots as separators
, resulting in "much.very.program.this.like.i".
Example 2
s = "..sql..for.geeks."
Output: "geeks.for.sql"
Explanation:
After removing extra dots and reversing the words,
the input string becomes "geeks.for.sql".
Example 3
s = "..home....."
Output: "home"
Explanation:
The input string contains only one word with extra dots around it.
 After removing the extra dots, the output is "home".
Constraints
1 ≤ s.length() ≤ 10^6
s contains only lowercase English alphabets and dots (.).
*/


-- Write your SQL solution below:
