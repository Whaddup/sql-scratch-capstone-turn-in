Question 1 (Slide 5)
SELECT utm_campaign, utm_source
FROM page_visits
GROUP BY utm_campaign, utm_source
ORDER BY utm_source;

Question 2 (Slide 6)
SELECT distinct page_name, utm_campaign,
utm_source
FROM page_visits
GROUP BY page_name, utm_campaign
ORDER BY page_name DESC;

Question 3 (Slides 8 to 9)
WITH first_touch AS
(SELECT distinct user_id, min(timestamp),
utm_campaign, utm_source
FROM page_visits
GROUP BY user_id)
SELECT first_touch.utm_campaign,
first_touch.utm_source, count(*)
FROM first_touch
GROUP BY 1, 2
ORDER BY 3 DESC;

Question 4 (Slide 10)
WITH last_touch AS
(SELECT distinct user_id, max(timestamp),
utm_campaign, utm_source
FROM page_visits
GROUP BY user_id)
SELECT last_touch.utm_campaign,
last_touch.utm_source, count(*)
FROM last_touch
GROUP BY 1, 2
ORDER BY 3 DESC;

Question 5 (Slide 11)
SELECT COUNT(DISTINCT user_id)
FROM page_visits
WHERE page_name = “4 – purchase”;

Question 6 (Slide 12)
SELECT COUNT(DISTINCT user_id) as count,
max(timestamp), page_name, utm_campaign, utm_source
FROM page_visits
WHERE page_name = “4 – purchase”
GROUP BY utm_campaign
ORDER BY count DESC;

Additional Analysis
Examining the Funnel (Slide 14)
SELECT page_name, COUNT(user_id)
FROM page_visits
GROUP BY page_name;

No Repeat Sales (Slide 15)
SELECT COUNT(user_id) AS ”counter”,
utm_source
FROM page_visits
WHERE page_name = “4 – purchase”
GROUP BY utm_source
ORDER BY counter DESC;

SELECT COUNT(DISTINCT user_id) AS
“counter”, page_name, utm_campaign
FROM page_visits
WHERE page_name = “4 – purchase”
GROUP BY utm_campaign
ORDER BY counter DESC;

Only 6% of Visits Convert to a Sale (Slide 16)
SELECT COUNT(user_id) AS ”counter”,
utm_source
FROM page_visits
GROUP BY utm_source
ORDER BY counter DESC;

SELECT COUNT(user_id) AS "counter",
utm_source
FROM page_visits
WHERE page_name = "4 - purchase"
GROUP BY utm_source
ORDER BY counter DESC;


