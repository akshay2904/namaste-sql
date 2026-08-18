-- ======================================================================
-- 85 - Customer Support Metrics
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Intuit
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/85-customer-support-metrics
-- ======================================================================

/*
You are working for a customer support team at an e-commerce company. The company provides customer support through both web-based chat and mobile app chat. Each conversation between a customer and a support agent is logged in a database table named conversation. The table contains information about the sender (customer or agent), the message content, the order related to the conversation, and other relevant details.
Your task is to analyze the conversation data to extract meaningful insights for improving customer support efficiency. Write an SQL query to fetch the following information from the conversation table for each order_id and sort the output by order_id.

 
order_id: The unique identifier of the order related to the conversation.
city_code: The city code where the conversation took place. This is unique to each order_id.
first_agent_message: The timestamp of the first message sent by a support agent in the conversation.
first_customer_message: The timestamp of the first message sent by a customer in the conversation.
num_messages_agent: The total number of messages sent by the support agent in the conversation.
num_messages_customer: The total number of messages sent by the customer in the conversation.
first_message_by: Indicates whether the first message in the conversation was sent by a support agent or a customer.
resolved(0 or 1): Indicates whether the conversation has a message marked as resolution = true, atleast once.
reassigned(0 or 1): Indicates whether the conversation has had interactions by more than one support agent.

Table: conversation 
+------------------+-------------+
| COLUMN_NAME      | DATA_TYPE   |
+------------------+-------------+
| senderDeviceType | varchar(20) |
| customerId       | int         |
| orderId          | varchar(10) |
| resolution       | varchar(10) |
| agentId          | int         |
| messageSentTime  | datetime    |
| cityCode         | varchar(6) |
+------------------+-------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH base AS (
    SELECT
        orderId,
        cityCode,
        senderDeviceType,
        agentId,
        messageSentTime,
        resolution,
        -- Flag agent messages
        CASE WHEN agentId IS NOT NULL AND customerId IS NULL 
             OR senderDeviceType = 'agent' THEN 1 ELSE 0 END AS is_agent,
        -- Flag customer messages
        CASE WHEN customerId IS NOT NULL AND agentId IS NULL 
             OR senderDeviceType != 'agent' THEN 1 ELSE 0 END AS is_customer
    FROM conversation
),
agg AS (
    SELECT
        orderId                                          AS order_id,
        MAX(cityCode)                                    AS city_code,
        -- First agent message timestamp
        MIN(CASE WHEN agentId IS NOT NULL THEN messageSentTime END) AS first_agent_message,
        -- First customer message timestamp
        MIN(CASE WHEN customerId IS NOT NULL THEN messageSentTime END) AS first_customer_message,
        -- Count of agent messages
        COUNT(CASE WHEN agentId IS NOT NULL THEN 1 END)  AS num_messages_agent,
        -- Count of customer messages
        COUNT(CASE WHEN customerId IS NOT NULL THEN 1 END) AS num_messages_customer,
        -- Overall first message timestamp
        MIN(messageSentTime)                             AS first_msg_time,
        -- Who sent the first message
        MIN(CASE WHEN messageSentTime = (SELECT MIN(c2.messageSentTime) 
                                         FROM conversation c2 
                                         WHERE c2.orderId = base.orderId)
                 THEN CASE WHEN agentId IS NOT NULL THEN 'agent' ELSE 'customer' END 
            END)                                         AS first_message_by_raw,
        -- Resolved: 1 if any message has resolution = 'true'
        MAX(CASE WHEN LOWER(resolution) = 'true' THEN 1 ELSE 0 END) AS resolved,
        -- Reassigned: 1 if more than one distinct agent interacted
        CASE WHEN COUNT(DISTINCT CASE WHEN agentId IS NOT NULL THEN agentId END) > 1 
             THEN 1 ELSE 0 END                           AS reassigned
    FROM base
    GROUP BY orderId
),
first_msg AS (
    -- Determine who sent the very first message per order
    SELECT DISTINCT ON (orderId)
        orderId,
        CASE WHEN agentId IS NOT NULL THEN 'agent' ELSE 'customer' END AS first_message_by
    FROM conversation
    ORDER BY orderId, messageSentTime ASC
)
SELECT
    a.order_id,
    a.city_code,
    a.first_agent_message,
    a.first_customer_message,
    a.num_messages_agent,
    a.num_messages_customer,
    f.first_message_by,
    a.resolved,
    a.reassigned
FROM agg a
JOIN first_msg f ON a.order_id = f.orderId
ORDER BY a.order_id;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    c.orderId                                                        AS order_id,
    MAX(c.cityCode)                                                  AS city_code,
    -- First agent message
    (SELECT MIN(c2.messageSentTime)
     FROM conversation c2
     WHERE c2.orderId = c.orderId
       AND c2.agentId IS NOT NULL)                                   AS first_agent_message,
    -- First customer message
    (SELECT MIN(c3.messageSentTime)
     FROM conversation c3
     WHERE c3.orderId = c.orderId
       AND c3.customerId IS NOT NULL)                                AS first_customer_message,
    -- Number of agent messages
    SUM(CASE WHEN c.agentId IS NOT NULL THEN 1 ELSE 0 END)          AS num_messages_agent,
    -- Number of customer messages
    SUM(CASE WHEN c.customerId IS NOT NULL THEN 1 ELSE 0 END)       AS num_messages_customer,
    -- First message by: check who sent the earliest message
    (SELECT CASE WHEN c4.agentId IS NOT NULL THEN 'agent' ELSE 'customer' END
     FROM conversation c4
     WHERE c4.orderId = c.orderId
     ORDER BY c4.messageSentTime ASC
     LIMIT 1)                                                        AS first_message_by,
    -- Resolved: 1 if any resolution = 'true'
    MAX(CASE WHEN LOWER(c.resolution) = 'true' THEN 1 ELSE 0 END)  AS resolved,
    -- Reassigned: 1 if more than one distinct agent
    CASE WHEN COUNT(DISTINCT CASE WHEN c.agentId IS NOT NULL 
                                  THEN c.agentId END) > 1 
         THEN 1 ELSE 0 END                                          AS reassigned
FROM conversation c
GROUP BY c.orderId
ORDER BY c.orderId;
