-- ======================================================================
-- 65 - Service Downtime
-- ======================================================================
-- Difficulty : Extreme Hard
-- Category   : Analytics
-- Companies  : Microsoft
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/65-service-downtime
-- ======================================================================

/*
You are a DevOps engineer responsible for monitoring the health and status of various services in your organization's infrastructure. Your team conducts canary tests on each service every minute to ensure their reliability and performance. As part of your responsibilities, you need to develop a SQL to identify any service that experiences continuous downtime for at least 5 minutes so that team can find the root cause and fix the issue. Display the output in descending order of service down minutes.

 
Table:service_status 
+--------------+-------------+
| COLUMN_NAME  | DATA_TYPE   |
+--------------+-------------+
| service_name | varchar(4) |
| status       | varchar(4)  |
| updated_time | datetime    |
+--------------+-------------+
*/


-- Write your SQL solution below:

```sql
SELECT 
    service_name,
    COUNT(*) AS down_minutes,
    MIN(updated_time) AS downtime_start,
    MAX(updated_time) AS downtime_end
FROM service_status
WHERE status = 'down'
GROUP BY service_name
HAVING COUNT(*) >= 5
ORDER BY down_minutes DESC;
```
