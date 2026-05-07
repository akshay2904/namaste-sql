-- ======================================================================
-- 203 - The Revenue Leakage
-- ======================================================================
-- Difficulty : Extreme Hard
-- Category   : Analytics
-- Companies  : Amazon
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/203-the-revenue-leakage
-- ======================================================================

/*
You work at a SaaS company that sells software licenses to enterprise clients. Each client has a contracted price agreed upon at the time of signing. However, the actual invoices raised each month sometimes differ from the contracted price — either due to discounts, billing errors, or unapproved price changes.

The finance team wants to identify revenue leakage — cases where clients are being billed less than their contracted price consistently over time.

---

Table: contracts
One row per client contract with the agreed monthly price.
+-------------------+-----------+
| COLUMN_NAME       | DATA_TYPE |
+-------------------+-----------+
| contract_id       | INT       |
| client_id         | INT       |
| contracted_amount | INT       |
| start_date        | DATE      |
| end_date          | DATE      |
+-------------------+-----------+
Table: invoices
One row per invoice raised against a contract each month.
+-------------------+-----------+
| COLUMN_NAME       | DATA_TYPE |
+-------------------+-----------+
| invoice_id        | INT       |
| contract_id       | INT       |
| invoice_amount    | INT       |
| invoice_date      | DATE      |
+-------------------+-----------+
---
The ask :

Find all contracts where the client was billed less than the contracted amount for 3 or more consecutive months. For each such contract return:

- `contract_id`
- `client_id`
- `consecutive_months` — the maximum streak of consecutive under-billed months
- `total_leakage` — total shortfall (sum of `contracted_amount - invoice_amount`) across the **entire contract**, not just the streak
- `first_leakage_date` — invoice date when the leakage streak first started
- `last_leakage_date` — invoice date when the longest streak ended

 Constraints & Traps:

 > - A month within the contract window where **no invoice was raised** also counts as under-billing (leakage = full `contracted_amount`)
> - A contract can have **multiple leakage streaks** — report only the **longest one**
> - If two streaks are equally long, report the **earliest one**
> - `invoice_amount` can never exceed `contracted_amount` in this dataset
> - Contracts with **zero leakage** should not appear in the result
*/


-- Write your SQL solution below:

```sql
WITH monthly_billing AS (
  -- Generate all months within contract period and match with invoices
  SELECT 
    c.contract_id,
    c.client_id,
    c.contracted_amount,
    DATE_TRUNC('month', GENERATE_SERIES(c.start_date, c.end_date, '1 month'::INTERVAL))::DATE AS month_start,
    COALESCE(i.invoice_amount, 0) AS invoice_amount
  FROM contracts c
  LEFT JOIN invoices i ON c.contract_id = i.contract_id 
    AND DATE_TRUNC('month', i.invoice_date)::DATE = DATE_TRUNC('month', GENERATE_SERIES(c.start_date, c.end_date, '1 month'::INTERVAL))::DATE
),
leakage_by_month AS (
  -- Calculate leakage per month
  SELECT 
    contract_id,
    client_id,
    contracted_amount,
    month_start,
    invoice_amount,
    (contracted_amount - invoice_amount) AS monthly_leakage,
    CASE WHEN contracted_amount > invoice_amount THEN 1 ELSE 0 END AS is_underBilled
  FROM monthly_billing
),
consecutive_groups AS (
  -- Assign group ID to consecutive under-billed months
  SELECT 
    contract_id,
    client_id,
    contracted_amount,
    month_start,
    monthly_leakage,
    is_underBilled,
    ROW_NUMBER() OVER (PARTITION BY contract_id ORDER BY month_start) 
      - ROW_NUMBER() OVER (PARTITION BY contract_id, is_underBilled ORDER BY month_start) AS group_id
  FROM leakage_by_month
),
streak_analysis AS (
  -- Identify consecutive under-billed streaks
  SELECT 
    contract_id,
    client_id,
    contracted_amount,
    group_id,
    is_underBilled,
    COUNT(*) AS streak_length,
    MIN(month_start) AS streak_start,
    MAX(month_start) AS streak_end,
    SUM(monthly_leakage) AS streak_leakage,
    ROW_NUMBER() OVER (PARTITION BY contract_id ORDER BY COUNT(*) DESC, MIN(month_start) ASC) AS streak_rank
  FROM consecutive_groups
  WHERE is_underBilled = 1
  GROUP BY contract_id, client_id, contracted_amount, group_id, is_underBilled
),
longest_streaks AS (
  -- Get the longest streak per contract (earliest if tied)
  SELECT 
    contract_id,
    client_id,
    contracted_amount,
    streak_length AS consecutive_months,
    streak_start,
    streak_end
  FROM streak_analysis
  WHERE streak_rank = 1 AND streak_length >= 3
),
total_contract_leakage AS (
  -- Calculate total leakage across entire contract
  SELECT 
    contract_id,
    SUM(monthly_leakage) AS total_leakage
  FROM leakage_by_month
  WHERE monthly_leakage > 0
  GROUP BY contract_id
)
SELECT 
  ls.contract_id,
  ls.client_id,
  ls.consecutive_months,
  tcl.total_leakage,
  ls.streak_start AS first_leakage_date,
  ls.streak_end AS last_leakage_date
FROM longest_streaks ls
JOIN total_contract_leakage tcl ON ls.contract_id = tcl.contract_id
ORDER BY ls.contract_id;
```
