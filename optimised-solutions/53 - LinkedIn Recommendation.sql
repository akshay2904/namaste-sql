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

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH follow_post_likes AS (
    -- For each user, find posts liked by people they follow (excluding posts they already liked)
    SELECT
        uf.user_id,
        pl.post_id,
        COUNT(pl.user_id) AS follow_likes_count
    FROM user_follows uf
    JOIN post_likes pl
        ON pl.user_id = uf.follows_user_id
    -- Exclude posts already liked by the user themselves
    WHERE NOT EXISTS (
        SELECT 1
        FROM post_likes pl2
        WHERE pl2.user_id = uf.user_id
          AND pl2.post_id = pl.post_id
    )
    GROUP BY uf.user_id, pl.post_id
),
ranked AS (
    SELECT
        user_id,
        post_id,
        follow_likes_count,
        -- Rank by most likes desc, then smallest post_id asc on tie
        ROW_NUMBER() OVER (
            PARTITION BY user_id
            ORDER BY follow_likes_count DESC, post_id ASC
        ) AS rn
    FROM follow_post_likes
)
SELECT
    user_id,
    post_id,
    follow_likes_count AS no_of_likes
FROM ranked
WHERE rn = 1
ORDER BY user_id ASC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

-- Step 1: Aggregate likes per user-post combination from followed users
-- Step 2: For each user pick the post with max likes (min post_id on tie)

SELECT
    fpl.user_id,
    fpl.post_id,
    fpl.follow_likes_count AS no_of_likes
FROM (
    -- Count how many followed users liked each post, per user
    SELECT
        uf.user_id,
        pl.post_id,
        COUNT(pl.user_id) AS follow_likes_count
    FROM user_follows uf
    JOIN post_likes pl
        ON pl.user_id = uf.follows_user_id
    -- Exclude posts the user has already liked
    WHERE pl.post_id NOT IN (
        SELECT pl2.post_id
        FROM post_likes pl2
        WHERE pl2.user_id = uf.user_id
    )
    GROUP BY uf.user_id, pl.post_id
) fpl
WHERE fpl.follow_likes_count = (
    -- Find the maximum like count for this user across all candidate posts
    SELECT MAX(fpl2.follow_likes_count)
    FROM (
        SELECT
            uf2.user_id,
            pl2.post_id,
            COUNT(pl2.user_id) AS follow_likes_count
        FROM user_follows uf2
        JOIN post_likes pl2
            ON pl2.user_id = uf2.follows_user_id
        WHERE pl2.post_id NOT IN (
            SELECT pl3.post_id
            FROM post_likes pl3
            WHERE pl3.user_id = uf2.user_id
        )
        GROUP BY uf2.user_id, pl2.post_id
    ) fpl2
    WHERE fpl2.user_id = fpl.user_id
)
-- On tie, pick the smallest post_id
AND fpl.post_id = (
    SELECT MIN(fpl3.post_id)
    FROM (
        SELECT
            uf3.user_id,
            pl3.post_id,
            COUNT(pl3.user_id) AS follow_likes_count
        FROM user_follows uf3
        JOIN post_likes pl3
            ON pl3.user_id = uf3.follows_user_id
        WHERE pl3.post_id NOT IN (
            SELECT pl4.post_id
            FROM post_likes pl4
            WHERE pl4.user_id = uf3.user_id
        )
        GROUP BY uf3.user_id, pl3.post_id
    ) fpl3
    WHERE fpl3.user_id = fpl.user_id
      AND fpl3.follow_likes_count = fpl.follow_likes_count
)
ORDER BY fpl.user_id ASC;
