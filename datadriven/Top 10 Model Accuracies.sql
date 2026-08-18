-- ======================================================================
-- Top 10 Model Accuracies
-- ======================================================================
-- Difficulty : Easy
-- Company    : ESPN
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_10_model_accuracies
-- ======================================================================

/*
Surface the 10 highest accuracy values across all models in the ML registry, showing each model's name and accuracy.

Table: ml_models(model_id, mdl_name, version, accuracy, status, train_at, framework)

Sample data - ml_models ['model_id', 'mdl_name', 'version', 'accuracy', 'status', 'train_at', 'framework']:
  [123, 'rec_engine', 'v1.1', 0.72, 'training', '2026-02-02 01:00:00', 'TensorFlow']
  [146, 'churn_pred', 'v2.0', 0.89, 'archived', '2026-03-03 02:00:00', 'XGBoost']
  [169, 'spam_filter', '3.0', 0.61, 'failed', '2026-04-04 03:00:00', 'sklearn']
  [192, 'img_classify', 'v2.1-beta', 0.78, 'validating', '2026-05-05 04:00:00', 'pytorch']
  [215, 'sentiment', '1.0.0', 0.95, 'Deployed', '2026-06-06 05:00:00', 'tensorflow']

Expected output ['model_id', 'mdl_name', 'accuracy']:
  [951, 'sentiment', 0.99]
  [1986, 'churn_pred', 0.99]
  [10002437, 'sentiment', 0.99]
  [10002482, 'churn_pred', 0.99]
  [767, 'sentiment', 0.98]
*/


-- Write your SQL solution below:

SELECT model_id, mdl_name, accuracy
FROM ml_models
ORDER BY accuracy DESC, model_id ASC
LIMIT 10
