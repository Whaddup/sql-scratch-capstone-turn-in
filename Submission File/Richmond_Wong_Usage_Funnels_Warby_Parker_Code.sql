Question 1 (Slide 5)
SELECT *
FROM survey
LIMIT 10;

Question 2 (Slide 6)
SELECT question, count(distinct user_id)
FROM survey
GROUP BY question;

Question 4 (Slide 7)
SELECT *
FROM quiz
LIMIT 5;

SELECT *
FROM home_try_on
LIMIT 5;

SELECT *
FROM purchase
LIMIT 5;

Question 5 (Slide 8)
SELECT DISTINCT q.user_id, h.user_id IS
NOT NULL AS “is_home_try_on”,
h.number_of_pairs, p.user_id IS NOT NULL
AS “is_purchase”
FROM quiz q
LEFT JOIN home_try_on h
ON q.user_id = h.user_id
LEFT JOIN purchase p
ON p.user_id = q.user_id
LIMIT 10;

Additional Analysis

Funnel Rates (Slide 10)
/* LEFT JOIN “quiz”, “home_try”_on and
“purchase” tables */
WITH all_join AS (SELECT * FROM quiz
LEFT JOIN home_try_on
ON quiz.user_id = home_try_on.user_id
LEFT JOIN purchase
ON home_try_on.user_id = purchase.user_id),
/* Count up the individual columns from
“all_join” table */
calculate_numbers AS (SELECT COUNT(*) AS
total_count, count(number_of_pairs) AS
hto_count, COUNT(price) AS purchase_count
FROM all_join)
/* Final calculation showing Funnel Rates */
SELECT 1.0 * total_count / total_count as "quiz
total",
1.0 * hto_count / total_count AS "quiz to hto",
1.0 * purchase_count / hto_count AS "hto to
purchase"
FROM calculate_numbers;

Purchase Rates of 5 Pairs vs 3 Pairs of Glasses (Slide 11)
/* LEFT JOIN “home_try_on” and “purchase” tables */
WITH step_one AS (SELECT h.user_id,
CASE
WHEN (h.number_of_pairs = "5 pairs")
AND (p.price IS NOT NULL)
THEN 1
ELSE 0
END AS "five_pairs_and_bought",
CASE
WHEN (h.number_of_pairs = "3 pairs")
AND (p.price IS NOT NULL)
THEN 1
ELSE 0
END AS "three_pairs_and_bought",
p.user_id IS NOT NULL AS purchase_id
FROM home_try_on AS h
LEFT JOIN purchase AS p
ON h.user_id = p.user_id),
/* Sum up columns for # of users who try on 3 and 5
pairs of glasses. Also sum up the number of unique users
who bought something*/
step_two AS (SELECT SUM(five_pairs_and_bought) AS
"sum_five", SUM(three_pairs_and_bought) AS "sum_three",
SUM(purchase_id) AS "total_purchase" FROM step_one)
/* Final calculation for purchase rates of those who
tried on 3 pairs vs 5 pairs */
SELECT 1.0 * sum_three / total_purchase AS "Three
pairs",
1.0 * sum_five / total_purchase AS "Five pairs",
1.0 * total_purchase / total_purchase AS "Total"
FROM step_two;

Most Popular Model of Frames (Slide 12)
SELECT model_name, COUNT(*) as counter FROM
purchase
GROUP BY model_name
ORDER BY counter DESC;