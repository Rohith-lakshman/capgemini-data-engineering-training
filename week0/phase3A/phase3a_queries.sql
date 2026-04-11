-- Create table
CREATE TABLE customers (
    customer_id INT,
    name VARCHAR(50),
    city VARCHAR(50),
    age INT
);

-- Insert messy data
INSERT INTO customers VALUES
(1, 'Ravi', 'Hyderabad', 25),
(2, NULL, 'Chennai', 32),
(NULL, 'Arun', 'Hyderabad', 28),
(4, 'Meena', NULL, 30),
(4, 'Meena', NULL, 30),
(5, 'John', 'Bangalore', -5);

-- Check original data
SELECT * FROM customers;

-- Count before cleaning
SELECT COUNT(*) AS before_count FROM customers;

-- Remove NULL customer_id (important key)
DELETE FROM customers WHERE customer_id IS NULL;

-- Replace NULL values
UPDATE customers SET name = 'Unknown' WHERE name IS NULL;
UPDATE customers SET city = 'Unknown' WHERE city IS NULL;

-- Remove duplicates (keep one)
DELETE FROM customers
WHERE rowid NOT IN (
    SELECT MIN(rowid)
    FROM customers
    GROUP BY customer_id, name, city, age
);

-- Remove invalid age
DELETE FROM customers WHERE age <= 0;

-- Check cleaned data
SELECT * FROM customers;

-- Count after cleaning
SELECT COUNT(*) AS after_count FROM customers;

-- Aggregation: customers per city
SELECT city, COUNT(*) AS total_customers
FROM customers
GROUP BY city;