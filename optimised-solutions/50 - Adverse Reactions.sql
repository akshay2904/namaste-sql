-- ======================================================================
-- 50 - Adverse Reactions
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Deloitte
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/50-adverse-reactions
-- ======================================================================

/*
In the field of pharmacovigilance, it's crucial to monitor and assess adverse reactions that patients may experience after taking certain medications. Adverse reactions, also known as side effects, can range from mild to severe and can impact the safety and efficacy of a medication.

For each medication, count the number of adverse reactions reported within the first 30 days of the prescription being issued. Assume that the prescription date in the Prescriptions table represents the start date of the medication usage, display the output in ascending order of medication name.

 
Table: patients
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| patient_id  | int         |
| name        | varchar(20) |
| age         | int         |
| gender      | varchar(10) |
+-------------+-------------+Table: medications
+-----------------+-------------+
| COLUMN_NAME     | DATA_TYPE   |
+-----------------+-------------+
| manufacturer    | varchar(20) |
| medication_id   | int         |
| medication_name | varchar(20) |
+-----------------+-------------+Table: prescriptions
+-------------------+-----------+
| COLUMN_NAME       | DATA_TYPE |
+-------------------+-----------+
| prescription_id   | int       |
| patient_id        | int       |
| medication_id     | int       |
| prescription_date | date      |
+-------------------+-----------+Table: adverse_reactions
+----------------------+-------------+
| COLUMN_NAME          | DATA_TYPE   |
+----------------------+-------------+
| patient_id           | int         |
| reaction_date        | date        |
| reaction_description | varchar(20) |
| reaction_id          | int         |
+----------------------+-------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH prescription_reactions AS (
    SELECT
        m.medication_name,
        COUNT(ar.reaction_id) AS adverse_reaction_count
    FROM prescriptions p
    JOIN medications m ON p.medication_id = m.medication_id
    LEFT JOIN adverse_reactions ar
        ON p.patient_id = ar.patient_id
        -- Reaction must occur within first 30 days of prescription
        AND ar.reaction_date BETWEEN p.prescription_date AND p.prescription_date + INTERVAL '30 days'
    GROUP BY m.medication_name
)
SELECT
    medication_name,
    adverse_reaction_count
FROM prescription_reactions
ORDER BY medication_name ASC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    m.medication_name,
    COUNT(ar.reaction_id) AS adverse_reaction_count
FROM prescriptions p
JOIN medications m
    ON p.medication_id = m.medication_id
LEFT JOIN adverse_reactions ar
    ON ar.patient_id = p.patient_id
    -- Reaction date must fall within 30 days from prescription start date
    AND ar.reaction_date >= p.prescription_date
    AND ar.reaction_date <= p.prescription_date + 30
GROUP BY m.medication_name
ORDER BY m.medication_name ASC;
