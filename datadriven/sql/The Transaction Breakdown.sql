-- ======================================================================
-- The Transaction Breakdown
-- ======================================================================
-- Difficulty : Easy
-- Company    : DoorDash
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/tiered_transaction_summary
-- ======================================================================

/*
Produce a single-row snapshot showing transaction counts at three time horizons: last 30 days, last 180 days, and all-time. One row, three numbers, used to illustrate acceleration trends on the exec dashboard.

Table: transactions(transaction_id, user_id, product_id, quantity, total_amount, transaction_date)

Sample data - transactions ['transaction_id', 'user_id', 'product_id', 'quantity', 'total_amount', 'transaction_date']:
  [1067, 197, 1001, 2, 23.46, '2026-02-02']
  [1134, 294, 1050, 3, 36.93, '2026-03-03']
  [1201, 391, 1099, 4, 50.4, '2026-04-04']
  [1268, 488, 1148, 5, 63.87, '2026-05-05']
  [1335, 585, 1197, 1, 77.34, '2026-06-06']

Expected output ['last_30', 'last_180', 'all_time']:
  [9, 57, 200]
*/


-- Write your SQL solution below:

SELECT
  SUM(CASE WHEN transaction_date >= DATE('2026-12-28', '-30 days')  THEN 1 ELSE 0 END) AS last_30,
  SUM(CASE WHEN transaction_date >= DATE('2026-12-28', '-180 days') THEN 1 ELSE 0 END) AS last_180,
  COUNT(*) AS all_time
FROM transactions;
