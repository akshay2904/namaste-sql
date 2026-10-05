-- ======================================================================
-- The Apprentices Still in the Forge
-- ======================================================================
-- Difficulty : Easy
-- Company    : Google
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/deprecated_model_count
-- ======================================================================

/*
The ML platform team is sizing a new training GPU cluster and needs to know how much of the model catalog is still mid-flight. A model whose status is 'training' has not yet been validated or deployed and is still consuming training capacity. Count how many distinct model names (mdl_name) currently have a status of 'training'. Status values may arrive in mixed casing, so compare case-insensitively. Return the count as training_count.

Table: ml_models(model_id, mdl_name, version, accuracy, status, train_at, framework)

Sample data - ml_models ['model_id', 'mdl_name', 'version', 'accuracy', 'status', 'train_at', 'framework']:
  [123, 'rec_engine', 'v1.1', 0.72, 'training', '2026-02-02 01:00:00', 'TensorFlow']
  [146, 'churn_pred', 'v2.0', 0.89, 'archived', '2026-03-03 02:00:00', 'XGBoost']
  [169, 'spam_filter', '3.0', 0.61, 'failed', '2026-04-04 03:00:00', 'sklearn']
  [192, 'img_classify', 'v2.1-beta', 0.78, 'validating', '2026-05-05 04:00:00', 'pytorch']
  [215, 'sentiment', '1.0.0', 0.95, 'Deployed', '2026-06-06 05:00:00', 'tensorflow']

Expected output ['training_count']:
  [4]
*/


-- Write your SQL solution below:

SELECT COUNT(DISTINCT mdl_name) AS training_count
FROM ml_models
WHERE LOWER(status) = 'training'
