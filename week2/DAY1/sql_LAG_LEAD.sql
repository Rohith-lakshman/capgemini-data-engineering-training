CREATE TABLE sales (
    id INT,
    customer_id INT,
    order_date DATE,
    amount INT
);

INSERT INTO sales VALUES
(1, 101, '2023-01-01', 200),
(2, 101, '2023-01-05', 300),
(3, 101, '2023-01-10', 250),
(4, 102, '2023-01-02', 400),
(5, 102, '2023-01-06', 150),
(6, 102, '2023-01-08', 500),
(7, 103, '2023-01-03', 100),
(8, 103, '2023-01-07', 200);

-- 1: Previous Order Amount (LAG)
SELECT 
    customer_id,
    order_date,
    amount,
    LAG(amount,1,amount) OVER (
        PARTITION BY customer_id 
        ORDER BY order_date
    ) AS prev_amount
FROM sales;
-- 2: Next Order Amount (LEAD)
SELECT 
    customer_id,
    order_date,
    amount,
    LEAD(amount,1,amount) OVER (
        PARTITION BY customer_id 
        ORDER BY order_date
    ) AS next_amount
FROM sales;

-- 3: Difference from Previous Order
SELECT 
    customer_id,
    order_date,
    amount,
    amount - LAG(amount,1,amount) OVER (
        PARTITION BY customer_id 
        ORDER BY order_date
    ) AS diff_from_prev
FROM sales;

-- 4: Find First Order per Customer
SELECT 
    * , 
    LAG(order_date) OVER (
        PARTITION BY customer_id 
        ORDER BY order_date
    ) AS prev_date
FROM sales;

-- 5: Days Between Orders (MySQL Version)
SELECT 
    customer_id, 
    order_date, 
    DATEDIFF(
        order_date, 
        LAG(order_date) OVER (
            PARTITION BY customer_id 
            ORDER BY order_date
        )
    ) AS days_gap
FROM sales;

-- 6: Compare Current vs Next Order
SELECT 
    customer_id,
    order_date,
    amount,
    LEAD(amount) OVER (
        PARTITION BY customer_id 
        ORDER BY order_date
    ) - amount AS next_diff
FROM sales;