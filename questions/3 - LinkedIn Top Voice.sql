-- ======================================================================
-- 3 - LinkedIn Top Voice
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Linkedin
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/3-linkedin-top-voice
-- ======================================================================

/*
LinkedIn is a professional social networking app. They want to give top voice badge to their best creators to encourage them to create more quality content. A creator qualifies for the badge if he/she satisfies following criteria.

 

1- Creator should have more than 50k followers.
2- Creator should have more than 100k impressions on the posts that they published in the month of Dec-2023.
3- Creator should have published atleast 3 posts in Dec-2023.

 

Write a SQL to get the list of top voice creators name along with no of posts and impressions by them in the month of Dec-2023.

 
Table: creators(primary key : creator_id)
+--------------+-------------+
| COLUMN_NAME  | DATA_TYPE   |
+--------------+-------------+
| creator_id   | int         |
| creator_name | varchar(20) |
| followers    | int         |
+--------------+-------------+Table: posts(primary key : post_id)
+--------------+------------+
| COLUMN_NAME  | DATA_TYPE  |
+--------------+------------+
| creator_id   | int        |
| post_id      | varchar(3) |
| publish_date | date       |
| impressions  | int        |
+--------------+------------+
*/


-- Write your SQL solution below:

```sql
SELECT 
    c.creator_name,
    COUNT(p.post_id) AS no_of_posts,
    SUM(p.impressions) AS impressions
FROM creators c
INNER JOIN posts p ON c.creator_id = p.creator_id
WHERE 
    c.followers > 50000
    AND YEAR(p.publish_date) = 2023
    AND MONTH(p.publish_date) = 12
GROUP BY c.creator_id, c.creator_name
HAVING 
    COUNT(p.post_id) >= 3
    AND SUM(p.impressions) > 100000
ORDER BY impressions DESC;
```
