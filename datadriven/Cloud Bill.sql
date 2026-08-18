-- ======================================================================
-- Cloud Bill
-- ======================================================================
-- Difficulty : Easy
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/cloud_bill
-- ======================================================================

/*
The FinOps team is reviewing cloud spend for the quarterly budget cycle. For each spending category, they need the total dollar amount, the number of line items, and the average cost per line item. Skip any allocations with a missing account ID. Show categories from the most expensive to the least.

Table: cost_allocs(alloc_id, team_name, svc_name, region, amount, period, acct_id, category)

Sample data - cost_allocs ['alloc_id', 'team_name', 'svc_name', 'region', 'amount', 'period', 'acct_id', 'category']:
  [129, 'data-eng', 'S3', 'us-west-2', 83.21, '2026-02', 'acct-101', 'storage']
  [158, 'ml-team', 'RDS', 'eu-west-1', 156.42, '2026-03', 'acct-102', 'network']
  [187, 'frontend', 'Lambda', 'ap-south-1', 229.63, '2026-04', 'acct-103', 'database']
  [216, 'backend', 'BigQuery', 'us-central1', 302.84, '2026-05', 'acct-104', 'ml']
  [245, 'devops', 'CloudFront', 'europe-west1', 376.05, '2026-06', 'acct-105', 'other']

Expected output ['category', 'total_amount', 'line_items', 'avg_cost_per_item']:
  ['database', 264042.29, 32, 8251.3215625]
  ['other', 255764.28, 31, 8250.46064516129]
  ['storage', 254527.27, 32, 7953.9771875]
  ['compute', 251210.53, 28, 8971.804642857143]
  ['network', 246359.82, 28, 8798.565]
*/


-- Write your SQL solution below:

SELECT
    category,
    SUM(amount) AS total_amount,
    COUNT(*) AS line_items,
    AVG(amount) AS avg_cost_per_item
FROM cost_allocs
WHERE acct_id IS NOT NULL
GROUP BY category
ORDER BY total_amount DESC
