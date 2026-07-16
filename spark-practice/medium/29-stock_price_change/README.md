# 29. Stock Price Daily Change

**Difficulty:** medium  
**Tags:** window functions, lag  
**Source:** https://spark.vutrinh.net/problems/stock_price_change

## Problem

Given a table `stock_prices` with columns `price_date`, `stock`, and `close_price`, compute the **daily price change** for each stock. The price change is `close_price - previous_day_close_price`.

For the first trading day of each stock, `price_change` should be `NULL`.

Return columns: `stock`, `price_date`, `close_price`, `price_change`

Order by `stock` ascending, then `price_date` ascending.

## Schema

**`stock_prices`**

| column | type |
|---|---|
| price_date | STRING |
| stock | STRING |
| close_price | DOUBLE |

## Sample Input

**`stock_prices`**

| price_date | stock | close_price |
|---|---|---|
| 2024-01-01 | AAPL | 185.20 |
| 2024-01-02 | AAPL | 186.50 |
| 2024-01-03 | AAPL | 184.80 |
| 2024-01-04 | AAPL | 188.00 |
| 2024-01-05 | AAPL | 190.30 |

## Hints

<details><summary>Hint 1</summary>

To compare a value with the value from the previous row, use a **window function**. The `LAG()` function returns a value from a preceding row within a defined window (partition + ordering).

</details>

<details><summary>Hint 2</summary>

Partition by `stock` so each stock's rows are treated independently, and order by `price_date` so rows are in chronological sequence. `LAG(close_price, 1)` gives the previous day's price, and subtracting gives the change. The first row per partition returns `NULL` for LAG.

</details>

<details><summary>Hint 3</summary>

```sql
SELECT stock, price_date, close_price,
       close_price - LAG(close_price) OVER (PARTITION BY stock ORDER BY price_date) AS price_change
FROM stock_prices
ORDER BY stock, price_date
```

</details>

## Solutions

### SQL

```sql
SELECT stock,
       price_date,
       close_price,
       close_price - LAG(close_price) OVER (PARTITION BY stock ORDER BY price_date) AS price_change
FROM stock_prices
ORDER BY stock, price_date
```

**Why it works:**
- `PARTITION BY stock` keeps each stock's rows in its own window
- `ORDER BY price_date` ensures the lag looks at the chronologically previous row
- `LAG(close_price)` fetches the previous row's close price (defaults to NULL for the first row)
- Subtracting gives the daily change; NULL subtraction yields NULL for the first day

### DataFrame API

```python
# F (pyspark.sql.functions) and Window are pre-imported

w = Window.partitionBy("stock").orderBy("price_date")

result = (
    df
    .withColumn("price_change", F.col("close_price") - F.lag("close_price", 1).over(w))
    .select("stock", "price_date", "close_price", "price_change")
    .orderBy("stock", "price_date")
)
```

**Why it works:**
- `Window.partitionBy("stock").orderBy("price_date")` defines the window spec
- `F.lag("close_price", 1).over(w)` retrieves the previous row's close price within each stock's window
- Subtracting yields the daily change; the first row per stock gets NULL
