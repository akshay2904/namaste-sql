-- ======================================================================
-- The Proving Ground
-- ======================================================================
-- Difficulty : Medium
-- Company    : ESPN
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/leading_ml_frameworks_by_accuracy
-- ======================================================================

/*
The ML team is deciding which framework to standardize on for 2026 and wants an accuracy comparison. Show each framework's average accuracy among models trained that year, from highest to lowest.

Table: ml_models(model_id, mdl_name, version, accuracy, status, train_at, framework)

Sample data - ml_models ['model_id', 'mdl_name', 'version', 'accuracy', 'status', 'train_at', 'framework']:
  [123, 'rec_engine', 'v1.1', 0.72, 'training', '2026-02-02 01:00:00', 'TensorFlow']
  [146, 'churn_pred', 'v2.0', 0.89, 'archived', '2026-03-03 02:00:00', 'XGBoost']
  [169, 'spam_filter', '3.0', 0.61, 'failed', '2026-04-04 03:00:00', 'sklearn']
  [192, 'img_classify', 'v2.1-beta', 0.78, 'validating', '2026-05-05 04:00:00', 'pytorch']
  [215, 'sentiment', '1.0.0', 0.95, 'Deployed', '2026-06-06 05:00:00', 'tensorflow']

Expected output ['framework', 'avg_accuracy']:
  ['pytorch', 0.841875]
  ['xgboost', 0.822]
  ['tensorflow', 0.784]
  ['sklearn', 0.742]
*/


-- Write your SQL solution below:

SELECT LOWER(framework) AS framework, AVG(accuracy) AS avg_accuracy
FROM ml_models
WHERE strftime('%Y', train_at) = '2026'
  AND accuracy IS NOT NULL
GROUP BY LOWER(framework)
ORDER BY avg_accuracy DESC, framework ASC
