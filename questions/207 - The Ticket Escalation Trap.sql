-- ======================================================================
-- 207 - The Ticket Escalation Trap
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Linkedin
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/207-the-ticket-escalation-trap
-- ======================================================================

/*
You work at a SaaS customer support company. Support tickets are raised by customers and assigned to agents. Tickets can be escalated from one agent to another when the current agent cannot resolve them. Each escalation is logged with a timestamp.

The support manager wants to identify tickets that are stuck in an “Escalation Trap” — tickets that have been escalated 3 or more times and are still unresolved, along with insights about which agents are escalating the most and how long tickets are spending at each level.

---

Table: tickets
*One row per support ticket.*
+------------------+-----------+
| COLUMN_NAME      | DATA_TYPE |
+------------------+-----------+
| ticket_id        | INT       |
| customer_id      | INT       |
| created_at       | DATETIME  |
| status           | VARCHAR   |
| priority         | VARCHAR   |
+------------------+-----------+
Table: escalations
*One row per escalation event for a ticket.*
+------------------+-----------+
| COLUMN_NAME      | DATA_TYPE |
+------------------+-----------+
| escalation_id    | INT       |
| ticket_id        | INT       |
| from_agent_id    | INT       |
| to_agent_id      | INT       |
| escalated_at     | DATETIME  |
+------------------+-----------+
---

The Ask

Find all tickets in an **Escalation Trap** and return one row per ticket:

- `ticket_id`
- `customer_id`
- `priority`
- `escalation_count` — total number of escalations for this ticket
- `total_hours_open` — hours since ticket was created until now (use `2024-06-01 00:00:00` as current time)
- `avg_hours_per_escalation` — average hours spent at each escalation level
- `most_frequent_escalator` — `from_agent_id` who escalated this ticket the most. If two or more agents escalated equally many times, pick the one with
 the lowest agent_id
- `current_agent_id` — the `to_agent_id` of the most recent escalation (currently holding the ticket)

Constraints & Traps:

> - Only include tickets with `status = 'open'`
> - Only include tickets escalated **3 or more times**
> - If two agents escalated equally, pick the one with the **lower agent ID**
> - `avg_hours_per_escalation` = `total_hours_open / escalation_count`, rounded to 2 decimal places
> - A ticket can be escalated to the **same agent multiple times**
*/


-- Write your SQL solution below:

```sql
SELECT
    t.ticket_id,
    t.customer_id,
    t.priority,
    COUNT(e.escalation_id) AS escalation_count,
    ROUND(CAST(EXTRACT(EPOCH FROM (TIMESTAMP '2024-06-01 00:00:00' - t.created_at)) / 3600 AS NUMERIC), 2) AS total_hours_open,
    ROUND(CAST(EXTRACT(EPOCH FROM (TIMESTAMP '2024-06-01 00:00:00' - t.created_at)) / 3600 AS NUMERIC) / COUNT(e.escalation_id), 2) AS avg_hours_per_escalation,
    (
        SELECT e2.from_agent_id
        FROM escalations e2
        WHERE e2.ticket_id = t.ticket_id
        GROUP BY e2.from_agent_id
        ORDER BY COUNT(*) DESC, e2.from_agent_id ASC
        LIMIT 1
    ) AS most_frequent_escalator,
    (
        SELECT e3.to_agent_id
        FROM escalations e3
        WHERE e3.ticket_id = t.ticket_id
        ORDER BY e3.escalated_at DESC
        LIMIT 1
    ) AS current_agent_id
FROM tickets t
INNER JOIN escalations e ON t.ticket_id = e.ticket_id
WHERE t.status = 'open'
GROUP BY t.ticket_id, t.customer_id, t.priority, t.created_at
HAVING COUNT(e.escalation_id) >= 3
ORDER BY t.ticket_id;
```
