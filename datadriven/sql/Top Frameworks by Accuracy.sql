-- ======================================================================
-- Top Frameworks by Accuracy
-- ======================================================================
-- Difficulty : Medium
-- Company    : Forbes
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_frameworks_by_accuracy
-- ======================================================================

/*
Surface the top 3 ML frameworks by average accuracy (framework names compared case-insensitively) among production models. Show each framework and its average accuracy, sorted from best to worst.

Table: ml_models(model_id, mdl_name, version, accuracy, status, train_at, framework)

Sample data - ml_models ['model_id', 'mdl_name', 'version', 'accuracy', 'status', 'train_at', 'framework']:
  [123, 'rec_engine', 'v1.1', 0.72, 'training', '2026-02-02 01:00:00', 'TensorFlow']
  [146, 'churn_pred', 'v2.0', 0.89, 'archived', '2026-03-03 02:00:00', 'XGBoost']
  [169, 'spam_filter', '3.0', 0.61, 'failed', '2026-04-04 03:00:00', 'sklearn']
  [192, 'img_classify', 'v2.1-beta', 0.78, 'validating', '2026-05-05 04:00:00', 'pytorch']
  [215, 'sentiment', '1.0.0', 0.95, 'Deployed', '2026-06-06 05:00:00', 'tensorflow']

Expected output ['framework', 'avg_accuracy']:
  ['pytorch', 0.8195999999999999]
  ['xgboost', 0.8138461538461539]
  ['tensorflow', 0.7806060606060606]
*/


-- Write your SQL solution below:

SELECT framework, avg_accuracy FROM (SELECT LOWER(framework) AS framework, AVG(accuracy) AS avg_accuracy, RANK() OVER (ORDER BY AVG(accuracy) DESC) AS rnk FROM ml_models WHERE accuracy IS NOT NULL GROUP BY LOWER(framework)) WHERE rnk <= 3 ORDER BY avg_accuracy DESC
