-- ======================================================================
-- Presence vs. Participation
-- ======================================================================
-- Difficulty : Medium
-- Company    : Meta
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/active_vs_regional_user_count
-- ======================================================================

/*
The platform team is doing a quick capacity check. Compare the number of active user accounts against the number of infrastructure nodes deployed in us-east-1. If active accounts outnumber us-east-1 nodes, return 'More active'; otherwise return 'More us-east-1'.

Table: users(user_id, username, email, signup_date, account_status, age_bucket)

Table: infra_nodes(node_id, hostname, region, node_type, cpu_pct, mem_pct, status)

Sample data - users ['user_id', 'username', 'email', 'signup_date', 'account_status', 'age_bucket']:
  [100, 'alice', 'alice@example.com', '2025-02-02', 'inactive', '25-34']
  [197, 'aaron42', 'aaron42@example.com', '2026-03-03', 'suspended', '35-44']
  [294, 'amelia', 'amelia@example.com', '2024-04-04', 'pending_verification', '45-54']
  [391, 'arjun', 'arjun@example.com', '2025-05-05', 'active', '55-64']
  [488, 'ava99', 'ava99@example.com', '2026-06-06', 'inactive', '65+']

Sample data - infra_nodes ['node_id', 'hostname', 'region', 'node_type', 'cpu_pct', 'mem_pct', 'status']:
  [1037, 'web-02', 'us-west-2', 'memory', 13, 19, 'stopped']
  [1074, 'api-01', 'eu-west-1', 'storage', 26, 38, 'draining']
  [1111, 'api-02', 'ap-south-1', 'gpu', 39, 57, 'offline']
  [1148, 'db-primary', 'eu-central-1', 'general', 52, 76, 'Running']
  [1185, 'db-replica', 'us-east-1', 'compute', 65, 95, 'STOPPED']

Expected output ['result']:
  ['More active']
*/


-- Write your SQL solution below:

SELECT CASE
    WHEN (SELECT COUNT(*) FROM users WHERE account_status = 'active')
       > (SELECT COUNT(*) FROM infra_nodes WHERE region = 'us-east-1')
    THEN 'More active'
    ELSE 'More us-east-1'
END AS result
