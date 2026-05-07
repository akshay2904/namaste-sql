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

```sql
SELECT 
    orderId as order_id,
    MAX(cityCode) as city_code,
    MIN(CASE WHEN senderDeviceType = 'agent' THEN messageSentTime END) as first_agent_message,
    MIN(CASE WHEN senderDeviceType = 'customer' THEN messageSentTime END) as first_customer_message,
    SUM(CASE WHEN senderDeviceType = 'agent' THEN 1 ELSE 0 END) as num_messages_agent,
    SUM(CASE WHEN senderDeviceType = 'customer' THEN 1 ELSE 0 END) as num_messages_customer,
    CASE 
        WHEN MIN(messageSentTime) = MIN(CASE WHEN senderDeviceType = 'agent' THEN messageSentTime END) THEN 'agent'
        ELSE 'customer'
    END as first_message_by,
    CASE WHEN MAX(CASE WHEN resolution = 'true' THEN 1 ELSE 0 END) = 1 THEN 1 ELSE 0 END as resolved,
    CASE WHEN COUNT(DISTINCT agentId) > 1 THEN 1 ELSE 0 END as reassigned
FROM conversation
GROUP BY orderId
ORDER BY orderId;
```
