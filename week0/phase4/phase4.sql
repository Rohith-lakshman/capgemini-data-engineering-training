-- Create Customers Table
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id INTEGER,
    customer_name TEXT,
    city TEXT,
    age INTEGER
);

INSERT INTO customers VALUES
(1, 'Ravi', 'Hyderabad', 25),
(2, 'Meena', 'Chennai', 30),
(3, 'John', 'Bangalore', 28),
(4, 'Arun', 'Hyderabad', 35),
(5, 'Kiran', 'Chennai', 40);

-- Create Orders Table
DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
    order_id INTEGER,
    customer_id INTEGER,
    amount INTEGER,
    order_date TEXT
);

INSERT INTO orders VALUES
(101, 1, 5000, '2024-01-01'),
(102, 1, 7000, '2024-01-02'),
(103, 2, 3000, '2024-01-01'),
(104, 3, 8000, '2024-01-03'),
(105, 3, 2000, '2024-01-03'),
(106, 4, 15000, '2024-01-04'),
(107, 5, 1000, '2024-01-02');

--------------------------------------------------
-- Task 1: Daily Sales
--------------------------------------------------
CREATE VIEW daily_sales AS
SELECT order_date, SUM(amount) AS total_sales
FROM orders
GROUP BY order_date;

--------------------------------------------------
-- Task 2: City-wise Revenue
--------------------------------------------------
CREATE VIEW city_revenue AS
SELECT c.city, SUM(o.amount) AS total_revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.city;

--------------------------------------------------
-- Task 3: Top 5 Customers
--------------------------------------------------
CREATE VIEW top_customers AS
SELECT c.customer_name, SUM(o.amount) AS total_spend
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY total_spend DESC
LIMIT 5;

--------------------------------------------------
-- Task 4: Repeat Customers (>1 order)
--------------------------------------------------
CREATE VIEW repeat_customers AS
SELECT customer_id, COUNT(order_id) AS order_count
FROM orders
GROUP BY customer_id
HAVING COUNT(order_id) > 1;

--------------------------------------------------
-- Task 5: Customer Segmentation
--------------------------------------------------
CREATE VIEW customer_segmentation AS
SELECT c.customer_name,
       SUM(o.amount) AS total_spend,
       CASE
           WHEN SUM(o.amount) > 10000 THEN 'Gold'
           WHEN SUM(o.amount) BETWEEN 5000 AND 10000 THEN 'Silver'
           ELSE 'Bronze'
       END AS segment
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name;

--------------------------------------------------
-- Task 6 & 7: Final Report
--------------------------------------------------
CREATE VIEW final_report AS
SELECT c.customer_name,
       c.city,
       SUM(o.amount) AS total_spend,
       COUNT(o.order_id) AS order_count,
       CASE
           WHEN SUM(o.amount) > 10000 THEN 'Gold'
           WHEN SUM(o.amount) BETWEEN 5000 AND 10000 THEN 'Silver'
           ELSE 'Bronze'
       END AS segment
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name, c.city;