-- ======================================================================
-- 22 - The United States of America
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Meta
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/22-the-united-states-of-america
-- ======================================================================

/*
In some poorly designed UI applications, there's often a lack of data input restrictions. For instance, in a free text field for the country, users might input variations such as 'USA,' 'United States of America,' or 'US.'

Suppose we have survey data from individuals in the USA about their job satisfaction, rated on a scale of 1 to 5. Write a SQL query to count the number of respondents for each rating on the scale. Additionally, include the country name in the format that occurs most frequently in that scale, display the output in ascending order of job satisfaction.

 
Table: survey 
+------------------+-------------+
| COLUMN_NAME      | DATA_TYPE   |
+------------------+-------------+
| country          | varchar(20) |
| job_satisfaction | int         |
| name             | varchar(10) |
+------------------+-------------+
*/


-- Write your SQL solution below:

```sql
SELECT 
    s.job_satisfaction,
    COUNT(*) as respondent_count,
    (SELECT s2.country
     FROM survey s2
     WHERE s2.country IN ('USA', 'United States of America', 'US')
     AND s2.job_satisfaction = s.job_satisfaction
     GROUP BY s2.country
     ORDER BY COUNT(*) DESC
     LIMIT 1) as country
FROM survey s
WHERE s.country IN ('USA', 'United States of America', 'US')
GROUP BY s.job_satisfaction
ORDER BY s.job_satisfaction ASC;
```
