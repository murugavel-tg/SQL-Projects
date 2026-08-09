
-- ============================================================
-- Sales Analysis Project
-- File: 04_advanced_sql_analysis.sql
-- Purpose: Advanced SQL analysis using CTEs and window functions
-- ============================================================

USE SalesAnalysis;
GO

-- ============================================================
-- 1. Rank Customers by Revenue
-- ============================================================

WITH customer_sales AS (
    SELECT
        c.customer_id,
        c.customer_name,
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
        c.customer_name
)
SELECT
    customer_name,
    total_revenue,
    RANK() OVER (
        ORDER BY total_revenue DESC
    ) AS revenue_rank
FROM customer_sales
ORDER BY revenue_rank;

-- ============================================================
-- 2. Rank Products Within Each Category
-- ============================================================

WITH product_sales AS (
    SELECT
        p.product_id,
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
)
SELECT
    product_name,
    category,
    total_revenue,
    RANK() OVER (
        PARTITION BY category
        ORDER BY total_revenue DESC
    ) AS category_rank
FROM product_sales
ORDER BY
    category,
    category_rank;

-- ============================================================
-- 3. Top 2 Products in Each Category
-- ============================================================

WITH product_sales AS (
    SELECT
        p.product_id,
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
),
ranked_products AS (
    SELECT
        product_name,
        category,
        total_revenue,
        ROW_NUMBER() OVER (
            PARTITION BY category
            ORDER BY total_revenue DESC
        ) AS product_rank
    FROM product_sales
)
SELECT
    product_name,
    category,
    total_revenue,
    product_rank
FROM ranked_products
WHERE product_rank <= 2
ORDER BY
    category,
    product_rank;

-- ============================================================
-- 4. Running Monthly Revenue
-- ============================================================

WITH monthly_sales AS (
    SELECT
        DATEFROMPARTS(
            YEAR(o.order_date),
            MONTH(o.order_date),
            1
        ) AS sales_month,
        SUM(oi.quantity * p.unit_price) AS monthly_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        YEAR(o.order_date),
        MONTH(o.order_date)
)
SELECT
    sales_month,
    monthly_revenue,
    SUM(monthly_revenue) OVER (
        ORDER BY sales_month
    ) AS running_revenue
FROM monthly_sales
ORDER BY sales_month;

-- ============================================================
-- 5. Monthly Revenue with Previous Month Revenue
-- ============================================================

WITH monthly_sales AS (
    SELECT
        DATEFROMPARTS(
            YEAR(o.order_date),
            MONTH(o.order_date),
            1
        ) AS sales_month,
        SUM(oi.quantity * p.unit_price) AS monthly_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        YEAR(o.order_date),
        MONTH(o.order_date)
)
SELECT
    sales_month,
    monthly_revenue,
    LAG(monthly_revenue) OVER (
        ORDER BY sales_month
    ) AS previous_month_revenue
FROM monthly_sales
ORDER BY sales_month;

-- ============================================================
-- 6. Month-over-Month Revenue Change
-- ============================================================

WITH monthly_sales AS (
    SELECT
        DATEFROMPARTS(
            YEAR(o.order_date),
            MONTH(o.order_date),
            1
        ) AS sales_month,
        SUM(oi.quantity * p.unit_price) AS monthly_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        YEAR(o.order_date),
        MONTH(o.order_date)
),
monthly_comparison AS (
    SELECT
        sales_month,
        monthly_revenue,
        LAG(monthly_revenue) OVER (
            ORDER BY sales_month
        ) AS previous_month_revenue
    FROM monthly_sales
)
SELECT
    sales_month,
    monthly_revenue,
    previous_month_revenue,
    monthly_revenue - previous_month_revenue AS revenue_change,
    CAST(
        (
            (monthly_revenue - previous_month_revenue)
            / NULLIF(previous_month_revenue, 0)
        ) * 100
        AS DECIMAL(10,2)
    ) AS revenue_change_percentage
FROM monthly_comparison
ORDER BY sales_month;

-- ============================================================
-- 7. Revenue Contribution by Region
-- ============================================================

WITH regional_sales AS (
    SELECT
        o.region,
        SUM(oi.quantity * p.unit_price) AS regional_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY o.region
)
SELECT
    region,
    regional_revenue,
    CAST(
        (
            regional_revenue
            / NULLIF(SUM(regional_revenue) OVER (), 0)
        ) * 100
        AS DECIMAL(10,2)
    ) AS revenue_percentage
FROM regional_sales
ORDER BY regional_revenue DESC;

-- ============================================================
-- 8. Customer Order Sequence
-- ============================================================

SELECT
    c.customer_name,
    o.order_id,
    o.order_date,

    ROW_NUMBER() OVER (
        PARTITION BY c.customer_id
        ORDER BY o.order_date
    ) AS customer_order_number

FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
ORDER BY
    c.customer_name,
    o.order_date;

