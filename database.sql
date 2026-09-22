-- Sunrise Supermarket - PL/SQL Assignment One
-- Student: KAYITESI Annet
-- Student ID: 29077
-- DBMS: Oracle Database

-- =========================================================
-- 1. TABLE CREATION
-- =========================================================

CREATE TABLE customers (
  customer_id NUMBER PRIMARY KEY,
  customer_name VARCHAR2(100),
  email VARCHAR2(100),
  city VARCHAR2(50)
);

CREATE TABLE products (
  product_id NUMBER PRIMARY KEY,
  product_name VARCHAR2(100),
  category VARCHAR2(50),
  price NUMBER(10,2)
);

CREATE TABLE orders (
  order_id NUMBER PRIMARY KEY,
  customer_id NUMBER REFERENCES customers(customer_id),
  order_date DATE
);

CREATE TABLE order_items (
  order_item_id NUMBER PRIMARY KEY,
  order_id NUMBER REFERENCES orders(order_id),
  product_id NUMBER REFERENCES products(product_id),
  quantity NUMBER
);

-- =========================================================
-- 2. SAMPLE DATA
-- At least 5 customers, 8 products, 15 orders, 25 items
-- =========================================================

INSERT INTO customers VALUES (1, 'MUGISHA Eric', 'eric.mugisha@email.com', 'Kigali');
INSERT INTO customers VALUES (2, 'MURENZI David', 'david.murenzi@email.com', 'Huye');
INSERT INTO customers VALUES (3, 'MUNEZA Alice', 'alice.muneza@email.com', 'Musanze');
INSERT INTO customers VALUES (4, 'MUGABE Jean', 'jean.mugabe@email.com', 'Rubavu');
INSERT INTO customers VALUES (5, 'NGABO Patrick', 'patrick.ngabo@email.com', 'Kigali');

INSERT INTO products VALUES (1, 'Rice 5kg', 'Food', 7500);
INSERT INTO products VALUES (2, 'Sugar 2kg', 'Food', 3000);
INSERT INTO products VALUES (3, 'Cooking Oil 2L', 'Food', 6500);
INSERT INTO products VALUES (4, 'Milk 1L', 'Dairy', 1800);
INSERT INTO products VALUES (5, 'Yogurt 500ml', 'Dairy', 1500);
INSERT INTO products VALUES (6, 'Soap Bar', 'Household', 1000);
INSERT INTO products VALUES (7, 'Laundry Powder 2kg', 'Household', 5500);
INSERT INTO products VALUES (8, 'Toothpaste', 'Personal Care', 2500);

INSERT INTO orders VALUES (1, 1, DATE '2026-08-01');
INSERT INTO orders VALUES (2, 2, DATE '2026-08-03');
INSERT INTO orders VALUES (3, 3, DATE '2026-08-05');
INSERT INTO orders VALUES (4, 1, DATE '2026-08-08');
INSERT INTO orders VALUES (5, 4, DATE '2026-08-10');
INSERT INTO orders VALUES (6, 5, DATE '2026-08-12');
INSERT INTO orders VALUES (7, 2, DATE '2026-08-15');
INSERT INTO orders VALUES (8, 3, DATE '2026-08-18');
INSERT INTO orders VALUES (9, 1, DATE '2026-08-20');
INSERT INTO orders VALUES (10, 4, DATE '2026-08-22');
INSERT INTO orders VALUES (11, 5, DATE '2026-08-25');
INSERT INTO orders VALUES (12, 2, DATE '2026-08-27');
INSERT INTO orders VALUES (13, 3, DATE '2026-09-01');
INSERT INTO orders VALUES (14, 5, DATE '2026-09-05');
INSERT INTO orders VALUES (15, 1, DATE '2026-09-10');

INSERT INTO order_items VALUES (1, 1, 1, 2);
INSERT INTO order_items VALUES (2, 1, 4, 3);
INSERT INTO order_items VALUES (3, 2, 2, 2);
INSERT INTO order_items VALUES (4, 2, 6, 4);
INSERT INTO order_items VALUES (5, 3, 3, 1);
INSERT INTO order_items VALUES (6, 3, 5, 3);
INSERT INTO order_items VALUES (7, 4, 1, 1);
INSERT INTO order_items VALUES (8, 4, 7, 2);
INSERT INTO order_items VALUES (9, 5, 4, 5);
INSERT INTO order_items VALUES (10, 5, 8, 2);
INSERT INTO order_items VALUES (11, 6, 3, 2);
INSERT INTO order_items VALUES (12, 6, 6, 3);
INSERT INTO order_items VALUES (13, 7, 2, 3);
INSERT INTO order_items VALUES (14, 7, 7, 1);
INSERT INTO order_items VALUES (15, 8, 5, 4);
INSERT INTO order_items VALUES (16, 8, 8, 1);
INSERT INTO order_items VALUES (17, 9, 1, 3);
INSERT INTO order_items VALUES (18, 9, 3, 2);
INSERT INTO order_items VALUES (19, 10, 4, 4);
INSERT INTO order_items VALUES (20, 10, 6, 5);
INSERT INTO order_items VALUES (21, 11, 7, 2);
INSERT INTO order_items VALUES (22, 11, 8, 2);
INSERT INTO order_items VALUES (23, 12, 2, 4);
INSERT INTO order_items VALUES (24, 12, 5, 3);
INSERT INTO order_items VALUES (25, 13, 3, 2);
INSERT INTO order_items VALUES (26, 13, 7, 1);
INSERT INTO order_items VALUES (27, 14, 1, 2);
INSERT INTO order_items VALUES (28, 14, 4, 4);
INSERT INTO order_items VALUES (29, 15, 6, 6);
INSERT INTO order_items VALUES (30, 15, 8, 2);

COMMIT;

-- =========================================================
-- 3. JOIN QUERIES
-- =========================================================

-- JOIN 1: Every order with customer name, city and order date.
SELECT
    o.order_id,
    c.customer_name,
    c.city,
    o.order_date
FROM orders o
INNER JOIN customers c
    ON o.customer_id = c.customer_id
ORDER BY o.order_date;

-- JOIN 2: Every order item with product details.
SELECT
    oi.order_item_id,
    oi.order_id,
    p.product_name,
    p.category,
    p.price,
    oi.quantity
FROM order_items oi
INNER JOIN products p
    ON oi.product_id = p.product_id
ORDER BY oi.order_id, oi.order_item_id;

-- JOIN 3: All customers and their orders, including customers
-- who have no orders.
SELECT
    c.customer_id,
    c.customer_name,
    c.city,
    o.order_id,
    o.order_date
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
ORDER BY c.customer_id, o.order_date;

-- =========================================================
-- 4. CTE QUERY
-- Customers whose total spending is above the average customer spend.
-- =========================================================

WITH customer_totals AS (
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(oi.quantity * p.price) AS total_spend
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY c.customer_id, c.customer_name
)
SELECT
    customer_id,
    customer_name,
    total_spend
FROM customer_totals
WHERE total_spend > (SELECT AVG(total_spend) FROM customer_totals)
ORDER BY total_spend DESC;

-- =========================================================
-- 5. WINDOW-FUNCTION QUERIES
-- =========================================================

-- Window 1: Rank customers by total amount spent.
WITH customer_totals AS (
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(oi.quantity * p.price) AS total_spend
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY c.customer_id, c.customer_name
)
SELECT
    customer_id,
    customer_name,
    total_spend,
    RANK() OVER (ORDER BY total_spend DESC) AS spending_rank
FROM customer_totals
ORDER BY spending_rank;

-- Window 2: Number each customer's orders in the order placed.
SELECT
    o.order_id,
    c.customer_name,
    o.order_date,
    ROW_NUMBER() OVER (
        PARTITION BY o.customer_id
        ORDER BY o.order_date, o.order_id
    ) AS customer_order_number
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
ORDER BY c.customer_name, customer_order_number;

-- Window 3: Running total of revenue over time.
-- Each order's revenue is calculated from quantity * price.
WITH order_revenue AS (
    SELECT
        o.order_id,
        o.order_date,
        SUM(oi.quantity * p.price) AS order_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY o.order_id, o.order_date
)
SELECT
    order_id,
    order_date,
    order_revenue,
    SUM(order_revenue) OVER (
        ORDER BY order_date, order_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_revenue
FROM order_revenue
ORDER BY order_date, order_id;

-- Window 4: Days between current and previous order for customers
-- who have more than one order.
WITH customer_orders AS (
    SELECT
        o.order_id,
        o.customer_id,
        c.customer_name,
        o.order_date,
        LAG(o.order_date) OVER (
            PARTITION BY o.customer_id
            ORDER BY o.order_date, o.order_id
        ) AS previous_order_date,
        COUNT(*) OVER (
            PARTITION BY o.customer_id
        ) AS order_count
    FROM orders o
    JOIN customers c
        ON o.customer_id = c.customer_id
)
SELECT
    customer_id,
    customer_name,
    order_id,
    order_date,
    previous_order_date,
    order_date - previous_order_date AS days_since_previous_order
FROM customer_orders
WHERE order_count > 1
ORDER BY customer_id, order_date;

-- =========================================================
-- 6. OPTIONAL CHECKS
-- =========================================================

SELECT COUNT(*) AS number_of_customers FROM customers;
SELECT COUNT(*) AS number_of_products FROM products;
SELECT COUNT(*) AS number_of_orders FROM orders;
SELECT COUNT(*) AS number_of_order_items FROM order_items;

-- Expected minimum counts:
-- Customers: 5
-- Products: 8
-- Orders: 15
-- Order items: 30
