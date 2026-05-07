-- ======================================================================
-- 69 - Country Indicators
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Deloitte
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/69-country-indicators
-- ======================================================================

/*
In the realm of global indicators and country-level assessments, it's imperative to identify the years in which certain indicators hit their lowest values for each country. Leveraging a dataset provided by government, which contains indicators across multiple years for various countries, your task is to formulate an SQL query to find the following information:
For each country and indicator combination, determine the year in which the indicator value was lowest, along with the corresponding indicator value. Sort the output by country name and indicator name.

 
Table: country_data 
+----------------+--------------+
| COLUMN_NAME    | DATA_TYPE    |
+----------------+--------------+
| country_name   | varchar(15)  |
| indicator_name | varchar(25)  |
| year_2010      | decimal(3,2) |
| year_2011      | decimal(3,2) |
| year_2012      | decimal(3,2) |
| year_2013      | decimal(3,2) |
| year_2014      | decimal(3,2) |
+----------------+--------------+
*/


-- Write your SQL solution below:

```sql
SELECT
  country_name,
  indicator_name,
  CASE
    WHEN year_2010 <= year_2011 AND year_2010 <= year_2012 AND year_2010 <= year_2013 AND year_2010 <= year_2014 THEN 2010
    WHEN year_2011 <= year_2012 AND year_2011 <= year_2013 AND year_2011 <= year_2014 THEN 2011
    WHEN year_2012 <= year_2013 AND year_2012 <= year_2014 THEN 2012
    WHEN year_2013 <= year_2014 THEN 2013
    ELSE 2014
  END AS year,
  LEAST(year_2010, year_2011, year_2012, year_2013, year_2014) AS indicator_value
FROM country_data
ORDER BY country_name, indicator_name;
```
