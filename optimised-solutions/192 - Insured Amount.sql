-- ======================================================================
-- 192 - Insured Amount
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Hackerrank
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/192-insured-amount-61975d65
-- ======================================================================

/*
An insurance company analyzes the risk for an individual applicant/user before issuing the policy. Depending on the risk the insured amount for the user is different. You are provided with the user id, type of insurance and the risk for a user. Calculate the amount insured for every user based on the insurance type and risk.

 

Monthly premiums paid by users are:

$100 for Term Life and Whole Life
$400 for Health
$500 for Endowment
 

Calculate the amount insured for user by following criteria:

Term Life and Whole Life - 10%, 8.5% and 7% of the total amount collected in a year for Low, Medium and High risk users respectively
Health - 2%, 1.5% and 1% of the total amount collected in a year for Low, Medium and High risk users respectively
Endowment - 15%, 12% and 10% of the total amount collected in a year for Low, Medium and High risk users respectively
 

Note: Round off the insured values to an integer value and order the result by user id.
Table : users
+---------------+----------+
| COLUMN_NAME   | DATA_TYPE|
+---------------+----------+
| user_id       | VARCHAR  |
| insurance_type| VARCHAR  |
| risk          | VARCHAR  |
+---------------+----------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH premium_calc AS (
    SELECT
        user_id,
        insurance_type,
        risk,
        -- Annual premium = monthly premium * 12
        CASE insurance_type
            WHEN 'Term Life'   THEN 100 * 12
            WHEN 'Whole Life'  THEN 100 * 12
            WHEN 'Health'      THEN 400 * 12
            WHEN 'Endowment'   THEN 500 * 12
        END AS annual_premium
    FROM users
),
insured_calc AS (
    SELECT
        user_id,
        insurance_type,
        risk,
        annual_premium,
        -- Apply risk-based percentage to annual premium
        CASE
            WHEN insurance_type IN ('Term Life', 'Whole Life') THEN
                CASE risk
                    WHEN 'Low'    THEN annual_premium * 0.10
                    WHEN 'Medium' THEN annual_premium * 0.085
                    WHEN 'High'   THEN annual_premium * 0.07
                END
            WHEN insurance_type = 'Health' THEN
                CASE risk
                    WHEN 'Low'    THEN annual_premium * 0.02
                    WHEN 'Medium' THEN annual_premium * 0.015
                    WHEN 'High'   THEN annual_premium * 0.01
                END
            WHEN insurance_type = 'Endowment' THEN
                CASE risk
                    WHEN 'Low'    THEN annual_premium * 0.15
                    WHEN 'Medium' THEN annual_premium * 0.12
                    WHEN 'High'   THEN annual_premium * 0.10
                END
        END AS insured_amount
    FROM premium_calc
)
SELECT
    user_id,
    insurance_type,
    risk,
    ROUND(insured_amount) AS insured_amount
FROM insured_calc
ORDER BY user_id;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    user_id,
    insurance_type,
    risk,
    ROUND(
        CASE
            -- Term Life: monthly $100, annual $1200
            WHEN insurance_type = 'Term Life' AND risk = 'Low'    THEN (100 * 12) * 0.10
            WHEN insurance_type = 'Term Life' AND risk = 'Medium' THEN (100 * 12) * 0.085
            WHEN insurance_type = 'Term Life' AND risk = 'High'   THEN (100 * 12) * 0.07
            -- Whole Life: monthly $100, annual $1200
            WHEN insurance_type = 'Whole Life' AND risk = 'Low'    THEN (100 * 12) * 0.10
            WHEN insurance_type = 'Whole Life' AND risk = 'Medium' THEN (100 * 12) * 0.085
            WHEN insurance_type = 'Whole Life' AND risk = 'High'   THEN (100 * 12) * 0.07
            -- Health: monthly $400, annual $4800
            WHEN insurance_type = 'Health' AND risk = 'Low'    THEN (400 * 12) * 0.02
            WHEN insurance_type = 'Health' AND risk = 'Medium' THEN (400 * 12) * 0.015
            WHEN insurance_type = 'Health' AND risk = 'High'   THEN (400 * 12) * 0.01
            -- Endowment: monthly $500, annual $6000
            WHEN insurance_type = 'Endowment' AND risk = 'Low'    THEN (500 * 12) * 0.15
            WHEN insurance_type = 'Endowment' AND risk = 'Medium' THEN (500 * 12) * 0.12
            WHEN insurance_type = 'Endowment' AND risk = 'High'   THEN (500 * 12) * 0.10
        END
    ) AS insured_amount
FROM users
ORDER BY user_id;
