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

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH current_time_ref AS (
    SELECT CAST('2024-06-01 00:00:00' AS TIMESTAMP) AS ref_time
),
-- Aggregate escalation stats per ticket in one pass
escalation_stats AS (
    SELECT
        ticket_id,
        COUNT(*)                                              AS escalation_count,
        -- Most recent escalation: to_agent_id of highest escalated_at
        FIRST_VALUE(to_agent_id) OVER (
            PARTITION BY ticket_id
            ORDER BY escalated_at DESC
        )                                                     AS current_agent_id
    FROM escalations
    GROUP BY ticket_id
),
-- Separate CTE to get current_agent_id via window function
escalation_ordered AS (
    SELECT
        ticket_id,
        to_agent_id,
        ROW_NUMBER() OVER (
            PARTITION BY ticket_id
            ORDER BY escalated_at DESC
        ) AS rn
    FROM escalations
),
-- Count how many times each from_agent escalated each ticket
agent_escalation_counts AS (
    SELECT
        ticket_id,
        from_agent_id,
        COUNT(*) AS agent_esc_count,
        -- Rank agents: most escalations first, tie-break by lowest agent_id
        ROW_NUMBER() OVER (
            PARTITION BY ticket_id
            ORDER BY COUNT(*) DESC, from_agent_id ASC
        ) AS agent_rank
    FROM escalations
    GROUP BY ticket_id, from_agent_id
),
ticket_escalation_summary AS (
    SELECT
        ticket_id,
        COUNT(*)   AS escalation_count
    FROM escalations
    GROUP BY ticket_id
    HAVING COUNT(*) >= 3
)
SELECT
    t.ticket_id,
    t.customer_id,
    t.priority,
    tes.escalation_count,
    ROUND(
        EXTRACT(EPOCH FROM (ctr.ref_time - t.created_at)) / 3600.0,
        2
    )                                                             AS total_hours_open,
    ROUND(
        (EXTRACT(EPOCH FROM (ctr.ref_time - t.created_at)) / 3600.0)
        / tes.escalation_count,
        2
    )                                                             AS avg_hours_per_escalation,
    aec.from_agent_id                                             AS most_frequent_escalator,
    eo.to_agent_id                                                AS current_agent_id
FROM tickets t
CROSS JOIN current_time_ref ctr
-- Only tickets with 3+ escalations
JOIN ticket_escalation_summary tes
    ON t.ticket_id = tes.ticket_id
-- Most frequent escalator (tie-break: lowest agent_id)
JOIN agent_escalation_counts aec
    ON t.ticket_id = aec.ticket_id
    AND aec.agent_rank = 1
-- Current holder: to_agent_id of most recent escalation
JOIN escalation_ordered eo
    ON t.ticket_id = eo.ticket_id
    AND eo.rn = 1
WHERE t.status = 'open'
ORDER BY tes.escalation_count DESC, t.ticket_id;


-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    t.ticket_id,
    t.customer_id,
    t.priority,
    -- Total escalation count
    (
        SELECT COUNT(*)
        FROM escalations e
        WHERE e.ticket_id = t.ticket_id
    )                                                             AS escalation_count,
    -- Total hours open
    ROUND(
        EXTRACT(EPOCH FROM (
            CAST('2024-06-01 00:00:00' AS TIMESTAMP) - t.created_at
        )) / 3600.0,
        2
    )                                                             AS total_hours_open,
    -- avg_hours_per_escalation = total_hours_open / escalation_count
    ROUND(
        (EXTRACT(EPOCH FROM (
            CAST('2024-06-01 00:00:00' AS TIMESTAMP) - t.created_at
        )) / 3600.0)
        /
        (
            SELECT COUNT(*)
            FROM escalations e
            WHERE e.ticket_id = t.ticket_id
        ),
        2
    )                                                             AS avg_hours_per_escalation,
    -- Most frequent escalator: agent with most escalations, tie-break lowest id
    (
        SELECT from_agent_id
        FROM escalations e2
        WHERE e2.ticket_id = t.ticket_id
        GROUP BY from_agent_id
        ORDER BY COUNT(*) DESC, from_agent_id ASC
        LIMIT 1
    )                                                             AS most_frequent_escalator,
    -- Current agent: to_agent_id of the most recent escalation
    (
        SELECT to_agent_id
        FROM escalations e3
        WHERE e3.ticket_id = t.ticket_id
        ORDER BY escalated_at DESC
        LIMIT 1
    )                                                             AS current_agent_id
FROM tickets t
WHERE
    t.status = 'open'
    -- Only tickets with 3 or more escalations
    AND (
        SELECT COUNT(*)
        FROM escalations e
        WHERE e.ticket_id = t.ticket_id
    ) >= 3
ORDER BY
    (
        SELECT COUNT(*)
        FROM escalations e
        WHERE e.ticket_id = t.ticket_id
    ) DESC,
    t.ticket_id;
