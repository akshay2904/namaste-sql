-- ======================================================================
-- 164 - Most Selling Product
-- ======================================================================
-- Difficulty : Easy
-- Category   : Python Coding
-- Companies  : Practice question
-- Access     : Free
-- URL        : https://www.namastesql.com/coding-problems/164-most-selling-product
-- ======================================================================

/*
You are given a single string containing names of products sold, separated by spaces.
Write a Python program to find the most frequently sold product and return it along with its frequency.

If multiple products have the same highest frequency, return the one that comes first in alphabetical order.

 

Example 1:
Input:
sales = "Laptop Fridge AC Laptop Fridge Mobile Laptop" 
Output:
('Laptop', 3)
Explanation:
The input string contains 7 product names.
"Laptop" appears 3 times — more than any other product —
so the output is ('Laptop', 3).
Example 2:
Input:
sales = "Fan Fan Cooler Cooler" 
Output:
('Cooler', 2)
Explanation:
Both "Fan" and "Cooler" appear 2 times.
Since there’s a tie, "Cooler" comes before "Fan" alphabetically,
so the output is ('Cooler', 2).
Constraints:
. The input is a single string containing product names separated by spaces.
. 1 <= number of products <= 10^5
. Each product name consists only of alphabetic characters.
*/


-- Write your SQL solution below:
