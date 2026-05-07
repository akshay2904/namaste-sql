-- ======================================================================
-- 141 - Frequent Flyers
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Agoda
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/141-frequent-flyers
-- ======================================================================

/*
Identify passengers with more than 5 flights from the same airport since last 1 year from current date. Display passenger id, departure airport code and number of flights.

 

Table: passenger_flights
+---------------+----------+
| COLUMN_NAME   | DATA_TYPE|
+---------------+----------+
| Passenger_id  | VARCHAR  |
| Flight_id     | VARCHAR  | 
| Departure_date| date     | 
+---------------+----------+Table: flight_details
+-------------------------+-----------+
| COLUMN_NAME             | DATA_TYPE |
+-------------------------+-----------+
| Flight_id               | VARCHAR   |
| Departure_airport_code  | VARCHAR   |
| Arrival_airport         | DATE      |
+-------------------------+-----------+
*/


-- Write your SQL solution below:

```sql
SELECT 
    pf.Passenger_id,
    fd.Departure_airport_code,
    COUNT(pf.Flight_id) AS num_flights
FROM 
    passenger_flights pf
    INNER JOIN flight_details fd ON pf.Flight_id = fd.Flight_id
WHERE 
    pf.Departure_date >= CURRENT_DATE - INTERVAL '1 year'
GROUP BY 
    pf.Passenger_id,
    fd.Departure_airport_code
HAVING 
    COUNT(pf.Flight_id) > 5
ORDER BY 
    pf.Passenger_id,
    fd.Departure_airport_code;
```
