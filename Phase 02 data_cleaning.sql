-- ==========================================
-- Phase 2: Data Cleaning and Quality Checks
-- Customer Shopping Trends SQL Project
-- ==========================================
--
-- Purpose:
-- Check the dataset for missing values,
-- duplicate customer IDs, inconsistent
-- categories, invalid ranges, and extra spaces.
--
-- These queries are validation checks.
-- They do not modify the original dataset.

SELECT current_database();

--1. Check missing values

SELECT
    COUNT(*) FILTER (WHERE "Customer ID" IS NULL) AS missing_customer_id,
    COUNT(*) FILTER (WHERE "Age" IS NULL) AS missing_age,
    COUNT(*) FILTER (WHERE "Gender" IS NULL OR TRIM("Gender") = '') AS missing_gender,
    COUNT(*) FILTER (WHERE "Item Purchased" IS NULL OR TRIM("Item Purchased") = '') AS missing_item,
    COUNT(*) FILTER (WHERE "Category" IS NULL OR TRIM("Category") = '') AS missing_category,
    COUNT(*) FILTER (WHERE "Purchase Amount (USD)" IS NULL OR TRIM("Purchase Amount (USD)"::text) = '') AS missing_purchase_amount,
    COUNT(*) FILTER (WHERE "Location" IS NULL OR TRIM("Location") = '') AS missing_location,
    COUNT(*) FILTER (WHERE "Size" IS NULL OR TRIM("Size") = '') AS missing_size,
    COUNT(*) FILTER (WHERE "Color" IS NULL OR TRIM("Color") = '') AS missing_color,
    COUNT(*) FILTER (WHERE "Season" IS NULL OR TRIM("Season") = '') AS missing_season,
    COUNT(*) FILTER (WHERE "Review Rating" IS NULL OR TRIM("Review Rating"::text) = '') AS missing_rating,
    COUNT(*) FILTER (WHERE "Subscription Status" IS NULL OR TRIM("Subscription Status") = '') AS missing_subscription,
    COUNT(*) FILTER (WHERE "Shipping Type" IS NULL OR TRIM("Shipping Type") = '') AS missing_shipping,
    COUNT(*) FILTER (WHERE "Discount Applied" IS NULL OR TRIM("Discount Applied") = '') AS missing_discount,
    COUNT(*) FILTER (WHERE "Promo Code Used" IS NULL OR TRIM("Promo Code Used") = '') AS missing_promo,
    COUNT(*) FILTER (WHERE "Previous Purchases" IS NULL OR TRIM("Previous Purchases"::text) = '') AS missing_previous_purchases,
    COUNT(*) FILTER (WHERE "Payment Method" IS NULL OR TRIM("Payment Method") = '') AS missing_payment,
    COUNT(*) FILTER (WHERE "Frequency of Purchases" IS NULL OR TRIM("Frequency of Purchases") = '') AS missing_frequency
FROM shopping_trends;

-- 2. Duplicate check

SELECT
    "Customer ID",
    COUNT(*) AS duplicate_count
FROM shopping_trends
GROUP BY "Customer ID"
HAVING COUNT(*) > 1;


-- 3. Check categorical inconsistencies

SELECT
    ARRAY_AGG(DISTINCT "Gender") AS gender,
    ARRAY_AGG(DISTINCT "Item Purchased") AS item_purchased,
    ARRAY_AGG(DISTINCT "Category") AS category,
    ARRAY_AGG(DISTINCT "Location") AS location,
    ARRAY_AGG(DISTINCT "Size") AS size,
    ARRAY_AGG(DISTINCT "Color") AS color,
    ARRAY_AGG(DISTINCT "Season") AS season,
    ARRAY_AGG(DISTINCT "Subscription Status") AS subscription_status,
    ARRAY_AGG(DISTINCT "Shipping Type") AS shipping_type,
    ARRAY_AGG(DISTINCT "Discount Applied") AS discount_applied,
    ARRAY_AGG(DISTINCT "Promo Code Used") AS promo_code_used,
    ARRAY_AGG(DISTINCT "Payment Method") AS payment_method,
    ARRAY_AGG(DISTINCT "Frequency of Purchases") AS purchase_frequency
FROM shopping_trends;

-- 4. Check age range

SELECT
    MIN("Age") AS minimum_age,
    MAX("Age") AS maximum_age
FROM shopping_trends;

-- 5. Check numeric value ranges

SELECT
    MIN("Purchase Amount (USD)"::numeric) AS min_purchase,
    MAX("Purchase Amount (USD)"::numeric) AS max_purchase,
    MIN("Review Rating"::numeric) AS min_rating,
    MAX("Review Rating"::numeric) AS max_rating,
    MIN("Previous Purchases"::numeric) AS min_previous_purchases,
    MAX("Previous Purchases"::numeric) AS max_previous_purchases
FROM shopping_trends;

-- 6. Check leading and trailing spaces

SELECT
    COUNT(*) FILTER (
        WHERE "Gender" <> TRIM("Gender")
    ) AS gender_spaces,
    COUNT(*) FILTER (
        WHERE "Category" <> TRIM("Category")
    ) AS category_spaces,
   COUNT(*) FILTER (
        WHERE "Season" <> TRIM("Season")
    ) AS season_spaces,
    COUNT(*) FILTER (
        WHERE "Payment Method" <> TRIM("Payment Method")
    ) AS payment_spaces,
    COUNT(*) FILTER (
        WHERE "Item Purchased" <> TRIM("Item Purchased")
    ) AS item_spaces
FROM shopping_trends;

-- 7. Final data validation

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT "Customer ID") AS unique_customers,
    COUNT(*) - COUNT("Customer ID") AS missing_customer_ids
FROM shopping_trends;