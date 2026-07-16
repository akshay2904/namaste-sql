SELECT
    COALESCE(s.txn_id, b.txn_id) AS txn_id,
    s.amount                      AS system_amount,
    b.amount                      AS bank_amount,
    b.amount - s.amount           AS variance
FROM system_ledger s
FULL OUTER JOIN bank_ledger b ON s.txn_id = b.txn_id
WHERE s.amount != b.amount
   OR s.txn_id IS NULL
   OR b.txn_id IS NULL
ORDER BY txn_id
