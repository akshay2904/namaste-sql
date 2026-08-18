-- ======================================================================
-- 169 - Maximum Reading Score
-- ======================================================================
-- Difficulty : Medium
-- Category   : Python Coding
-- Companies  : Meta
-- Access     : Free
-- URL        : https://www.namastesql.com/coding-problems/169-maximum-reading-score
-- ======================================================================

/*
The library is running a summer reading program where students score points by reading books.

 

Each book belongs to a category and has a point value.
A student can score points from up to 3 books, but each selected book must be from a different category.

 

You are given a list of books that a student read.
Each book is represented as a tuple (category, points).

 

Your task is to calculate the maximum score the student can achieve.

Return the total points from the best selection of up to 3 books from different categories.

 

Example 1

Input:
[("Adventure", 5), ("Adventure", 2), ("History", 3)]
Output:
8
Explanation:
Choose Adventure (5 points) and History (3 points)
Total = 8

Example 2
Input:
[("Adventure", 4), ("History", 3), ("Reference", 1), ("Fiction", 2)]
Output: 9
Explanation:
Pick top 3 categories with highest points:
Adventure + History + Fiction = 4 + 3 + 2 = 9 
Example 3
Input:
[("SciFi", 6), ("Romance", 2), ("SciFi", 4), ("Comics", 5)]
Output: 13
Explanation:
Only pick the highest score book from each category:
SciFi → 6
Romance → 2
Comics → 5
Total = 6 + 2 + 5 = 13
Constraints
. 1 <= number of books <= 1000
. Points are positive integers
. Categories are strings
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

-- Setup: create and populate the books table
-- CREATE TABLE books (category TEXT, points INT);

WITH category_best AS (
    -- Get the highest-scoring book per category using window function
    SELECT DISTINCT
        category,
        FIRST_VALUE(points) OVER (
            PARTITION BY category
            ORDER BY points DESC
        ) AS best_points
    FROM books
),
ranked_categories AS (
    -- Rank categories by their best points, take top 3
    SELECT
        category,
        best_points,
        ROW_NUMBER() OVER (ORDER BY best_points DESC) AS rn
    FROM category_best
)
SELECT COALESCE(SUM(best_points), 0) AS max_score
FROM ranked_categories
WHERE rn <= 3;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT COALESCE(SUM(top_per_category), 0) AS max_score
FROM (
    -- Step 2: take the top 3 category maximums
    SELECT max_points AS top_per_category
    FROM (
        -- Step 1: find the best book score per category
        SELECT category, MAX(points) AS max_points
        FROM books
        GROUP BY category
        ORDER BY max_points DESC
        LIMIT 3
    ) AS top3_categories
) AS final_sum;
