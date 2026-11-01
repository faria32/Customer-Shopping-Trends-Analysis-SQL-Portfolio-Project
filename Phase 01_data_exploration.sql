-- ==========================================
-- Customer Shopping Trends SQL Project
-- Phase 1: Data Exploration
--
-- ==========================================
-- Purpose:
-- Explore the dataset, check the database,
-- preview records, count total rows,
-- and inspect the table structure.
-- Tool: PostgreSQL / DBeaver
-- ==========================================

-- 1. Check current database
SELECT current_database();

-- 2. Preview the first 5 records
SELECT *
FROM shopping_trends
LIMIT 5;

-- 1. Check current database

SELECT current_database();

-- 2. Preview the first 10 records

SELECT *
FROM shopping_trends
LIMIT 10;

-- 3. Total number of records

SELECT COUNT(*) AS total_records
FROM shopping_trends;

-- 4. Inspect table structure

SELECT
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 'shopping_trends'
ORDER BY ordinal_position;

