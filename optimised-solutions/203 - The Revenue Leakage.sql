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

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH 

-- Generate all months that fall within each contract's active period
contract_months AS (
    SELECT
        c.contract_id,
        c.client_id,
        c.contracted_amount,
        -- Generate one row per month from start_date to end_date
        gs.month_start::DATE AS month_start
    FROM contracts c
    CROSS JOIN LATERAL generate_series(
        DATE_TRUNC('month', c.start_date),
        DATE_TRUNC('month', c.end_date),
        INTERVAL '1 month'
    ) AS gs(month_start)
),

-- Join invoices to contract months; missing invoices = full leakage
monthly_billing AS (
    SELECT
        cm.contract_id,
        cm.client_id,
        cm.contracted_amount,
        cm.month_start,
        -- If no invoice exists for this month, treat invoice_amount as 0
        COALESCE(SUM(i.invoice_amount), 0) AS invoice_amount
    FROM contract_months cm
    LEFT JOIN invoices i
        ON i.contract_id = cm.contract_id
        AND DATE_TRUNC('month', i.invoice_date) = cm.month_start
    GROUP BY
        cm.contract_id,
        cm.client_id,
        cm.contracted_amount,
        cm.month_start
),

-- Flag under-billed months and compute per-month leakage
leakage_flags AS (
    SELECT
        contract_id,
        client_id,
        contracted_amount,
        month_start,
        invoice_amount,
        contracted_amount - invoice_amount AS monthly_leakage,
        -- 1 if under-billed this month, 0 otherwise
        CASE WHEN invoice_amount < contracted_amount THEN 1 ELSE 0 END AS is_under_billed
    FROM monthly_billing
),

-- Assign streak groups using the classic gaps-and-islands technique
-- Subtracting row_number from a running count of under-billed months
-- gives a constant group identifier within each consecutive run
streak_groups AS (
    SELECT
        contract_id,
        client_id,
        contracted_amount,
        month_start,
        monthly_leakage,
        is_under_billed,
        -- Only group under-billed months; non-under-billed months get NULL group
        CASE WHEN is_under_billed = 1 THEN
            -- Row number overall minus row number of under-billed-only rows
            ROW_NUMBER() OVER (PARTITION BY contract_id ORDER BY month_start)
            - ROW_NUMBER() OVER (PARTITION BY contract_id, is_under_billed ORDER BY month_start)
        END AS streak_group
    FROM leakage_flags
),

-- Aggregate each streak to get its length and date range
streak_summary AS (
    SELECT
        contract_id,
        client_id,
        contracted_amount,
        streak_group,
        COUNT(*) AS streak_length,
        MIN(month_start) AS streak_start,
        MAX(month_start) AS streak_end,
        SUM(monthly_leakage) AS streak_leakage
    FROM streak_groups
    WHERE is_under_billed = 1
    GROUP BY contract_id, client_id, contracted_amount, streak_group
),

-- For each contract, pick the longest streak (earliest if tie)
ranked_streaks AS (
    SELECT
        contract_id,
        client_id,
        streak_length,
        streak_start,
        streak_end,
        -- Rank by longest streak, break ties by earliest start
        ROW_NUMBER() OVER (
            PARTITION BY contract_id
            ORDER BY streak_length DESC, streak_start ASC
        ) AS rn
    FROM streak_summary
    WHERE streak_length >= 3   -- only care about streaks of 3+ months
),

-- Total leakage across entire contract (not just the streak)
total_contract_leakage AS (
    SELECT
        contract_id,
        SUM(monthly_leakage) AS total_leakage
    FROM leakage_flags
    GROUP BY contract_id
)

SELECT
    rs.contract_id,
    rs.client_id,
    rs.streak_length          AS consecutive_months,
    tcl.total_leakage,
    rs.streak_start           AS first_leakage_date,
    rs.streak_end             AS last_leakage_date
FROM ranked_streaks rs
JOIN total_contract_leakage tcl
    ON tcl.contract_id = rs.contract_id
WHERE rs.rn = 1
ORDER BY rs.contract_id;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

WITH 

-- Step 1: Build all contract months using generate_series
contract_months AS (
    SELECT
        c.contract_id,
        c.client_id,
        c.contracted_amount,
        gs.month_start::DATE AS month_start
    FROM contracts c
    CROSS JOIN LATERAL generate_series(
        DATE_TRUNC('month', c.start_date),
        DATE_TRUNC('month', c.end_date),
        INTERVAL '1 month'
    ) AS gs(month_start)
),

-- Step 2: Compute actual billed amount per contract per month
monthly_billing AS (
    SELECT
        cm.contract_id,
        cm.client_id,
        cm.contracted_amount,
        cm.month_start,
        COALESCE(
            (SELECT SUM(i.invoice_amount)
             FROM invoices i
             WHERE i.contract_id = cm.contract_id
               AND DATE_TRUNC('month', i.invoice_date) = cm.month_start),
            0
        ) AS invoice_amount
    FROM contract_months cm
),

-- Step 3: Mark each month as under-billed or not
monthly_flags AS (
    SELECT
        contract_id,
        client_id,
        contracted_amount,
        month_start,
        invoice_amount,
        contracted_amount - invoice_amount AS monthly_leakage,
        CASE WHEN invoice_amount < contracted_amount THEN 1 ELSE 0 END AS is_under_billed
    FROM monthly_billing
),

-- Step 4: Assign a streak-group identifier via gaps-and-islands
-- Using a self-join count approach instead of window functions
-- For each under-billed month, count how many under-billed months
-- preceded it within the same contract — then subtract overall month rank
-- (We allow a simple subquery-based row numbering here)
month_ranked AS (
    SELECT
        mf1.contract_id,
        mf1.client_id,
        mf1.contracted_amount,
        mf1.month_start,
        mf1.monthly_leakage,
        mf1.is_under_billed,
        -- Overall ordinal position of this month within the contract
        (SELECT COUNT(*)
         FROM monthly_flags mf2
         WHERE mf2.contract_id = mf1.contract_id
           AND mf2.month_start <= mf1.month_start
        ) AS overall_rank,
        -- Ordinal position among ONLY under-billed months
        CASE WHEN mf1.is_under_billed = 1 THEN
            (SELECT COUNT(*)
             FROM monthly_flags mf3
             WHERE mf3.contract_id = mf1.contract_id
               AND mf3.month_start <= mf1.month_start
               AND mf3.is_under_billed = 1
            )
        END AS under_billed_rank
    FROM monthly_flags mf1
),

-- Step 5: Derive streak group = overall_rank - under_billed_rank (constant per streak)
with_streak_group AS (
    SELECT
        contract_id,
        client_id,
        contracted_amount,
        month_start,
        monthly_leakage,
        is_under_billed,
        -- This difference
