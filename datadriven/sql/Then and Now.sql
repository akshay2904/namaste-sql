-- ======================================================================
-- Then and Now
-- ======================================================================
-- Difficulty : Hard
-- Company    : Google
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/model_accuracy_drift
-- ======================================================================

/*
We track every model version with the accuracy it scored and the time it was trained, and a version only counts when both of those are recorded. For each model, report its average accuracy across all counted versions, the accuracy of its most recent version, and the gap between that latest accuracy and the average of its earlier versions, everything rounded to two decimals. A model with only one counted version has no earlier versions, so its gap is 0.

Table: ml_models(model_id, mdl_name, version, accuracy, status, train_at, framework)

Sample data - ml_models ['model_id', 'mdl_name', 'version', 'accuracy', 'status', 'train_at', 'framework']:
  [123, 'rec_engine', 'v1.1', 0.72, 'training', '2026-02-02 01:00:00', 'TensorFlow']
  [146, 'churn_pred', 'v2.0', 0.89, 'archived', '2026-03-03 02:00:00', 'XGBoost']
  [169, 'spam_filter', '3.0', 0.61, 'failed', '2026-04-04 03:00:00', 'sklearn']
  [192, 'img_classify', 'v2.1-beta', 0.78, 'validating', '2026-05-05 04:00:00', 'pytorch']
  [215, 'sentiment', '1.0.0', 0.95, 'Deployed', '2026-06-06 05:00:00', 'tensorflow']

Expected output ['model_name', 'avg_lifetime_accuracy', 'latest_accuracy', 'difference']:
  ['churn_pred', 0.9, 0.99, 0.1]
  ['demand_fcst', 0.73, 0.69, -0.04]
  ['img_classify', 0.84, 0.8, -0.04]
  ['rec_engine', 0.78, 0.82, 0.04]
  ['sentiment', 0.74, 0.97, 0.24]
*/


-- Write your SQL solution below:

$1a
