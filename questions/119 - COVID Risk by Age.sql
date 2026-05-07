-- ======================================================================
-- 119 - COVID Risk by Age
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Amazon
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/119-covid-risk-by-age
-- ======================================================================

/*
You have a table named covid_tests with the following columns: name, id, age, and corad score. The corad score values are categorized as follows:

-1 indicates a negative result.
Scores from 2 to 5 indicate a mild condition.
Scores from 6 to 10 indicate a serious condition.

 

Write a query to produce an output with the following columns:

age_group: Groups of ages (18-30, 31-45, 46-60).
count_negative: The number of people with a negative result in each age group.
count_mild: The number of people with a mild condition in each age group.
count_serious: The number of people with a serious condition in each age group.

 
Table: covid_tests
+---------------+-------------+
| COLUMN_NAME   | DATA_TYPE   |
+---------------+-------------+
| name          | varchar(10) |
| id            | int         |
| age           | int         |
| corad_score   | int         |
+---------------+-------------+
*/


-- Write your SQL solution below:

```sql
SELECT
  CASE
    WHEN age BETWEEN 18 AND 30 THEN '18-30'
    WHEN age BETWEEN 31 AND 45 THEN '31-45'
    WHEN age BETWEEN 46 AND 60 THEN '46-60'
  END AS age_group,
  SUM(CASE WHEN corad_score = -1 THEN 1 ELSE 0 END) AS count_negative,
  SUM(CASE WHEN corad_score BETWEEN 2 AND 5 THEN 1 ELSE 0 END) AS count_mild,
  SUM(CASE WHEN corad_score BETWEEN 6 AND 10 THEN 1 ELSE 0 END) AS count_serious
FROM covid_tests
WHERE age BETWEEN 18 AND 60
GROUP BY
  CASE
    WHEN age BETWEEN 18 AND 30 THEN '18-30'
    WHEN age BETWEEN 31 AND 45 THEN '31-45'
    WHEN age BETWEEN 46 AND 60 THEN '46-60'
  END
ORDER BY age_group;
```
