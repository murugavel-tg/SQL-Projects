-- ============================================================
-- Sales Analysis Project
-- File: 02_basic_sales_analysis.sql
-- Purpose: Basic sales performance analysis
-- ============================================================


-- ============================================================
-- 1. Total Revenue
-- ============================================================

SELECT
    SUM(oi.quantity * p.unit_price) AS total_revenue
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id;


-- ============================================================
-- 2. Total Number of Orders
-- ============================================================

SELECT
    COUNT(DISTINCT order_id) AS total_orders
FROM orders;


-- ============================================================
-- 3. Total Quantity Sold
-- ============================================================

SELECT
    SUM(quantity) AS total_quantity_sold
FROM order_items;


-- ============================================================
-- 4. Average Order Value
-- ============================================================

SELECT
    SUM(oi.quantity * p.unit_price)
    / COUNT(DISTINCT oi.order_id) AS average_order_value
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id;


-- ============================================================
-- 5. Revenue by Month
-- ============================================================

SELECT
    DATE_TRUNC('month', o.order_date) AS sales_month,
    SUM(oi.quantity * p.unit_price) AS monthly_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY DATE_TRUNC('month', o.order_date)
ORDER BY sales_month;


-- ============================================================
-- 6. Revenue by Region
-- ============================================================

SELECT
    o.region,
    SUM(oi.quantity * p.unit_price) AS regional_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY o.region
ORDER BY regional_revenue DESC;


-- ============================================================
-- 7. Top 5 Products by Revenue
-- ============================================================

SELECT
    p.product_name,
    p.category,
    SUM(oi.quantity * p.unit_price) AS product_revenue
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY
    p.product_id,
    p.product_name,
    p.category
ORDER BY product_revenue DESC
LIMIT 5;


-- ============================================================
-- 8. Top 5 Customers by Revenue
-- ============================================================

SELECT
    c.customer_name,
    c.customer_segment,
    SUM(oi.quantity * p.unit_price) AS customer_revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY
    c.customer_id,
    c.customer_name,
    c.customer_segment
ORDER BY customer_revenue DESC
LIMIT 5;
