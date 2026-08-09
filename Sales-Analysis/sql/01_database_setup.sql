-- ============================================================
-- Sales Analysis Project
-- File: 01_database_setup.sql
-- Purpose: Create tables and sample sales data
-- ============================================================


-- ============================================================
-- 1. Create Customers Table
-- ============================================================

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    city VARCHAR(50),
    region VARCHAR(50),
    customer_segment VARCHAR(50)
);


-- ============================================================
-- 2. Create Products Table
-- ============================================================

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    unit_price DECIMAL(10,2)
);


-- ============================================================
-- 3. Create Orders Table
-- ============================================================

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    region VARCHAR(50),

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);


-- ============================================================
-- 4. Create Order Items Table
-- ============================================================

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);


-- ============================================================
-- 5. Insert Customers
-- ============================================================

INSERT INTO customers
(customer_id, customer_name, city, region, customer_segment)
VALUES
(1, 'ABC Manufacturing', 'Singapore', 'Central', 'Corporate'),
(2, 'Bright Retail', 'Singapore', 'East', 'Retail'),
(3, 'Global Engineering', 'Jurong', 'West', 'Corporate'),
(4, 'Tech Solutions', 'Singapore', 'Central', 'Corporate'),
(5, 'Metro Supplies', 'Tampines', 'East', 'Retail'),
(6, 'Prime Industries', 'Jurong', 'West', 'Corporate'),
(7, 'Smart Traders', 'Woodlands', 'North', 'Retail'),
(8, 'Asia Engineering', 'Singapore', 'Central', 'Corporate'),
(9, 'Value Mart', 'Yishun', 'North', 'Retail'),
(10, 'Industrial Systems', 'Jurong', 'West', 'Corporate');


-- ============================================================
-- 6. Insert Products
-- ============================================================

INSERT INTO products
(product_id, product_name, category, unit_price)
VALUES
(101, 'Industrial Pump', 'Equipment', 2500.00),
(102, 'Pressure Valve', 'Equipment', 1200.00),
(103, 'Control Panel', 'Electrical', 3500.00),
(104, 'Steel Coupling', 'Mechanical', 850.00),
(105, 'Hydraulic Seal Kit', 'Maintenance', 450.00),
(106, 'Flow Meter', 'Instrumentation', 1800.00),
(107, 'Safety Sensor', 'Electrical', 950.00),
(108, 'Pipe Fitting Set', 'Mechanical', 600.00);


-- ============================================================
-- 7. Insert Orders
-- ============================================================

INSERT INTO orders
(order_id, customer_id, order_date, region)
VALUES
(1001, 1, '2026-01-05', 'Central'),
(1002, 2, '2026-01-08', 'East'),
(1003, 3, '2026-01-12', 'West'),
(1004, 4, '2026-01-18', 'Central'),
(1005, 5, '2026-02-03', 'East'),
(1006, 6, '2026-02-10', 'West'),
(1007, 7, '2026-02-15', 'North'),
(1008, 8, '2026-02-21', 'Central'),
(1009, 9, '2026-03-02', 'North'),
(1010, 10, '2026-03-08', 'West'),
(1011, 1, '2026-03-15', 'Central'),
(1012, 3, '2026-03-20', 'West'),
(1013, 4, '2026-04-05', 'Central'),
(1014, 6, '2026-04-12', 'West'),
(1015, 8, '2026-04-18', 'Central'),
(1016, 2, '2026-05-03', 'East'),
(1017, 5, '2026-05-10', 'East'),
(1018, 7, '2026-05-15', 'North'),
(1019, 9, '2026-06-01', 'North'),
(1020, 10, '2026-06-10', 'West');


-- ============================================================
-- 8. Insert Order Items
-- ============================================================

INSERT INTO order_items
(order_item_id, order_id, product_id, quantity)
VALUES

(1, 1001, 101, 4),
(2, 1001, 105, 10),

(3, 1002, 104, 8),
(4, 1002, 107, 5),

(5, 1003, 103, 3),
(6, 1003, 102, 5),

(7, 1004, 106, 6),
(8, 1004, 108, 10),

(9, 1005, 105, 15),
(10, 1005, 104, 10),

(11, 1006, 101, 5),
(12, 1006, 102, 8),

(13, 1007, 107, 12),
(14, 1007, 108, 15),

(15, 1008, 103, 4),
(16, 1008, 106, 5),

(17, 1009, 105, 20),
(18, 1009, 107, 10),

(19, 1010, 101, 6),
(20, 1010, 104, 12),

(21, 1011, 103, 5),
(22, 1011, 102, 6),

(23, 1012, 106, 8),
(24, 1012, 108, 20),

(25, 1013, 101, 7),
(26, 1013, 105, 12),

(27, 1014, 102, 10),
(28, 1014, 104, 15),

(29, 1015, 103, 6),
(30, 1015, 107, 8),

(31, 1016, 106, 7),
(32, 1016, 108, 15),

(33, 1017, 105, 25),
(34, 1017, 104, 12),

(35, 1018, 107, 18),
(36, 1018, 108, 20),

(37, 1019, 101, 8),
(38, 1019, 102, 12),

(39, 1020, 103, 5),
(40, 1020, 106, 10);
