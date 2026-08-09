-- ============================================================
-- Sales Analysis Project
-- File: 03_customer_product_analysis.sql
-- Purpose: Customer and product performance analysis
-- ============================================================


-- ============================================================
-- 1. Top Customers by Revenue
-- ============================================================

SELECT
    c.customer_name,
    c.customer_segment,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity * p.unit_price) AS total_revenue
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
ORDER BY total_revenue DESC;


-- ============================================================
-- 2. Customers with More Than One Order
-- ============================================================

SELECT
    c.customer_name,
    COUNT(DISTINCT o.order_id) AS order_count
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.customer_name
HAVING COUNT(DISTINCT o.order_id) > 1
ORDER BY order_count DESC;


-- ============================================================
-- 3. Top Products by Units Sold
-- ============================================================

SELECT
    p.product_name,
    p.category,
    SUM(oi.quantity) AS units_sold
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY
    p.product_id,
    p.product_name,
    p.category
ORDER BY units_sold DESC;


-- ============================================================
-- 4. Top Products by Revenue
-- ============================================================

SELECT
    p.product_name,
    p.category,
    SUM(oi.quantity * p.unit_price) AS total_revenue
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY
    p.product_id,
    p.product_name,
    p.category
ORDER BY total_revenue DESC;


-- ============================================================
-- 5. Revenue by Product Category
-- ============================================================

SELECT
    p.category,
    SUM(oi.quantity * p.unit_price) AS category_revenue,
    SUM(oi.quantity) AS units_sold
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY p.category
ORDER BY category_revenue DESC;


-- ============================================================
-- 6. Average Revenue per Customer
-- ============================================================

SELECT
    AVG(customer_revenue) AS average_revenue_per_customer
FROM (
    SELECT
        c.customer_id,
        SUM(oi.quantity * p.unit_price) AS customer_revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY c.customer_id
) customer_sales;


-- ============================================================
-- 7. Customer Revenue Segmentation
-- ============================================================

SELECT
    c.customer_name,
    SUM(oi.quantity * p.unit_price) AS total_revenue,
    CASE
        WHEN SUM(oi.quantity * p.unit_price) >= 30000
            THEN 'High Value'
        WHEN SUM(oi.quantity * p.unit_price) >= 15000
            THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_value_segment
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY
    c.customer_id,
    c.customer_name
ORDER BY total_revenue DESC;


-- ============================================================
-- 8. Revenue by Customer Segment
-- ============================================================

SELECT
    c.customer_segment,
    COUNT(DISTINCT c.customer_id) AS number_of_customers,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity * p.unit_price) AS total_revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY c.customer_segment
ORDER BY total_revenue DESC;
