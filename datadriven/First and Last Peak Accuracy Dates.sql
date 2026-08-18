-- ======================================================================
-- First and Last Peak Accuracy Dates
-- ======================================================================
-- Difficulty : Medium
-- Company    : Vesta Innovations
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/first_and_last_peak_accuracy_dates
-- ======================================================================

/*
The ML team wants to know when peak model performance was first achieved and whether it has been replicated since. Find the highest accuracy score across all models, then show the earliest and latest training dates where that accuracy was hit.

Table: ml_models(model_id, mdl_name, version, accuracy, status, train_at, framework)

Sample data - ml_models ['model_id', 'mdl_name', 'version', 'accuracy', 'status', 'train_at', 'framework']:
  [123, 'rec_engine', 'v1.1', 0.72, 'training', '2026-02-02 01:00:00', 'TensorFlow']
  [146, 'churn_pred', 'v2.0', 0.89, 'archived', '2026-03-03 02:00:00', 'XGBoost']
  [169, 'spam_filter', '3.0', 0.61, 'failed', '2026-04-04 03:00:00', 'sklearn']
  [192, 'img_classify', 'v2.1-beta', 0.78, 'validating', '2026-05-05 04:00:00', 'pytorch']
  [215, 'sentiment', '1.0.0', 0.95, 'Deployed', '2026-06-06 05:00:00', 'tensorflow']

Expected output ['first_date', 'last_date']:
  ['2023-01-10 13:00:00', '2026-11-27 10:00:00']
*/


-- Write your SQL solution below:

SELECT MIN(train_at) AS first_date, MAX(train_at) AS last_date FROM ml_models WHERE accuracy = (SELECT MAX(accuracy) FROM ml_models)
