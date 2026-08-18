-- ======================================================================
-- Unreviewed Models
-- ======================================================================
-- Difficulty : Easy
-- Company    : N/A
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/unreviewed_models
-- ======================================================================

/*
Return ml_models rows whose mdl_name never appears as tbl_name in dq_checks. Output the mdl_name, version, framework, and status for each such model, sorted by train_at descending.

Table: ml_models(model_id, mdl_name, version, accuracy, status, train_at, framework)

Table: dq_checks(check_id, tbl_name, col_name, rule, passed, fail_pct, run_at, severity)

Sample data - ml_models ['model_id', 'mdl_name', 'version', 'accuracy', 'status', 'train_at', 'framework']:
  [123, 'rec_engine', 'v1.1', 0.72, 'training', '2026-02-02 01:00:00', 'TensorFlow']
  [146, 'churn_pred', 'v2.0', 0.89, 'archived', '2026-03-03 02:00:00', 'XGBoost']
  [169, 'spam_filter', '3.0', 0.61, 'failed', '2026-04-04 03:00:00', 'sklearn']
  [192, 'img_classify', 'v2.1-beta', 0.78, 'validating', '2026-05-05 04:00:00', 'pytorch']
  [215, 'sentiment', '1.0.0', 0.95, 'Deployed', '2026-06-06 05:00:00', 'tensorflow']

Sample data - dq_checks ['check_id', 'tbl_name', 'col_name', 'rule', 'passed', 'fail_pct', 'run_at', 'severity']:
  [131, 'users', 'email', 'unique', 1, None, '2026-02-02 01:00:00', 'high']
  [162, 'products', 'amount', 'range', 1, None, '2026-03-03 02:00:00', 'medium']
  [193, 'transactions', 'status', 'format', 1, None, '2026-04-04 03:00:00', 'low']
  [224, 'events', 'created_at', 'referential', 1, None, '2026-05-05 04:00:00', 'Critical']
  [255, 'sessions', 'price', 'freshness', 0, 15, '2026-06-06 05:00:00', 'HIGH']

Expected output ['mdl_name', 'version', 'framework', 'status']:
  ['spam_filter', '1.0.0', 'tensorflow', 'Deployed']
  ['churn_pred', 'v2.1-beta', 'pytorch', 'validating']
  ['rec_engine', '3.0', 'sklearn', 'failed']
  ['fraud_detect', 'v2.0', 'XGBoost', 'archived']
  ['price_opt', 'v1.1', 'TensorFlow', 'training']
*/


-- Write your SQL solution below:

SELECT mdl_name, version, framework, status
FROM ml_models m
WHERE NOT EXISTS (
    SELECT 1 FROM dq_checks d WHERE d.tbl_name = m.mdl_name
)
ORDER BY train_at DESC;
