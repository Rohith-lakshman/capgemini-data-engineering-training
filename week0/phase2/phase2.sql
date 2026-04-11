-- Drop tables if already exist (avoid duplicates)
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS orders;

-- Create customers table
CREATE TABLE customers (
    customer_id INTEGER,
    customer_name TEXT,
    city TEXT
);

-- Create orders table
CREATE TABLE orders (
    order_id INTEGER,
    customer_id INTEGER,
    order_amount REAL
);

-- Insert sample data (same as your CSV)
INSERT INTO customers VALUES
(1, 'Ravi', 'Hyderabad'),
(2, 'Sita', 'Chennai'),
(3, 'Arun', 'Hyderabad'),
(4, 'John', 'Bangalore');

INSERT INTO orders VALUES
(101, 1, 500),
(102, 1, 300),
(103, 2, 700),
(104, 3, 200),
(105, 3, 100),
(106, 3, 400);

-- 1. Total order amount per customer
SELECT c.customer_name, SUM(o.order_amount) AS total_spend
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name;

-- 2. Top 3 customers by total spend
SELECT c.customer_name, SUM(o.order_amount) AS total_spend
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY total_spend DESC
LIMIT 3;

-- 3. Customers with no orders
SELECT c.customer_name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.customer_id IS NULL;

-- 4. City-wise total revenue
SELECT c.city, SUM(o.order_amount) AS revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.city;

-- 5. Average order amount per customer
SELECT c.customer_name, AVG(o.order_amount) AS avg_amount
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name;

-- 6. Customers with more than one order
SELECT c.customer_name, COUNT(o.order_id) AS order_count
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name
HAVING COUNT(o.order_id) > 1;

-- 7. Sort customers by total spend
SELECT c.customer_name, SUM(o.order_amount) AS total_spend
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY total_spend DESC;