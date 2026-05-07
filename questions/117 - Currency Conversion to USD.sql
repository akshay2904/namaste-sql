-- ======================================================================
-- 117 - Currency Conversion to USD
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Paytm
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/117-currency-conversion-to-usd
-- ======================================================================

/*
You are given two tables, sales_amount and exchange_rate. The sales_amount table contains sales transactions in various currencies, and the exchange_rate table provides the exchange rates for converting different currencies into USD, along with the dates when these rates became effective.

Your task is to write an SQL query that converts all sales amounts into USD using the most recent applicable exchange rate that was effective on or before the sale date. Then, calculate the total sales in USD for each sale date.

Table: sales_amount  
+-------------+----------+
| COLUMN_NAME | DATA_TYPE|
+-------------+----------+
| sale_date   | int      |    
| sales_amount| int      |
| currency    | varchar  |
+-------------+----------+Table: exchange_rate  
+-----------------+----------+
| COLUMN_NAME     | DATA_TYPE|
+---------------+------------+
| from_currency | varchar    |    
| to_currency   | varchar    |
| exchange_rate | decimal    |
| effective_date| date       |
+-------------+--------------+
*/


-- Write your SQL solution below:

```sql
SELECT 
    sa.sale_date,
    SUM(sa.sales_amount * er.exchange_rate) AS total_sales_usd
FROM 
    sales_amount sa
INNER JOIN (
    -- Get the most recent exchange rate effective on or before each sale date
    SELECT 
        from_currency,
        to_currency,
        exchange_rate,
        effective_date,
        ROW_NUMBER() OVER (PARTITION BY from_currency, to_currency, effective_date ORDER BY effective_date DESC) AS rn
    FROM 
        exchange_rate er1
    WHERE 
        to_currency = 'USD'
        AND er1.effective_date <= CAST(sa.sale_date AS date)
) er ON sa.currency = er.from_currency
    AND er.effective_date = (
        SELECT MAX(er2.effective_date)
        FROM exchange_rate er2
        WHERE er2.from_currency = sa.currency
            AND er2.to_currency = 'USD'
            AND er2.effective_date <= CAST(sa.sale_date AS date)
    )
GROUP BY 
    sa.sale_date
ORDER BY 
    sa.sale_date;
```
