-- ======================================================================
-- Stumbling Out of the Gate
-- ======================================================================
-- Difficulty : Medium
-- Company    : DoorDash
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/zero_accuracy_on_first_training
-- ======================================================================

/*
Every model version goes through a series of training runs. We want to know how often a version stumbles right out of the gate. For each model version (a unique combination of mdl_name and version), find its very first training run, ordered by train_at. Of those first runs, what percentage ended with a status of 'failed' (status casing is inconsistent in the data)? Only count runs that actually recorded an accuracy score, since a null accuracy means the run never produced a usable metric and should not be considered a real first run. Return a single percentage.

Table: ml_models(model_id, mdl_name, version, accuracy, status, train_at, framework)

Sample data - ml_models ['model_id', 'mdl_name', 'version', 'accuracy', 'status', 'train_at', 'framework']:
  [123, 'rec_engine', 'v1.1', 0.72, 'training', '2026-02-02 01:00:00', 'TensorFlow']
  [146, 'churn_pred', 'v2.0', 0.89, 'archived', '2026-03-03 02:00:00', 'XGBoost']
  [169, 'spam_filter', '3.0', 0.61, 'failed', '2026-04-04 03:00:00', 'sklearn']
  [192, 'img_classify', 'v2.1-beta', 0.78, 'validating', '2026-05-05 04:00:00', 'pytorch']
  [215, 'sentiment', '1.0.0', 0.95, 'Deployed', '2026-06-06 05:00:00', 'tensorflow']

Expected output ['pct_failed_first_run']:
  [19.047619047619047]
*/


-- Write your SQL solution below:

WITH first_runs AS (
    SELECT
        mdl_name,
        version,
        status,
        ROW_NUMBER() OVER (PARTITION BY mdl_name, version ORDER BY train_at) AS rn
    FROM ml_models
    WHERE accuracy IS NOT NULL
)
SELECT
    CAST(SUM(CASE WHEN LOWER(status) = 'failed' THEN 1 ELSE 0 END) AS REAL) * 100.0 / COUNT(*) AS pct_failed_first_run
FROM first_runs
WHERE rn = 1
