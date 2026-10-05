-- ======================================================================
-- Median Model Accuracy
-- ======================================================================
-- Difficulty : Hard
-- Company    : City and County of San Francisco
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/median_model_accuracy
-- ======================================================================

/*
Compute the median accuracy for each model (mdl_name). When a model has an even number of records, average the two middle values. Ignore records where accuracy is null. Return results ordered alphabetically by model name.

Table: ml_models(model_id, mdl_name, version, accuracy, status, train_at, framework)

Sample data - ml_models ['model_id', 'mdl_name', 'version', 'accuracy', 'status', 'train_at', 'framework']:
  [123, 'rec_engine', 'v1.1', 0.72, 'training', '2026-02-02 01:00:00', 'TensorFlow']
  [146, 'churn_pred', 'v2.0', 0.89, 'archived', '2026-03-03 02:00:00', 'XGBoost']
  [169, 'spam_filter', '3.0', 0.61, 'failed', '2026-04-04 03:00:00', 'sklearn']
  [192, 'img_classify', 'v2.1-beta', 0.78, 'validating', '2026-05-05 04:00:00', 'pytorch']
  [215, 'sentiment', '1.0.0', 0.95, 'Deployed', '2026-06-06 05:00:00', 'tensorflow']

Expected output ['mdl_name', 'median_accuracy']:
  ['churn_pred', 0.93]
  ['demand_fcst', 0.725]
  ['img_classify', 0.84]
  ['price_opt', 0.895]
  ['rec_engine', 0.78]
*/


-- Write your SQL solution below:

WITH numbered AS (
    SELECT mdl_name, accuracy,
        ROW_NUMBER() OVER (PARTITION BY mdl_name ORDER BY accuracy) AS rn,
        COUNT(*) OVER (PARTITION BY mdl_name) AS cnt
    FROM ml_models
    WHERE accuracy IS NOT NULL
)
SELECT mdl_name,
    AVG(accuracy) AS median_accuracy
FROM numbered
WHERE rn IN (cnt / 2, cnt / 2 + 1)
    OR (cnt % 2 = 1 AND rn = (cnt + 1) / 2)
GROUP BY mdl_name
ORDER BY mdl_name
