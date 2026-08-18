-- ======================================================================
-- Model Training Completion Rate
-- ======================================================================
-- Difficulty : Medium
-- Company    : eBay
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/model_training_completion_rate
-- ======================================================================

/*
For each model in the ML registry, calculate the average accuracy and the completion rate (percentage of training runs where accuracy is not null). Return the model name, average accuracy, and completion rate.

Table: ml_models(model_id, mdl_name, version, accuracy, status, train_at, framework)

Sample data - ml_models ['model_id', 'mdl_name', 'version', 'accuracy', 'status', 'train_at', 'framework']:
  [123, 'rec_engine', 'v1.1', 0.72, 'training', '2026-02-02 01:00:00', 'TensorFlow']
  [146, 'churn_pred', 'v2.0', 0.89, 'archived', '2026-03-03 02:00:00', 'XGBoost']
  [169, 'spam_filter', '3.0', 0.61, 'failed', '2026-04-04 03:00:00', 'sklearn']
  [192, 'img_classify', 'v2.1-beta', 0.78, 'validating', '2026-05-05 04:00:00', 'pytorch']
  [215, 'sentiment', '1.0.0', 0.95, 'Deployed', '2026-06-06 05:00:00', 'tensorflow']

Expected output ['mdl_name', 'avg_accuracy', 'completion_rate']:
  ['churn_pred', 0.8808, 100]
  ['demand_fcst', 0.725, 100]
  ['fraud_detect', None, 0]
  ['img_classify', 0.84, 100]
  ['price_opt', 0.895, 100]
*/


-- Write your SQL solution below:

SELECT mdl_name,
    ROUND(AVG(accuracy), 4) AS avg_accuracy,
    ROUND(COUNT(accuracy) * 100.0 / COUNT(*), 2) AS completion_rate
FROM ml_models
GROUP BY mdl_name
