-- ======================================================================
-- 38 - Product Reviews
-- ======================================================================
-- Difficulty : Easy
-- Category   : Analytics
-- Companies  : Flipkart
-- Access     : Free
-- URL        : https://www.namastesql.com/coding-problems/38-product-reviews
-- ======================================================================

/*
Suppose you are a data analyst working for a retail company, and your team is interested in analysing customer feedback to identify trends and patterns in product reviews.

Your task is to write an SQL query to find all product reviews containing the word "excellent" or "amazing" in the review text. However, you want to exclude reviews that contain the word "not" immediately before "excellent" or "amazing". Please note that the words can be in upper or lower case or combination of both. 

Your query should return the review_id,product_id, and review_text for each review meeting the criteria, display the output in ascending order of review_id.

 
Table: product_reviews
+-------------+--------------+
| COLUMN_NAME | DATA_TYPE    |
+-------------+--------------+
| review_id   | int          |
| product_id  | int          |
| review_text | varchar(40)  |
+-------------+--------------+
*/


-- Write your SQL solution below:
