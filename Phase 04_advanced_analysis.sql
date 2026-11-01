select * from shopping_trends
limit 5;

-- 1 What is the total revenue of each product, and how does it compare with the average product revenue in its category?

SELECT
    "Category",
    "Item Purchased",
    SUM("Purchase Amount (USD)") AS total_revenue,
   round(avg(SUM("Purchase Amount (USD)")) OVER( partition by "Category"), 2) as average
FROM shopping_trends
GROUP BY "Category", "Item Purchased"
ORDER BY  total_revenue DESC;

-- 2 Which product categories have total sales higher than the average total sales of all categories?

with total__sales as (select "Category" , sum("Purchase Amount (USD)") as total_revenue
from shopping_trends
group by "Category"),
Average_sales as (select avg(total_revenue) as average_off_all_category
from total__sales)
select "Category", total_revenue, (select average_off_all_category from Average_sales ) as average
from total__sales
where total_revenue>(select average_off_all_category
from Average_sales);

-- 3 top 5 highest purchases item made by customers?

select "Customer ID", "Item Purchased", "Purchase Amount (USD)",
row_number() over(order by "Purchase Amount (USD)" desc, "Customer ID") as rank
from shopping_trends
order by rank
limit 5;

-- 4 Which products generate the highest total revenue?

select "Item Purchased", Sum("Purchase Amount (USD)"),
dense_rank() over(order by sum("Purchase Amount (USD)") desc) as rank
from shopping_trends
group by "Item Purchased"
order by rank asc;

-- 5 top 3 products each category
 
WITH product_revenue AS (
    SELECT
        "Category",
        "Item Purchased",
        SUM("Purchase Amount (USD)"::numeric) AS total_revenue
    FROM shopping_trends
    GROUP BY "Category", "Item Purchased"
),
product_ranking AS (
    SELECT
        "Category",
        "Item Purchased",
        total_revenue,
        RANK() OVER (
            PARTITION BY "Category"
            ORDER BY total_revenue DESC
        ) AS product_rank
    FROM product_revenue
)
SELECT
    "Category",
    "Item Purchased",
    total_revenue,
    product_rank
FROM product_ranking
WHERE product_rank <= 3
ORDER BY "Category", product_rank;

-- 6 What percentage of overall revenue does each product category contribute?

SELECT
    "Category",
    SUM("Purchase Amount (USD)"::numeric)
        AS category_revenue,
    SUM(SUM("Purchase Amount (USD)"::numeric)) OVER ()
        AS grand_total,
    ROUND(
        SUM("Purchase Amount (USD)"::numeric) * 100.0
        / SUM(SUM("Purchase Amount (USD)"::numeric)) OVER (),
        2)||'%' as revenue_percentage
FROM shopping_trends
GROUP BY "Category"
ORDER BY  category_revenue desc;

-- 7 What percentage of its category's total revenue does each product contribute

Select "Category","Item Purchased", SUM("Purchase Amount (USD)") as category_revenue,
Sum(SUM("Purchase Amount (USD)")) Over(partition by "Category") as garnd_total, 
Round(SUM("Purchase Amount (USD)")*100/Sum(SUM("Purchase Amount (USD)")) over(partition by "Category"), 2)|| '%' as Percenatge
from shopping_trends
group by "Category", "Item Purchased"
order by "Category";

-- 8 Running Total of Revenue

WITH product_revenue AS (
    SELECT
        "Item Purchased",
        SUM("Purchase Amount (USD)"::numeric) AS total_revenue
    FROM shopping_trends
    GROUP BY "Item Purchased"
)
SELECT
    "Item Purchased",
    total_revenue,
   SUM(total_revenue) OVER (
        ORDER BY total_revenue DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_revenue
FROM product_revenue
ORDER BY total_revenue DESC;

-- 9 Which customers spend more than their age group's average?

WITH age_groups AS (
    SELECT
        "Customer ID",
        "Age",
        "Purchase Amount (USD)"::numeric AS purchase_amount,
        CASE
            WHEN "Age" BETWEEN 18 AND 25 THEN '18-25'
            WHEN "Age" BETWEEN 26 AND 35 THEN '26-35'
            WHEN "Age" BETWEEN 36 AND 45 THEN '36-45'
            WHEN "Age" BETWEEN 46 AND 55 THEN '46-55'
            ELSE '56+'
        END AS age_group
    FROM shopping_trends
),
age_average AS (
    SELECT
        *,
        ROUND(
            AVG(purchase_amount) OVER (
                PARTITION BY age_group
            ), 2
        ) AS avg_age_group
    FROM age_groups
)
SELECT
    "Customer ID",
    "Age",
    age_group,
    purchase_amount,
    avg_age_group
FROM age_average
WHERE purchase_amount > avg_age_group
ORDER BY age_group, purchase_amount DESC;

-- 10 Which products generate more revenue than their category's average product revenue?

WITH product_revenue AS (
    SELECT
        "Category",
        "Item Purchased",
        SUM("Purchase Amount (USD)"::numeric) AS total_revenue
    FROM shopping_trends
    GROUP BY "Category", "Item Purchased"
),
category_average AS (
    SELECT
        "Category",
        "Item Purchased",
        total_revenue,
        ROUND(
            AVG(total_revenue) OVER (
                PARTITION BY "Category"
            ), 2
        ) AS avg_category_revenue
    FROM product_revenue
)
SELECT
    "Category",
    "Item Purchased",
    total_revenue,
    avg_category_revenue
FROM category_average
WHERE total_revenue > avg_category_revenue
ORDER BY "Category", total_revenue DESC;
