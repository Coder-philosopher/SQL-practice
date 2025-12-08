# Customers & Orders SQL Practice Script

## Quick Reference Guide

### 1. Setting Up: Drop Existing Tables
```sql
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;
```
**Trick:** Always drop child table (orders) before parent (customers) to avoid foreign key errors.

### 2. Create Customers Table
```sql
CREATE TABLE customers (
  customer_id SERIAL PRIMARY KEY,
  first_name  TEXT NOT NULL,
  last_name   TEXT NOT NULL,
  email       TEXT NOT NULL UNIQUE,
  city        TEXT,
  created_at  DATE NOT NULL
);
```
**Common Issue:** Forgetting `NOT NULL` on important fields like email.

### 3. Create Orders Table with Foreign Key
```sql
CREATE TABLE orders (
  order_id SERIAL PRIMARY KEY,
  customer_id INT NOT NULL,  
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  order_date DATE NOT NULL,
  amount NUMERIC(10,2) NOT NULL,
  status TEXT NOT NULL
);
```
**Trick:** `ON DELETE CASCADE` automatically deletes orders when a customer is deleted.

### 4. Insert Sample Data
**Customers:**
```sql
-- 5 customers inserted
-- Customer IDs: 1=Prince, 2=Chandan, 3=Meena, 4=Raju, 5=Rakesh
```
**Orders:**
```sql
-- 8 orders inserted
-- Customer 1: 2 orders, Customer 2: 2 orders
-- Customer 3: 2 orders, Customer 4: 2 orders
-- Customer 5: 0 orders (important for testing!)
```

## Query Examples & How They Work

### 5. INNER JOIN: Customers with Orders Only
```sql
SELECT c.first_name, o.order_id, o.amount
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id;
```
**Result:** Shows only customers 1, 2, 3, 4 (customer 5 excluded - no orders)

**Trick:** INNER JOIN = intersection of two tables.

### 6. LEFT JOIN: All Customers (Orders Optional)
```sql
SELECT c.first_name, o.order_id
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;
```
**Result:** All 5 customers shown. Customer 5 shows NULL for order columns.

**Common Issue:** Forgetting ON clause creates Cartesian product.

### 7. GROUP BY: Total Spent Per Customer
```sql
SELECT c.first_name, SUM(o.amount) AS total_spent
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
WHERE o.status = 'COMPLETED'
GROUP BY c.customer_id, c.first_name;
```
**Execution Flow:**
1. JOIN customers & orders
2. WHERE filters only 'COMPLETED' orders
3. GROUP BY creates groups per customer
4. SUM calculates total per group

**Rule:** All non-aggregated SELECT columns must be in GROUP BY.

### 8. NOT EXISTS: Customers Without Orders
```sql
SELECT c.first_name
FROM customers c
WHERE NOT EXISTS (
  SELECT 1 FROM orders o 
  WHERE o.customer_id = c.customer_id
);
```
**How it works:** For each customer, check if ANY order exists. If none, include customer.

**Alternative (LEFT JOIN):**
```sql
SELECT c.first_name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;
```
**Trick:** `SELECT 1` is faster than `SELECT *` in EXISTS subqueries.

### 9. Subquery: Top Spender
```sql
SELECT c.first_name, t.total_spent
FROM customers c
JOIN (
  SELECT customer_id, SUM(amount) AS total_spent
  FROM orders WHERE status='COMPLETED'
  GROUP BY customer_id
  ORDER BY total_spent DESC
  LIMIT 1
) t ON c.customer_id = t.customer_id;
```
**Process:**
1. Subquery finds top spender among completed orders
2. Main query joins result with customers for name

### 10. Scalar Subquery: Above Average Orders
```sql
SELECT order_id, amount
FROM orders
WHERE amount > (SELECT AVG(amount) FROM orders);
```
**Works:** Subquery returns single value (average), main query compares each order.

**Alternative with JOIN:**
```sql
SELECT o.*
FROM orders o
CROSS JOIN (SELECT AVG(amount) AS avg_amt FROM orders) t
WHERE o.amount > t.avg_amt;
```

## Quick Comparison Table

| Task | Subquery Method | JOIN Method |
|------|----------------|-------------|
| Customers without orders | NOT EXISTS | LEFT JOIN + IS NULL |
| Above average values | Scalar subquery | CROSS JOIN with aggregate |
| Top performer | LIMIT in subquery | WINDOW function |

## Common Pitfalls

1. **NULL in NOT IN:** `NOT IN (subquery)` fails if subquery returns NULL
2. **Performance:** Correlated subqueries run for each row - can be slow
3. **Readability:** Complex subqueries harder to debug than equivalent JOINs
4. **Cartesian Product:** Missing JOIN conditions multiply rows exponentially

## Best Practices

1. Use EXISTS over IN for checking existence
2. Test subqueries independently first
3. Consider rewriting correlated subqueries as JOINs
4. Always use aliases for clarity
5. Use LIMIT with ORDER BY for top-N queries

## Key Takeaways

- **INNER JOIN:** Matching rows only
- **LEFT JOIN:** All from left, matching from right (NULLs if no match)
- **Subqueries:** Flexible but test performance
- **GROUP BY:** Always with aggregates
- **WHERE vs HAVING:** WHERE filters rows, HAVING filters groups