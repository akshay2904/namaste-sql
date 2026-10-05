-- ======================================================================
-- Top Accuracy Model
-- ======================================================================
-- Difficulty : Medium
-- Company    : Sears
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_accuracy_model
-- ======================================================================

/*
Which model(s) in the ML registry have the highest accuracy? Show the model name and accuracy; if several models tie for the highest, include all of them.

Table: ml_models(model_id, mdl_name, version, accuracy, status, train_at, framework)

Sample data - ml_models ['model_id', 'mdl_name', 'version', 'accuracy', 'status', 'train_at', 'framework']:
  [123, 'rec_engine', 'v1.1', 0.72, 'training', '2026-02-02 01:00:00', 'TensorFlow']
  [146, 'churn_pred', 'v2.0', 0.89, 'archived', '2026-03-03 02:00:00', 'XGBoost']
  [169, 'spam_filter', '3.0', 0.61, 'failed', '2026-04-04 03:00:00', 'sklearn']
  [192, 'img_classify', 'v2.1-beta', 0.78, 'validating', '2026-05-05 04:00:00', 'pytorch']
  [215, 'sentiment', '1.0.0', 0.95, 'Deployed', '2026-06-06 05:00:00', 'tensorflow']

Expected output ['mdl_name', 'accuracy']:
  ['churn_pred', 0.99]
  ['sentiment', 0.99]
*/


-- Write your SQL solution below:

SELECT DISTINCT mdl_name, accuracy FROM ml_models WHERE accuracy = (SELECT MAX(accuracy) FROM ml_models) ORDER BY mdl_name
