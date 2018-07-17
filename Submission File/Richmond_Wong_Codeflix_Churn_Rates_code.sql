Question 1 (Slide 5)
SELECT segment
FROM subscriptions
GROUP BY segment;

Question 2 (Slide 6)
SELECT min(subscription_start),
min(subscription_end),
max(subscription_end)
FROM subscriptions;

Questions 3 to 8 (Slides 8 - 12)
/* months temporary table */
WITH months as (SELECT “2017-01-01” as first_day, “2017-01-31” as last_day
UNION
SELECT “2017-02-01” as first_day, “2017-02-28” as last_day
UNION
SELECT “2017-03-01” as first_day, “2017-03-31” as last_day),
/* cross_join temporary table */
cross_join AS (SELECT *
FROM subscriptions
CROSS JOIN months),
/* status temporary table */
status as (SELECT id, first_day,
CASE
WHEN (segment = 87) AND (subscription_start < first_day)
AND (subscription_end > first_day OR subscription_end IS NULL) THEN 1
ELSE 0
END AS is_active_87,
CASE
WHEN (segment = 30) AND (subscription_start < first_day)
AND (subscription_end > first_day OR subscription_end IS NULL) THEN 1
ELSE 0
END AS is_active_30,
CASE
WHEN (segment = 87)AND (subscription_end BETWEEN first_day
AND last_day) THEN 1
ELSE 0
END AS is_canceled_87,
CASE
WHEN (segment = 30) AND (subscription_end BETWEEN first_day
AND last_day) THEN 1
ELSE 0
END AS is_canceled_30
FROM cross_join),
/* status_aggregate temporary table */
status_aggregate AS (SELECT first_day, SUM(is_active_87) AS sum_active_87, SUM(is_active_30)
AS sum_active_30, SUM(is_canceled_87) AS sum_canceled_87, SUM(is_canceled_30) AS
sum_canceled_30
FROM status
GROUP BY first_day)
/* Churn calculation */
SELECT first_day,
1.0 * sum_canceled_87 / sum_active_87 AS churn_rate_87,
1.0 * sum_canceled_30 / sum_active_30 AS churn_rate_30
FROM status_aggregate;