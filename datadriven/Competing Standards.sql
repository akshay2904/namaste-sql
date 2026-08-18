-- ======================================================================
-- Competing Standards
-- ======================================================================
-- Difficulty : Hard
-- Company    : Google
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_models_by_framework
-- ======================================================================

/*
For each model (`mdl_name`), find the framework used across the greatest number of its versions, breaking a tie in that count by the higher average accuracy. Sort the resulting model-framework pairs by average accuracy, highest first, and keep every pair whose accuracy places it among the three highest values, including any that share a position.

Table: ml_models(model_id, mdl_name, version, accuracy, status, train_at, framework)

Sample data - ml_models ['model_id', 'mdl_name', 'version', 'accuracy', 'status', 'train_at', 'framework']:
  [123, 'rec_engine', 'v1.1', 0.72, 'training', '2026-02-02 01:00:00', 'TensorFlow']
  [146, 'churn_pred', 'v2.0', 0.89, 'archived', '2026-03-03 02:00:00', 'XGBoost']
  [169, 'spam_filter', '3.0', 0.61, 'failed', '2026-04-04 03:00:00', 'sklearn']
  [192, 'img_classify', 'v2.1-beta', 0.78, 'validating', '2026-05-05 04:00:00', 'pytorch']
  [215, 'sentiment', '1.0.0', 0.95, 'Deployed', '2026-06-06 05:00:00', 'tensorflow']

Expected output ['mdl_name', 'framework', 'avg_acc']:
  ['churn_pred', 'pytorch', 0.9450000000000001]
  ['price_opt', 'tensorflow', 0.905]
  ['img_classify', 'XGBoost', 0.845]
*/


-- Write your SQL solution below:

WITH fw_counts AS (
  SELECT mdl_name, framework,
         COUNT(DISTINCT version) AS ver_count,
         AVG(accuracy) AS avg_acc
  FROM ml_models
  GROUP BY mdl_name, framework
),
primary_fw AS (
  SELECT mdl_name, framework, avg_acc,
         ROW_NUMBER() OVER (
           PARTITION BY mdl_name
           ORDER BY ver_count DESC, avg_acc DESC, framework
         ) AS rn
  FROM fw_counts
),
best AS (
  SELECT mdl_name, framework, avg_acc
  FROM primary_fw
  WHERE rn = 1
),
ranked AS (
  SELECT mdl_name, framework, avg_acc,
         DENSE_RANK() OVER (ORDER BY avg_acc DESC) AS rnk
  FROM best
)
SELECT mdl_name, framework, avg_acc
FROM ranked
WHERE rnk <= 3
ORDER BY avg_acc DESC
