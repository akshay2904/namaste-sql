-- ======================================================================
-- Top Performing Models
-- ======================================================================
-- Difficulty : Easy
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_performing_models
-- ======================================================================

/*
The ML registry tracks model accuracy. Surface all models with accuracy at 0.90 or above. Return all available fields for each qualifying model, sorted from highest accuracy to lowest.

Table: ml_models(model_id, mdl_name, version, accuracy, status, train_at, framework)

Sample data - ml_models ['model_id', 'mdl_name', 'version', 'accuracy', 'status', 'train_at', 'framework']:
  [123, 'rec_engine', 'v1.1', 0.72, 'training', '2026-02-02 01:00:00', 'TensorFlow']
  [146, 'churn_pred', 'v2.0', 0.89, 'archived', '2026-03-03 02:00:00', 'XGBoost']
  [169, 'spam_filter', '3.0', 0.61, 'failed', '2026-04-04 03:00:00', 'sklearn']
  [192, 'img_classify', 'v2.1-beta', 0.78, 'validating', '2026-05-05 04:00:00', 'pytorch']
  [215, 'sentiment', '1.0.0', 0.95, 'Deployed', '2026-06-06 05:00:00', 'tensorflow']

Expected output ['model_id', 'mdl_name', 'version', 'accuracy', 'status', 'train_at', 'framework']:
  [951, 'sentiment', 'v1.1', 0.99, 'training', '2026-02-10 13:00:00', 'TensorFlow']
  [1986, 'churn_pred', 'v2.1-beta', 0.99, 'validating', '2026-11-27 10:00:00', 'pytorch']
  [10002437, 'sentiment', 'v1.1', 0.99, 'training', '2023-01-10 13:00:00', 'TensorFlow']
  [2285, 'price_opt', '1.0.0', 0.95, 'Deployed', '2026-12-12 23:00:00', 'tensorflow']
  [2400, 'img_classify', 'v2.1-beta', 0.9, 'validating', '2026-05-17 04:00:00', 'pytorch']
*/


-- Write your SQL solution below:

SELECT *
FROM ml_models
WHERE accuracy >= 0.90
ORDER BY accuracy DESC, model_id ASC
