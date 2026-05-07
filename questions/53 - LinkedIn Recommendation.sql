-- ======================================================================
-- 53 - LinkedIn Recommendation
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Linkedin
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/53-linkedin-recommendation
-- ======================================================================

/*
LinkedIn stores information of post likes in below format. Every time a user likes a post there will be an entry made in post likes table.

 
Table : post_likes 
+-------------+-----------+
| COLUMN_NAME | DATA_TYPE |
+-------------+-----------+
| post_id     | int       |
| user_id     | int       |
+-------------+-----------+
LinkedIn also stores the information when someone follows another user in below format.

 
Table : user_follows
+-----------------+-----------+
| COLUMN_NAME     | DATA_TYPE |
+-----------------+-----------+
| follows_user_id | int       |
| user_id         | int       |
+-----------------+-----------+
The marketing team wants to send one recommendation post to each user . Write an SQL to find out that one post id for each user that is liked by the most number of users that they follow. Display user id, post id and no of likes.

Please note that team do not want to recommend a post which is already liked by the user. If for any user,  2 or more posts are liked by equal number of users that they follow then select the smallest post id, display the output in ascending order of user id.
*/


-- Write your SQL solution below:

```sql
SELECT 
    uf.user_id,
    MIN(pl.post_id) as post_id,
    COUNT(DISTINCT pl.user_id) as no_of_likes
FROM user_follows uf
INNER JOIN post_likes pl ON uf.follows_user_id = pl.user_id
WHERE pl.post_id NOT IN (
    SELECT post_id 
    FROM post_likes 
    WHERE user_id = uf.user_id
)
GROUP BY uf.user_id, pl.post_id
HAVING COUNT(DISTINCT pl.user_id) = (
    SELECT MAX(like_count)
    FROM (
        SELECT 
            COUNT(DISTINCT pl2.user_id) as like_count
        FROM user_follows uf2
        INNER JOIN post_likes pl2 ON uf2.follows_user_id = pl2.user_id
        WHERE uf2.user_id = uf.user_id
            AND pl2.post_id NOT IN (
                SELECT post_id 
                FROM post_likes 
                WHERE user_id = uf.user_id
            )
        GROUP BY pl2.post_id
    ) subq
)
ORDER BY uf.user_id ASC;
```
