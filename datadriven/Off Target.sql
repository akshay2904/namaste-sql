-- ======================================================================
-- Off Target
-- ======================================================================
-- Difficulty : Medium
-- Company    : American Express
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/90th_pctl_model_accuracy_gap
-- ======================================================================

/*
The ML platform team is auditing model quality for the first half of 2026, judging every model against a 0.95 accuracy target. Surface the 10% of models sitting farthest from that target, along with each model's accuracy and how far it lands from 0.95.

Table: ml_models(model_id, mdl_name, version, accuracy, status, train_at, framework)

Sample data - ml_models ['model_id', 'mdl_name', 'version', 'accuracy', 'status', 'train_at', 'framework']:
  [123, 'rec_engine', 'v1.1', 0.72, 'training', '2026-02-02 01:00:00', 'TensorFlow']
  [146, 'churn_pred', 'v2.0', 0.89, 'archived', '2026-03-03 02:00:00', 'XGBoost']
  [169, 'spam_filter', '3.0', 0.61, 'failed', '2026-04-04 03:00:00', 'sklearn']
  [192, 'img_classify', 'v2.1-beta', 0.78, 'validating', '2026-05-05 04:00:00', 'pytorch']
  [215, 'sentiment', '1.0.0', 0.95, 'Deployed', '2026-06-06 05:00:00', 'tensorflow']

Expected output ['mdl_name', 'accuracy', 'accuracy_gap']:
  ['sentiment', 0.6, 0.35]
  ['sentiment', 0.59, 0.36]
  ['sentiment', 0.57, 0.38]
  ['sentiment', 0.56, 0.3899999999999999]
  ['churn_pred', 0.56, 0.3899999999999999]
*/


-- Write your SQL solution below:

SELECT mdl_name, accuracy, CAST(ABS(accuracy - 0.95) AS REAL) AS accuracy_gap
FROM (
  SELECT mdl_name, accuracy, ABS(accuracy - 0.95) AS accuracy_diff,
    NTILE(10) OVER (ORDER BY ABS(accuracy - 0.95)) AS decile
  FROM ml_models
  WHERE train_at BETWEEN '2026-01-01' AND '2026-06-30'
)
WHERE decile = 10
