SELECT *
FROM shopping_trends
LIMIT 5;

-- 1 Total Revenue

select Sum("Purchase Amount (USD)") as Total_Revenue
from shopping_trends;

-- 2 Which product categories generate the most revenue?

select "Category", sum("Purchase Amount (USD)") as Total_Revenue
from shopping_trends
group by "Category"
order by Total_Revenue  desc;

--3 Which products are purchased most frequently?

select "Item Purchased", Count("Item Purchased") as most_frequent_purchased 
from shopping_trends
group by "Item Purchased"
order by most_frequent_purchased desc;

-- 4 How does customer spending differ by gender?

select "Gender", sum("Purchase Amount (USD)") as Purchase_by_gender
from shopping_trends
group by "Gender"
order by Purchase_by_gender desc;

-- 5 Which age groups spend the most?

SELECT
    CASE
        WHEN "Age" BETWEEN 18 AND 25 THEN '18-25'
        WHEN "Age" BETWEEN 26 AND 35 THEN '26-35'
        WHEN "Age" BETWEEN 36 AND 45 THEN '36-45'
        WHEN "Age" BETWEEN 46 AND 55 THEN '46-55'
        ELSE '56+'
    END AS age_group,
SUM("Purchase Amount (USD)"::numeric) AS total_revenue
FROM shopping_trends
GROUP BY age_group
ORDER BY total_revenue DESC;

-- 6 Which seasons generate the most revenue?

select "Season", sum("Purchase Amount (USD)") as Purchase_by_season
from shopping_trends
group by "Season"
order by Purchase_by_season desc;

--- 7 Do subscribers spend more than non-subscribers?

select "Subscription Status", round(avg("Purchase Amount (USD)"),2) as Purchase_by_status
from shopping_trends
group by "Subscription Status"
order by Purchase_by_status desc;
SELECT
    ROUND(AVG(CASE
        WHEN "Subscription Status" = 'Yes'
        THEN "Purchase Amount (USD)"::numeric
    END), 2) AS subscriber_avg,
    ROUND(AVG(CASE
        WHEN "Subscription Status" = 'No'
        THEN "Purchase Amount (USD)"::numeric
    END), 2) AS non_subscriber_avg
FROM shopping_trends;

--- 8 How do discounts relate to purchasing behavior?

select  "Discount Applied" , count(*),  sum("Purchase Amount (USD)") as Purchase_by_discount,  round(avg("Purchase Amount (USD)"),2) as average_disount
from shopping_trends
group by "Discount Applied";

-- 9 Which payment methods are most popular? How do discounts relate to purchasing behavior?

SELECT
    "Payment Method",
    COUNT(*) AS total_purchases,
    RANK() OVER (ORDER by count(*) DESC) AS payment_rank
FROM shopping_trends
GROUP BY "Payment Method"
ORDER BY payment_rank;

--- 10 Which locations generate the most revenue?

select "Location", sum("Purchase Amount (USD)") as Purchase_by_Location
from shopping_trends
group by "Location"
order by Purchase_by_Location desc;

