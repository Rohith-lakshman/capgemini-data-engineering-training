-- Create table
CREATE TABLE customers (
    customer_id INT,
    name TEXT,
    country TEXT,
    total_spend INT
);

-- Insert sample data
INSERT INTO customers VALUES (101, 'Alice', 'USA', 12000);
INSERT INTO customers VALUES (102, 'Bob', 'INDIA', 7000);
INSERT INTO customers VALUES (103, 'Charlie', 'UK', 3000);
INSERT INTO customers VALUES (104, 'David', 'INDIA', 15000);
INSERT INTO customers VALUES (105, 'Eve', 'USA', 5000);

-- Task 1: Conditional Segmentation
SELECT customer_id, name, country, total_spend,
CASE
    WHEN total_spend > 10000 THEN 'Gold'
    WHEN total_spend BETWEEN 5000 AND 10000 THEN 'Silver'
    ELSE 'Bronze'
END AS segment
FROM customers;

-- Task 2: Count customers per segment
SELECT segment, COUNT(*) AS customer_count FROM (
    SELECT CASE
        WHEN total_spend > 10000 THEN 'Gold'
        WHEN total_spend BETWEEN 5000 AND 10000 THEN 'Silver'
        ELSE 'Bronze'
    END AS segment
    FROM customers
) GROUP BY segment;

-- Task 3: Quantile-like segmentation (manual approximation)
SELECT customer_id, total_spend,
CASE
    WHEN total_spend <= 5000 THEN 'Bronze'
    WHEN total_spend <= 10000 THEN 'Silver'
    ELSE 'Gold'
END AS segment
FROM customers;

-- Task 4: Window-based segmentation using percent_rank
SELECT customer_id, name, total_spend,
CASE
    WHEN rank_pct >= 0.66 THEN 'Gold'
    WHEN rank_pct >= 0.33 THEN 'Silver'
    ELSE 'Bronze'
END AS segment
FROM (
    SELECT *,
    PERCENT_RANK() OVER (ORDER BY total_spend) AS rank_pct
    FROM customers
);

-- Task 5: Final comparison
SELECT c.customer_id, c.total_spend,
CASE
    WHEN c.total_spend > 10000 THEN 'Gold'
    WHEN c.total_spend BETWEEN 5000 AND 10000 THEN 'Silver'
    ELSE 'Bronze'
END AS conditional,
CASE
    WHEN c.total_spend <= 5000 THEN 'Bronze'
    WHEN c.total_spend <= 10000 THEN 'Silver'
    ELSE 'Gold'
END AS quantile,
CASE
    WHEN pr >= 0.66 THEN 'Gold'
    WHEN pr >= 0.33 THEN 'Silver'
    ELSE 'Bronze'
END AS window
FROM (
    SELECT *, PERCENT_RANK() OVER (ORDER BY total_spend) AS pr
    FROM customers
) c;