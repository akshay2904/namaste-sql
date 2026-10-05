-- ======================================================================
-- Duplicate Training Runs
-- ======================================================================
-- Difficulty : Medium
-- Company    : General Assembly
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/duplicate_training_runs
-- ======================================================================

/*
The ML platform's training metadata table has duplicate runs inflating compute budgets. Surface models that were trained more than once on the same calendar day with the same framework, showing the model name, framework, training date, and run count.

Table: ml_models(model_id, mdl_name, version, accuracy, status, train_at, framework)

Sample data - ml_models ['model_id', 'mdl_name', 'version', 'accuracy', 'status', 'train_at', 'framework']:
  [123, 'rec_engine', 'v1.1', 0.72, 'training', '2026-02-02 01:00:00', 'TensorFlow']
  [146, 'churn_pred', 'v2.0', 0.89, 'archived', '2026-03-03 02:00:00', 'XGBoost']
  [169, 'spam_filter', '3.0', 0.61, 'failed', '2026-04-04 03:00:00', 'sklearn']
  [192, 'img_classify', 'v2.1-beta', 0.78, 'validating', '2026-05-05 04:00:00', 'pytorch']
  [215, 'sentiment', '1.0.0', 0.95, 'Deployed', '2026-06-06 05:00:00', 'tensorflow']

Expected output ['mdl_name', 'run_count']:
  ['spam_filter', 26]
  ['rec_engine', 26]
  ['img_classify', 26]
  ['sentiment', 24]
  ['price_opt', 24]
*/


-- Write your SQL solution below:

SELECT mdl_name, COUNT(*) AS run_count
FROM ml_models
GROUP BY mdl_name
HAVING COUNT(*) > 1
ORDER BY run_count DESC
