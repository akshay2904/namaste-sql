-- ======================================================================
-- Two Names, One Campaign
-- ======================================================================
-- Difficulty : Easy
-- Company    : N/A
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/campaign_match_rate
-- ======================================================================

/*
Our advertising team labels campaigns in loud uppercase (ad_impressions.ad_campaign, e.g. FLASH_SALE_48H) while the push-notification team writes lowercase slugs (push_notifs.campaign, e.g. flash_sale), and the two naming systems were never reconciled. Some are plainly the same effort under a different name because they share a theme word: 'flash', 'loyalty', or 'summer'. Pair every ad campaign with the push campaign it secretly matches on one of those theme words.

Table: ad_impressions(impression_id, user_id, ad_campaign, impression_time, clicked, revenue)

Table: push_notifs(notif_id, user_id, title, platform, status, sent_at, opened, campaign)

Sample data - ad_impressions ['impression_id', 'user_id', 'ad_campaign', 'impression_time', 'clicked', 'revenue']:
  [253, 100, 'BRAND_AWARENESS_Q1', '2026-02-02 01:07:00', 0, None]
  [306, 197, 'PRODUCT_LAUNCH_X', '2026-03-03 02:14:00', 0, None]
  [359, 294, 'RETARGETING_CART', '2026-04-04 03:21:00', 0, None]
  [412, 391, 'HOLIDAY_PROMO', '2026-05-05 04:28:00', 0, None]
  [465, 488, 'NEW_USER_ACQU', '2026-06-06 05:35:00', 1, 0.2]

Sample data - push_notifs ['notif_id', 'user_id', 'title', 'platform', 'status', 'sent_at', 'opened', 'campaign']:
  [1053, 100, 'New message from team', 'android', 'pending', '2026-02-02 01:07:00', 0, 'winback_feb']
  [1106, 197, 'Weekly digest ready', 'web', 'failed', '2026-03-03 02:14:00', 0, 'promo_summer']
  [1159, 294, 'Price drop alert', 'iOS', 'bounced', '2026-04-04 03:21:00', 1, 'onboard_v2']
  [1212, 391, 'Security alert', 'Android', 'Delivered', '2026-05-05 04:28:00', 0, None]
  [1265, 488, 'Payment received', 'WEB', 'FAILED', '2026-06-06 05:35:00', None, 'loyalty_2024']

Expected output ['ad_campaign', 'push_campaign']:
  ['FLASH_SALE_48H', 'flash_sale']
  ['LOYALTY_PROGRAM', 'loyalty_2024']
  ['SUMMER_SALE_2024', 'promo_summer']
*/


-- Write your SQL solution below:

SELECT DISTINCT
       ai.ad_campaign,
       pn.campaign AS push_campaign
FROM   ad_impressions ai
JOIN   push_notifs pn
  ON  (LOWER(ai.ad_campaign) LIKE '%flash%'   AND LOWER(pn.campaign) LIKE '%flash%')
   OR (LOWER(ai.ad_campaign) LIKE '%loyalty%' AND LOWER(pn.campaign) LIKE '%loyalty%')
   OR (LOWER(ai.ad_campaign) LIKE '%summer%'  AND LOWER(pn.campaign) LIKE '%summer%')
ORDER BY ai.ad_campaign;
