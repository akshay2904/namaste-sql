-- ======================================================================
-- Best Accuracy to Training Time Ratio
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/best_accuracy_to_training_time_ratio
-- ======================================================================

/*
The ML team is looking for models that punch above their weight: high accuracy relative to how recently they were trained, using the training timestamp's epoch value as the denominator. Which single model has the highest accuracy-to-training-time ratio? Exclude models with no accuracy score and show the model name, accuracy, training timestamp, and the ratio.

Table: ml_models(model_id, mdl_name, version, accuracy, status, train_at, framework)

Sample data - ml_models ['model_id', 'mdl_name', 'version', 'accuracy', 'status', 'train_at', 'framework']:
  [123, 'rec_engine', 'v1.1', 0.72, 'training', '2026-02-02 01:00:00', 'TensorFlow']
  [146, 'churn_pred', 'v2.0', 0.89, 'archived', '2026-03-03 02:00:00', 'XGBoost']
  [169, 'spam_filter', '3.0', 0.61, 'failed', '2026-04-04 03:00:00', 'sklearn']
  [192, 'img_classify', 'v2.1-beta', 0.78, 'validating', '2026-05-05 04:00:00', 'pytorch']
  [215, 'sentiment', '1.0.0', 0.95, 'Deployed', '2026-06-06 05:00:00', 'tensorflow']

Expected output ['mdl_name', 'accuracy', 'train_at', 'ratio']:
  ['sentiment', 0.99, '2023-01-10 13:00:00', 5.916255935080386e-10]
*/


-- Write your SQL solution below:

SELECT mdl_name, accuracy, train_at,
       CAST(accuracy AS REAL) / CAST(strftime('%s', train_at) AS REAL) AS ratio
FROM ml_models
WHERE accuracy IS NOT NULL
ORDER BY ratio DESC
LIMIT 1
