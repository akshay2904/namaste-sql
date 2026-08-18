-- ======================================================================
-- Models With Variable Accuracy
-- ======================================================================
-- Difficulty : Medium
-- Company    : City and County of San Francisco
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/models_with_variable_accuracy
-- ======================================================================

/*
For each model in the ML registry, show the minimum and maximum accuracy, but only include models where the two values differ. Results should appear alphabetically by model name.

Table: ml_models(model_id, mdl_name, version, accuracy, status, train_at, framework)

Sample data - ml_models ['model_id', 'mdl_name', 'version', 'accuracy', 'status', 'train_at', 'framework']:
  [123, 'rec_engine', 'v1.1', 0.72, 'training', '2026-02-02 01:00:00', 'TensorFlow']
  [146, 'churn_pred', 'v2.0', 0.89, 'archived', '2026-03-03 02:00:00', 'XGBoost']
  [169, 'spam_filter', '3.0', 0.61, 'failed', '2026-04-04 03:00:00', 'sklearn']
  [192, 'img_classify', 'v2.1-beta', 0.78, 'validating', '2026-05-05 04:00:00', 'pytorch']
  [215, 'sentiment', '1.0.0', 0.95, 'Deployed', '2026-06-06 05:00:00', 'tensorflow']

Expected output ['mdl_name', 'min_accuracy', 'max_accuracy']:
  ['churn_pred', 0.55, 0.99]
  ['demand_fcst', 0.67, 0.78]
  ['img_classify', 0.78, 0.9]
  ['price_opt', 0.84, 0.95]
  ['rec_engine', 0.72, 0.84]
*/


-- Write your SQL solution below:

SELECT mdl_name, MIN(accuracy) AS min_accuracy, MAX(accuracy) AS max_accuracy
FROM ml_models
GROUP BY mdl_name
HAVING MIN(accuracy) <> MAX(accuracy)
ORDER BY mdl_name
