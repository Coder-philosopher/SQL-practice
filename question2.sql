/* ===========================================================================
   CUSTOMERS & ORDERS SQL PRACTICE SCRIPT
   Covers:
   - CREATE TABLE with FOREIGN KEY constraints
   - INSERT data into related tables
   - INNER JOIN, LEFT JOIN
   - Aggregations with GROUP BY & ORDER BY
   - Subqueries (EXISTS, scalar, correlated)
   - Alternatives using JOINs instead of subqueries
   =========================================================================== */

-- SAFETY FIRST: Drop tables if already existing (maintains reusability)
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;

/* ===========================================================================
   1️⃣ CREATE TABLE customers
   =========================================================================== */
CREATE TABLE customers (
  customer_id SERIAL PRIMARY KEY,     -- Auto increment, unique identifier
  first_name  TEXT NOT NULL,
  last_name   TEXT NOT NULL,
  email       TEXT NOT NULL UNIQUE,  -- Prevents duplicate registrations
  city        TEXT,
  created_at  DATE NOT NULL
);

-- Check structure
SELECT * FROM customers;

/* ===========================================================================
   2️⃣ CREATE TABLE orders (with FOREIGN KEY reference)
   =========================================================================== */

CREATE TABLE orders (
  order_id SERIAL PRIMARY KEY,
  customer_id INT NOT NULL,  
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
    ON DELETE CASCADE ON UPDATE CASCADE,  
  -- FOREIGN KEY ensures orders always belong to valid customers
  order_date DATE NOT NULL,
  amount NUMERIC(10,2) NOT NULL,
  status TEXT NOT NULL
);

-- Check structure
SELECT * FROM orders;

/* ===========================================================================
   3️⃣ INSERT SAMPLE DATA in customers
   =========================================================================== */
INSERT INTO customers (first_name, last_name, email, city, created_at)
VALUES
  ('Prince',  'Kumar', 'prince@12',    'Mumbai', '2024-01-29'),
  ('Chandan', 'Kumar', 'prince@1',     'Pune',   '2023-01-29'),
  ('Meena',   'Kumar', 'prince@1232',  'Delhi',  '2022-01-29'),
  ('Raju',    'Kumar', 'prince@152',   'Pune',   '2021-01-29'),
  ('Rakesh',  'Kumar', 'prince@12342', 'Mumbai', '2020-01-29');

SELECT * FROM customers;

/* ===========================================================================
   4️⃣ INSERT SAMPLE DATA into orders (child table)
   =========================================================================== */
INSERT INTO orders (customer_id, order_date, amount, status)
VALUES
  (1, '2025-12-01', 240.00, 'CANCELLED'),
  (1, '2025-12-01', 202.00, 'COMPLETED'),
  (2, '2025-10-01', 672.00, 'PENDING'),
  (2, '2025-11-01', 240.00, 'COMPLETED'),
  (3, '2025-12-02', 132.00, 'CANCELLED'),
  (4, '2025-12-03', 890.00, 'COMPLETED'),
  (3, '2025-12-01', 183.00, 'PENDING'),
  (4, '2025-09-23',  22.00, 'COMPLETED');

SELECT * FROM orders;

/* ===========================================================================
   5️⃣ INNER JOIN → Only customers who have placed orders
   =========================================================================== */

SELECT 
  o.order_id,
  o.order_date,
  o.amount,
  o.status,
  c.first_name,
  c.last_name
FROM customers c
INNER JOIN orders o
  ON c.customer_id = o.customer_id;

-- TRICK:
-- INNER JOIN = intersection → Only matching records on both sides
-- If no order found → that customer is NOT shown

/* ===========================================================================
   6️⃣ LEFT JOIN → Show all customers (orders may be NULL)
   =========================================================================== */

SELECT 
  c.customer_id,
  c.first_name,
  c.last_name,
  o.order_id,
  o.amount
FROM customers c
LEFT JOIN orders o
  ON c.customer_id = o.customer_id;

-- TRICK:
-- LEFT JOIN keeps ALL rows from left table (customers)
-- Missing orders = NULL values in order-related columns

/* ===========================================================================
   7️⃣ GROUP BY + SUM: Total spent by each customer (only COMPLETED orders)
   =========================================================================== */

SELECT 
  c.customer_id,
  c.first_name,
  c.last_name,
  SUM(o.amount) AS total_spent
FROM customers c
INNER JOIN orders o
  ON c.customer_id = o.customer_id
WHERE o.status = 'COMPLETED'
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC;

-- TRICK:
-- WHERE is applied BEFORE GROUP BY (filters rows first)
-- HAVING filters groups AFTER aggregation

/* ===========================================================================
   8️⃣ SUBQUERY (NOT EXISTS) → Customers with 0 ORDERS
   =========================================================================== */

SELECT 
  c.customer_id,
  c.first_name,
  c.last_name
FROM customers c
WHERE NOT EXISTS (
  SELECT 1
  FROM orders o
  WHERE o.customer_id = c.customer_id
);

-- SUBQUERY EXPLANATION:
-- For each customer → check if ANY matching order exists
-- If none → display that customer
-- SELECT 1 is used for performance — data returned doesn't matter

-- ✨ Alternative using LEFT JOIN (without subquery):
SELECT c.customer_id, c.first_name, c.last_name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- Both produce SAME RESULT ✔

/* ===========================================================================
   9️⃣ SUBQUERY: Find the customer who spent the MOST on COMPLETED orders
   =========================================================================== */

SELECT 
  c.customer_id,
  c.first_name,
  c.last_name,
  t.total_spent
FROM customers c
JOIN (
  SELECT 
    o.customer_id,
    SUM(o.amount) AS total_spent
  FROM orders o
  WHERE o.status = 'COMPLETED'
  GROUP BY o.customer_id
  ORDER BY total_spent DESC
  LIMIT 1              -- Top spender only
) t ON c.customer_id = t.customer_id;

-- Subquery creates a temporary grouped result table (alias "t")

-- ✨ Alternative using WINDOW FUNCTION (advanced):
SELECT
  c.customer_id,
  c.first_name,
  c.last_name,
  SUM(o.amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.status='COMPLETED'
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC
FETCH FIRST 1 ROW ONLY;

/* ===========================================================================
   🔟 SUBQUERY (comparison with AVG) → Orders with above-average amount
   =========================================================================== */

SELECT 
  o.order_id,
  o.customer_id,
  o.order_date,
  o.amount,
  o.status
FROM orders o
WHERE o.amount > (
  SELECT AVG(amount) FROM orders
);

-- EXPLANATION:
-- Scalar subquery → returns a single numeric value
-- All rows where amount is greater than global AVG are selected

-- ✨ Alternative using JOIN:
SELECT 
  o.*
FROM orders o
CROSS JOIN (SELECT AVG(amount) AS avg_amt FROM orders) t
WHERE o.amount > t.avg_amt;

/* ===========================================================================
   END OF SCRIPT
   =========================================================================== */
