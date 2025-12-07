# SQL Complete Revision Notes  
Using Customers, Orders, and Employees Schema

This document covers SQL from fundamentals to advanced features with examples, tricks, warnings, and common mistakes. All examples use a consistent schema for better retention.

---

## Table of Contents

1. [Introduction](#1-introduction-to-sql)
2. [Database Basics](#2-database-and-table-basics)
3. [Create Table](#3-create-table)
4. [Insert](#4-insert-into)
5. [Select](#5-select-statement)
6. [WHERE Filtering](#6-where-filtering)
7. [ORDER BY Sorting](#7-order-by-sorting)
8. [DISTINCT](#8-distinct)
9. [LIMIT and OFFSET](#9-limit-and-offset)
10. [Comparison and Logical Operators](#10-comparison-and-logical-operators)
11. [Aggregate Functions](#11-aggregate-functions)
12. [GROUP BY](#12-group-by)
13. [HAVING](#13-having)
14. [UPDATE](#14-update)
15. [DELETE](#15-delete)
16. [ALTER TABLE](#16-alter-table)
17. [Joins](#17-joins)
18. [Subqueries](#18-subqueries)
19. [CASE Expression](#19-case-expression)
20. [Constraints](#20-constraints)
21. [Views](#21-views)
22. [Indexing Basics](#22-indexing-basics)
23. [SQL Best Practices](#23-sql-best-practices)
24. [Common Mistakes](#24-common-mistakes)
25. [Final Cheat Sheet](#25-final-cheat-sheet)

---

## 1. Introduction to SQL

**What is SQL?**  
SQL (Structured Query Language) is the standard language for managing and manipulating relational databases. Think of it as a way to talk to your database - you ask questions (queries) and get answers (results).

**Why Learn SQL?**
- **Universal Language:** Works with MySQL, PostgreSQL, SQL Server, Oracle, etc.
- **Data Retrieval:** Extract specific information from huge datasets
- **Data Manipulation:** Add, update, or delete records
- **Database Management:** Create and modify database structures
- **Data Analysis:** Perform calculations, summaries, and insights

**Real-World Analogy:** Imagine your database is a huge library. SQL is like asking the librarian:
- "Show me all books published after 2020" (SELECT with WHERE)
- "Count how many books are in the Fiction section" (COUNT with GROUP BY)
- "Add this new book to the Science section" (INSERT)

---

## 2. Database and Table Basics

**What is a Database?**  
A database is an organized collection of data stored electronically. It's like a digital filing cabinet where you store related information.

**Tables are the Heart of Databases**
- Each table stores information about one type of thing
- Example: `customers` table stores customer information, `orders` table stores order information
- Tables have **rows** (records) and **columns** (fields)

**Example Schema Used Throughout This Guide:**
```sql
-- Customers table structure
customer_id | first_name | last_name | email           | city   | created_at
----------- | ---------- | --------- | --------------- | ------ | ----------
1           | Aman       | Verma     | aman@example.com| Pune   | 2024-02-10
2           | Sara       | Shah      | sara@example.com| Mumbai | 2024-03-15

-- Orders table structure  
order_id | customer_id | amount | status   | order_date
-------- | ----------- | ------ | -------- | ----------
101      | 1           | 250.00 | COMPLETED| 2024-02-11
102      | 2           | 150.00 | PENDING  | 2024-03-16

-- Employees table structure
employee_id | first_name | last_name | department | salary | hire_date
----------- | ---------- | --------- | ---------- | ------ | ---------
1           | John       | One       | IT         | 60000  | 2024-01-02
2           | Sara       | Shah      | HR         | 45000  | 2024-03-03
```

**Key Concepts:**
- **Primary Key:** A unique identifier for each row (like a social security number for people)
- **Foreign Key:** A column that links to a primary key in another table (connects orders to customers)
- **Schema:** The structure of the database (what tables exist and how they're connected)

**Visual Representation:**
```
CUSTOMERS table          ORDERS table
customer_id (PK) ------> customer_id (FK)
first_name               order_id (PK)
last_name                amount
email                    status
```

---

## 3. CREATE TABLE

**What is CREATE TABLE?**  
This command creates a new, empty table in your database. You define:
- Table name
- Column names and their data types
- Constraints (rules for the data)

**Complete Example with Explanation:**
```sql
CREATE TABLE customers (
  -- SERIAL means auto-incrementing number (1, 2, 3...)
  -- PRIMARY KEY means this uniquely identifies each customer
  customer_id SERIAL PRIMARY KEY,
  
  -- TEXT means text data, NOT NULL means this field is required
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL,
  
  -- UNIQUE means no two customers can have the same email
  email TEXT UNIQUE NOT NULL,
  
  -- TEXT without NOT NULL means this field is optional
  city TEXT,
  
  -- DATE stores dates in YYYY-MM-DD format
  created_at DATE NOT NULL
);
```

**Common Data Types:**
- `INTEGER` or `INT` - Whole numbers (1, 2, 3)
- `DECIMAL` or `NUMERIC` - Decimal numbers (10.99, 3.14)
- `TEXT` or `VARCHAR` - Text data (names, descriptions)
- `DATE` - Dates only (2024-12-25)
- `TIMESTAMP` - Date and time (2024-12-25 14:30:00)
- `BOOLEAN` - True/False values

**📝 Trick: Always Start with a Plan**
Before creating tables, sketch on paper:
1. What data do you need to store?
2. What are the relationships between data?
3. What fields are required vs optional?

**🚨 Common Mistake: Forgetting Constraints**
```sql
-- BAD: No constraints
CREATE TABLE orders (
  order_id INT,
  amount DECIMAL
);
-- Problem: order_id could be NULL or duplicate!

-- GOOD: With constraints
CREATE TABLE orders (
  order_id SERIAL PRIMARY KEY,
  amount DECIMAL NOT NULL CHECK(amount > 0)
);
```

**✅ Best Practice:** Always define primary keys and NOT NULL constraints during table creation. It's much harder to add them later when you already have data.

---

## 4. INSERT INTO

**What is INSERT?**  
Adds new rows (records) to a table. Think of it as adding new entries to your spreadsheet.

**Basic Syntax:**
```sql
INSERT INTO table_name (column1, column2, ...)
VALUES (value1, value2, ...);
```

**Detailed Example:**
```sql
-- Insert one customer
INSERT INTO customers (first_name, last_name, email, city, created_at)
VALUES ('Aman', 'Verma', 'aman@example.com', 'Pune', '2024-02-10');

-- What happens in the database:
-- | customer_id | first_name | last_name | email           | city | created_at  |
-- | ----------- | ---------- | --------- | --------------- | ---- | ----------- |
-- | 1           | Aman       | Verma     | aman@example.com| Pune | 2024-02-10  |
```

**Inserting Multiple Rows at Once:**
```sql
-- Insert three employees in one command
INSERT INTO employees (first_name, last_name, email, department, salary, hire_date)
VALUES
('John', 'One', 'john1@example.com', 'IT', 60000, '2024-01-02'),
('Sara', 'Shah', 'sara@example.com', 'HR', 45000, '2024-03-03'),
('Mike', 'Brown', 'mike@example.com', 'Sales', 55000, '2024-04-01');
```

**📝 Trick: Always Specify Column Names**
```sql
-- RISKY: Works now, but breaks if table structure changes
INSERT INTO customers
VALUES ('Aman', 'Verma', 'aman@example.com', 'Pune', '2024-02-10');

-- BETTER: Explicit and clear
INSERT INTO customers (first_name, last_name, email, city, created_at)
VALUES ('Aman', 'Verma', 'aman@example.com', 'Pune', '2024-02-10');
```

**🚨 Common Mistake: Data Type Mismatch**
```sql
-- ERROR: '60000' looks like a number but is in quotes like text
INSERT INTO employees (salary) VALUES ('60000');

-- CORRECT: Numbers without quotes
INSERT INTO employees (salary) VALUES (60000);

-- CORRECT: Dates should be in quotes
INSERT INTO employees (hire_date) VALUES ('2024-01-02');
```

**✅ Best Practice:** Test your INSERT with a SELECT first to see what the data will look like.

---

## 5. SELECT Statement

**What is SELECT?**  
The most frequently used SQL command. It retrieves data from one or more tables. Think of it as asking questions to your database.

**Basic Syntax:**
```sql
SELECT column1, column2, ...
FROM table_name;
```

**Practical Examples:**
```sql
-- Get specific columns
SELECT first_name, email FROM customers;
-- Result: Shows only first names and emails

-- Get all columns (use sparingly!)
SELECT * FROM customers;
-- Result: Shows EVERY column for every customer

-- Add calculations
SELECT first_name, salary, salary * 0.10 AS bonus
FROM employees;
-- Result: Shows name, salary, and calculated 10% bonus
```

**Column Aliases (AS keyword):**
```sql
-- Make column names more readable
SELECT 
    first_name AS "First Name",
    last_name AS "Last Name",
    salary AS "Annual Salary"
FROM employees;
```

**📝 Trick: The SELECT Workflow**
When you run SELECT, here's what happens:
1. FROM: Database identifies which table(s) to use
2. WHERE: Filters rows (if you have WHERE clause)
3. SELECT: Chooses which columns to display
4. ORDER BY: Sorts results (if specified)

**🚨 Common Mistake: SELECT * in Production**
```sql
-- PROBLEM: Inefficient, especially with large tables
SELECT * FROM customers;

-- SOLUTION: Select only what you need
SELECT customer_id, first_name, email FROM customers;
```

**Why avoid SELECT *?**
1. **Performance:** More data = slower query
2. **Maintenance:** If table structure changes, your code might break
3. **Clarity:** Explicit column names show exactly what data you're using

**✅ Best Practice:** Write SELECT queries like you're telling someone exactly what information you want. Be specific!

---

## 6. WHERE Filtering

**What is WHERE?**  
Filters rows based on conditions. Only rows meeting the condition are returned. Think of it as applying a filter in Excel.

**Basic Examples:**
```sql
-- Find customers from a specific city
SELECT * FROM customers 
WHERE city = 'Pune';

-- Find high-value orders
SELECT * FROM orders 
WHERE amount > 500;

-- Find pending orders
SELECT * FROM orders 
WHERE status = 'PENDING';
```

**Multiple Conditions:**
```sql
-- AND: Both conditions must be true
SELECT * FROM customers 
WHERE city = 'Pune' AND created_at > '2024-01-01';

-- OR: Either condition can be true  
SELECT * FROM customers 
WHERE city = 'Pune' OR city = 'Mumbai';

-- Combining AND/OR (use parentheses!)
SELECT * FROM customers 
WHERE (city = 'Pune' OR city = 'Mumbai') 
  AND created_at > '2024-01-01';
```

**Special WHERE Operators:**
```sql
-- IN: Match any value in a list
SELECT * FROM customers 
WHERE city IN ('Pune', 'Mumbai', 'Delhi');

-- BETWEEN: Range of values (inclusive)
SELECT * FROM orders 
WHERE amount BETWEEN 100 AND 500;

-- LIKE: Pattern matching (case-sensitive in some databases)
SELECT * FROM customers 
WHERE email LIKE '%@gmail.com';  -- Ends with @gmail.com

SELECT * FROM customers 
WHERE first_name LIKE 'A%';  -- Starts with 'A'
```

**Working with NULL:**
```sql
-- WRONG: This won't find NULL values
SELECT * FROM customers WHERE city = NULL;

-- CORRECT: Special syntax for NULL
SELECT * FROM customers WHERE city IS NULL;

SELECT * FROM customers WHERE city IS NOT NULL;
```

**📝 Trick: The NULL Paradox**
NULL represents "unknown" or "missing" data. In SQL:
- NULL = NULL returns FALSE (not TRUE!)
- NULL != NULL returns FALSE (not TRUE!)
- Any comparison with NULL returns NULL (which is treated as FALSE)

**🚨 Common Mistake: String Comparison Issues**
```sql
-- May or may not work depending on database settings
SELECT * FROM customers WHERE first_name = 'AMAN';

-- Better approach for case-insensitive search
SELECT * FROM customers WHERE LOWER(first_name) = LOWER('AMAN');
```

**✅ Best Practice:** Test your WHERE conditions with a few sample rows first to ensure they work as expected.

---

## 7. ORDER BY Sorting

**What is ORDER BY?**  
Sorts the result set in ascending (A-Z, 1-10) or descending (Z-A, 10-1) order.

**Basic Examples:**
```sql
-- Sort by single column (ascending by default)
SELECT * FROM customers 
ORDER BY last_name;

-- Explicit ascending
SELECT * FROM customers 
ORDER BY last_name ASC;

-- Descending order
SELECT * FROM customers 
ORDER BY created_at DESC;

-- Sort by multiple columns
SELECT * FROM customers 
ORDER BY city ASC, last_name ASC;
-- First sorts by city, then within same city sorts by last name
```

**Practical Example with Data:**
```sql
-- Before sorting:
-- | first_name | city   | salary |
-- | ---------- | ------ | ------ |
-- | Aman       | Pune   | 50000  |
-- | Sara       | Mumbai | 60000  |
-- | Raj        | Pune   | 45000  |

SELECT first_name, city, salary 
FROM employees 
ORDER BY city, salary DESC;

-- After sorting:
-- | first_name | city   | salary |
-- | ---------- | ------ | ------ |
-- | Sara       | Mumbai | 60000  |
-- | Aman       | Pune   | 50000  |
-- | Raj        | Pune   | 45000  |
```

**Sorting by Column Position:**
```sql
-- Sort by the 2nd column in SELECT (city)
SELECT first_name, city, salary 
FROM employees 
ORDER BY 2;

-- Sort by 3rd column descending, then 1st column ascending
SELECT first_name, city, salary 
FROM employees 
ORDER BY 3 DESC, 1 ASC;
```

**📝 Trick: Performance Consideration**
Sorting large datasets can be slow. If you frequently sort by certain columns:
1. Add indexes on those columns
2. Use LIMIT to reduce the amount of data sorted
3. Consider whether you really need to sort all rows

**🚨 Common Mistake: Confusing ORDER BY with GROUP BY**
```sql
-- WRONG: Trying to sort groups
SELECT city, COUNT(*) 
FROM customers 
GROUP BY city 
ORDER BY COUNT(*);  -- This is actually correct!

-- The confusion: 
-- GROUP BY groups rows
-- ORDER BY sorts the final result
```

**✅ Best Practice:** Always use ORDER BY when you need specific ordering. Without it, SQL returns rows in whatever order it finds fastest, which can change between queries.

---

## 8. DISTINCT

**What is DISTINCT?**  
Removes duplicate rows from the result. Shows only unique values.

**Basic Examples:**
```sql
-- Get all unique cities from customers
SELECT DISTINCT city FROM customers;

-- Get unique combinations of city and country
SELECT DISTINCT city, country FROM customers;
```

**Visual Example:**
```sql
-- Table data:
-- | customer_id | city   |
-- | ----------- | ------ |
-- | 1           | Pune   |
-- | 2           | Mumbai |
-- | 3           | Pune   |
-- | 4           | Delhi  |
-- | 5           | Mumbai |

SELECT DISTINCT city FROM customers;
-- Result:
-- | city   |
-- | ------ |
-- | Pune   |
-- | Mumbai |
-- | Delhi  |
-- (Only 3 rows, duplicates removed)
```

**DISTINCT vs GROUP BY:**
```sql
-- These give similar results but are processed differently
SELECT DISTINCT city FROM customers;

SELECT city FROM customers GROUP BY city;
```

**📝 Trick: DISTINCT with Multiple Columns**
```sql
-- Shows unique combinations
SELECT DISTINCT first_name, last_name FROM customers;
-- If you have two "John Smith", only one appears
-- If you have "John Smith" and "John Doe", both appear
```

**🚨 Common Mistake: DISTINCT with Aggregates**
```sql
-- WRONG: DISTINCT inside COUNT doesn't do what you might think
SELECT COUNT(DISTINCT *) FROM customers;  -- Syntax error!

-- CORRECT: DISTINCT applies to specific columns
SELECT COUNT(DISTINCT city) FROM customers;  -- Counts unique cities

-- What you probably meant:
SELECT COUNT(*) FROM (SELECT DISTINCT city FROM customers) AS unique_cities;
```

**✅ Best Practice:** Use DISTINCT when you want to see unique values, not just to remove accidental duplicates from a bad query.

---

## 9. LIMIT and OFFSET

**What are LIMIT and OFFSET?**
- **LIMIT:** Restricts how many rows are returned
- **OFFSET:** Skips a specified number of rows before starting to return rows

**Perfect for Pagination!**
Think of a Google search results page:
- Page 1: Results 1-10 (LIMIT 10 OFFSET 0)
- Page 2: Results 11-20 (LIMIT 10 OFFSET 10)
- Page 3: Results 21-30 (LIMIT 10 OFFSET 20)

**Basic Examples:**
```sql
-- Get top 5 highest paid employees
SELECT * FROM employees 
ORDER BY salary DESC 
LIMIT 5;

-- Get next 5 (employees ranked 6-10)
SELECT * FROM employees 
ORDER BY salary DESC 
LIMIT 5 OFFSET 5;

-- Simple pagination pattern
SELECT * FROM products 
ORDER BY product_name 
LIMIT 20 OFFSET 40;  -- Page 3 if 20 items per page
```

**Alternative Syntax (some databases):**
```sql
-- MySQL, PostgreSQL
SELECT * FROM customers LIMIT 10 OFFSET 20;

-- SQL Server (different syntax)
SELECT * FROM customers 
ORDER BY customer_id 
OFFSET 20 ROWS 
FETCH NEXT 10 ROWS ONLY;
```

**📝 Trick: Always Use ORDER BY with LIMIT/OFFSET**
```sql
-- DANGEROUS: Without ORDER BY, you get random rows
SELECT * FROM customers LIMIT 10;

-- BETTER: Consistent, predictable results
SELECT * FROM customers 
ORDER BY customer_id 
LIMIT 10;
```

**🚨 Common Mistake: Performance with Large OFFSET**
```sql
-- SLOW: Database must count/skip 1,000,000 rows
SELECT * FROM large_table 
ORDER BY id 
LIMIT 10 OFFSET 1000000;

-- FASTER ALTERNATIVE: Seek method (if IDs are sequential)
SELECT * FROM large_table 
WHERE id > 1000000 
ORDER BY id 
LIMIT 10;
```

**✅ Best Practice:** For web applications, implement "keyset pagination" (WHERE id > last_seen_id) instead of OFFSET for better performance with large datasets.

---

## 10. Comparison and Logical Operators

**Comparison Operators:** Compare values
- `=` Equal to
- `!=` or `<>` Not equal to
- `>` Greater than
- `<` Less than
- `>=` Greater than or equal to
- `<=` Less than or equal to

**Logical Operators:** Combine conditions
- `AND` All conditions must be true
- `OR` At least one condition must be true
- `NOT` Reverses a condition

**Detailed Examples:**
```sql
-- Find employees in IT department earning more than 50000
SELECT * FROM employees 
WHERE department = 'IT' AND salary > 50000;

-- Find orders that are either PENDING or amount > 1000
SELECT * FROM orders 
WHERE status = 'PENDING' OR amount > 1000;

-- Find customers NOT from Pune or Mumbai
SELECT * FROM customers 
WHERE NOT (city = 'Pune' OR city = 'Mumbai');
-- Same as: WHERE city != 'Pune' AND city != 'Mumbai'
```

**Operator Precedence (Important!):**
SQL evaluates conditions in this order:
1. Parentheses `()`
2. `NOT`
3. `AND`
4. `OR`

```sql
-- These are DIFFERENT:
SELECT * FROM employees 
WHERE department = 'IT' OR department = 'HR' AND salary > 50000;
-- Means: (IT department) OR (HR department AND salary > 50000)

SELECT * FROM employees 
WHERE (department = 'IT' OR department = 'HR') AND salary > 50000;
-- Means: (IT or HR department) AND salary > 50000
```

**📝 Trick: Using BETWEEN for Ranges**
```sql
-- These are equivalent:
WHERE salary >= 30000 AND salary <= 50000;
WHERE salary BETWEEN 30000 AND 50000;  -- Cleaner!

-- Note: BETWEEN is INCLUSIVE (includes 30000 and 50000)
```

**📝 Trick: Short-circuit Evaluation**
```sql
-- When using OR with expensive functions, put likely-true condition first
WHERE city = 'Mumbai' OR expensive_calculation(column) = true;
-- If city is Mumbai, expensive_calculation won't be called
```

**🚨 Common Mistake: NULL with Comparisons**
```sql
-- These DON'T work with NULL:
SELECT * FROM customers WHERE city = NULL;  -- Always returns no rows
SELECT * FROM customers WHERE city != NULL; -- Always returns no rows

-- CORRECT:
SELECT * FROM customers WHERE city IS NULL;
SELECT * FROM customers WHERE city IS NOT NULL;
```

**✅ Best Practice:** Use parentheses generously with multiple AND/OR conditions to make your intent clear and avoid precedence confusion.

---

## 11. Aggregate Functions

**What are Aggregate Functions?**  
Functions that operate on multiple rows to return a single value. They "aggregate" or summarize data.

**Common Aggregate Functions:**
- `COUNT()` - Counts rows
- `SUM()` - Adds up values
- `AVG()` - Calculates average
- `MIN()` - Finds smallest value
- `MAX()` - Finds largest value

**Detailed Examples:**
```sql
-- Count total customers
SELECT COUNT(*) FROM customers;
-- Result: 150 (or whatever your total is)

-- Count non-NULL values in a column
SELECT COUNT(email) FROM customers;
-- Result: Counts only customers with email (skips NULLs)

-- Calculate average salary
SELECT AVG(salary) FROM employees;
-- Result: 52500.00 (example)

-- Find highest and lowest order amounts
SELECT MAX(amount), MIN(amount) FROM orders;
-- Result: | max | min |
--         | 999 | 50  |

-- Total sales
SELECT SUM(amount) FROM orders WHERE status = 'COMPLETED';
-- Result: Total of all completed orders
```

**COUNT Variations:**
```sql
-- Count all rows (including NULLs)
SELECT COUNT(*) FROM table;

-- Count non-NULL values in specific column
SELECT COUNT(column_name) FROM table;

-- Count distinct values
SELECT COUNT(DISTINCT city) FROM customers;
-- Result: Number of unique cities
```

**📝 Trick: Handling NULLs in Aggregates**
```sql
-- AVG ignores NULLs
-- Table: salaries = [10000, 20000, NULL, 30000]
SELECT AVG(salary) FROM employees;
-- Result: (10000 + 20000 + 30000) / 3 = 20000
-- NOT: (10000 + 20000 + 0 + 30000) / 4 = 15000

-- To include NULLs as 0:
SELECT AVG(COALESCE(salary, 0)) FROM employees;
```

**📝 Trick: Rounding Decimal Results**
```sql
-- AVG might give many decimal places
SELECT AVG(salary) FROM employees;  -- Result: 52500.000000

-- Round to 2 decimal places
SELECT ROUND(AVG(salary), 2) FROM employees;  -- Result: 52500.00
```

**🚨 Common Mistake: Mixing Aggregates with Non-Aggregates**
```sql
-- ERROR: Can't mix aggregate (COUNT) with non-aggregate (first_name)
SELECT first_name, COUNT(*) FROM customers;

-- CORRECT: Use GROUP BY
SELECT city, COUNT(*) FROM customers GROUP BY city;
```

**✅ Best Practice:** When using aggregates, always think about what level of summarization you need. Do you want one total number, or totals broken down by groups?

---

## 12. GROUP BY

**What is GROUP BY?**  
Groups rows that have the same values in specified columns, then allows you to perform aggregate calculations on each group.

**Think of it as:** Organizing data into buckets, then calculating something about each bucket.

**Basic Example:**
```sql
-- Count customers in each city
SELECT city, COUNT(*) AS customer_count
FROM customers
GROUP BY city;

-- Result might look like:
-- | city   | customer_count |
-- | ------ | -------------- |
-- | Pune   | 45             |
-- | Mumbai | 62             |
-- | Delhi  | 33             |
```

**Multiple Column GROUP BY:**
```sql
-- Count customers by city AND country
SELECT city, country, COUNT(*) AS customer_count
FROM customers
GROUP BY city, country;

-- This creates groups for each unique city-country combination
```

**Visual Explanation:**
```
Original data:
| customer | city   | amount |
| -------- | ------ | ------ |
| Aman     | Pune   | 100    |
| Sara     | Mumbai | 200    |
| Raj      | Pune   | 150    |
| Priya    | Mumbai | 250    |

After GROUP BY city:
Group "Pune": Aman (100), Raj (150)
Group "Mumbai": Sara (200), Priya (250)

SELECT city, SUM(amount) FROM orders GROUP BY city;
Result:
| city   | sum |
| ------ | --- |
| Pune   | 250 |
| Mumbai | 450 |
```

**📝 Trick: The Golden Rule of GROUP BY**
Every column in your SELECT that's not inside an aggregate function MUST appear in the GROUP BY clause.

```sql
-- ERROR: department isn't in GROUP BY or aggregate
SELECT department, first_name, AVG(salary)
FROM employees
GROUP BY department;

-- CORRECT: Either add to GROUP BY or remove from SELECT
SELECT department, AVG(salary)
FROM employees
GROUP BY department;
```

**📝 Trick: GROUP BY with Expressions**
```sql
-- Group by year of hire
SELECT EXTRACT(YEAR FROM hire_date) AS hire_year, 
       COUNT(*) AS employees_hired
FROM employees
GROUP BY EXTRACT(YEAR FROM hire_date);
```

**🚨 Common Mistake: Misunderstanding GROUP BY Order**
```sql
-- The order in GROUP BY matters for some databases
SELECT city, department, COUNT(*)
FROM employees
GROUP BY city, department;
-- Different from:
GROUP BY department, city;  -- Creates different groups
```

**✅ Best Practice:** Always visualize your data first. Ask: "What are my groups?" and "What do I want to calculate for each group?"

---

## 13. HAVING

**What is HAVING?**  
Filters groups created by GROUP BY. WHERE filters rows before grouping, HAVING filters groups after grouping.

**The SQL Order of Execution:**
1. FROM - Choose tables
2. WHERE - Filter rows
3. GROUP BY - Group rows
4. HAVING - Filter groups
5. SELECT - Choose columns
6. ORDER BY - Sort results

**Basic Example:**
```sql
-- Find cities with more than 50 customers
SELECT city, COUNT(*) AS customer_count
FROM customers
GROUP BY city
HAVING COUNT(*) > 50;

-- Equivalent to: "Show me cities where the customer count > 50"
```

**HAVING vs WHERE Comparison:**
```sql
-- WHERE filters individual rows BEFORE grouping
SELECT city, AVG(salary)
FROM employees
WHERE department != 'Intern'  -- Exclude interns from calculation
GROUP BY city;

-- HAVING filters groups AFTER grouping  
SELECT city, AVG(salary)
FROM employees
GROUP BY city
HAVING AVG(salary) > 50000;  -- Only show cities with avg salary > 50k
```

**Practical Examples:**
```sql
-- Products with total sales over 1000 units
SELECT product_id, SUM(quantity) AS total_sold
FROM order_items
GROUP BY product_id
HAVING SUM(quantity) > 1000;

-- Departments with more than 5 employees earning over 40000
SELECT department, COUNT(*) AS high_earners
FROM employees
WHERE salary > 40000
GROUP BY department
HAVING COUNT(*) > 5;
```

**📝 Trick: You can use aliases in HAVING (in most databases)**
```sql
SELECT city, COUNT(*) AS cnt
FROM customers
GROUP BY city
HAVING cnt > 50;  -- Using alias 'cnt' instead of COUNT(*)
```

**📝 Trick: Multiple HAVING Conditions**
```sql
SELECT city, AVG(salary) AS avg_sal, COUNT(*) AS emp_count
FROM employees
GROUP BY city
HAVING AVG(salary) > 50000 
   AND COUNT(*) > 10;
-- Cities with avg salary > 50k AND more than 10 employees
```

**🚨 Common Mistake: Using WHERE for Aggregate Conditions**
```sql
-- ERROR: Can't use aggregate in WHERE
SELECT city, AVG(salary)
FROM employees
WHERE AVG(salary) > 50000  -- WRONG!
GROUP BY city;

-- CORRECT: Use HAVING
SELECT city, AVG(salary)
FROM employees
GROUP BY city
HAVING AVG(salary) > 50000;  -- RIGHT!
```

**✅ Best Practice:** Use HAVING only when you need to filter based on aggregate calculations. For regular column filters, use WHERE (it's more efficient).

---

## 14. UPDATE

**What is UPDATE?**  
Modifies existing data in a table. Changes values in one or more columns for rows that match a condition.

**Basic Syntax:**
```sql
UPDATE table_name
SET column1 = value1, column2 = value2, ...
WHERE condition;
```

**Practical Examples:**
```sql
-- Give all IT employees a 10% raise
UPDATE employees
SET salary = salary * 1.10
WHERE department = 'IT';

-- Update multiple columns at once
UPDATE customers
SET city = 'Mumbai', 
    updated_at = CURRENT_DATE
WHERE customer_id = 123;

-- Update based on calculation from another column
UPDATE orders
SET total = subtotal + tax + shipping
WHERE status = 'PENDING';
```

**📝 Trick: The Safety Checklist Before UPDATE**
Always follow these steps:
```sql
-- 1. First, SELECT to see what will be affected
SELECT * FROM employees 
WHERE department = 'IT';

-- 2. Check the count
SELECT COUNT(*) FROM employees 
WHERE department = 'IT';

-- 3. Write your UPDATE with the same WHERE
UPDATE employees
SET salary = salary * 1.10
WHERE department = 'IT';

-- 4. Verify the change
SELECT * FROM employees 
WHERE department = 'IT' 
LIMIT 5;
```

**📝 Trick: Update from Another Table**
```sql
-- Update employee salaries based on department averages
UPDATE employees e
SET salary = (
  SELECT AVG(salary) 
  FROM employees 
  WHERE department = e.department
)
WHERE salary < 30000;
```

**🚨 Common Mistake: Forgetting the WHERE Clause**
```sql
-- DANGEROUS: Updates ALL rows in the table!
UPDATE employees
SET salary = salary * 1.10;
-- Unless you really mean to give everyone a raise!

-- Always double-check: "Is my WHERE clause correct?"
```

**🚨 Common Mistake: Multiple Updates Causing Conflicts**
```sql
-- Problem: This might not give expected results
UPDATE accounts
SET balance = balance - 100
WHERE account_id = 1;

UPDATE accounts  
SET balance = balance + 100
WHERE account_id = 2;
-- What if the first UPDATE fails? Use transactions instead:

BEGIN TRANSACTION;
UPDATE accounts SET balance = balance - 100 WHERE account_id = 1;
UPDATE accounts SET balance = balance + 100 WHERE account_id = 2;
COMMIT;
-- Now both succeed or both fail together
```

**✅ Best Practice:** Test UPDATE statements on a backup or test database first. Consider using transactions for multiple related updates.

---

## 15. DELETE

**What is DELETE?**  
Removes rows from a table. Use with extreme caution!

**Basic Syntax:**
```sql
DELETE FROM table_name
WHERE condition;
```

**Practical Examples:**
```sql
-- Delete cancelled orders older than 1 year
DELETE FROM orders
WHERE status = 'CANCELLED' 
  AND order_date < CURRENT_DATE - INTERVAL '1 year';

-- Delete a specific customer
DELETE FROM customers
WHERE customer_id = 456;

-- Delete all test users
DELETE FROM users
WHERE email LIKE '%@test.com';
```

**📝 Trick: Soft Delete vs Hard Delete**
Instead of physically deleting, consider "soft delete":
```sql
-- Add an 'is_active' or 'deleted_at' column
ALTER TABLE customers ADD COLUMN is_active BOOLEAN DEFAULT TRUE;

-- "Delete" by marking as inactive
UPDATE customers 
SET is_active = FALSE 
WHERE customer_id = 123;

-- View only active customers
SELECT * FROM customers WHERE is_active = TRUE;

-- Real delete only during cleanup
DELETE FROM customers 
WHERE is_active = FALSE 
  AND updated_at < CURRENT_DATE - INTERVAL '5 years';
```

**📝 Trick: Delete with LIMIT (some databases)**
```sql
-- Delete in batches to avoid locking table
DELETE FROM large_table
WHERE condition
LIMIT 1000;
-- Run repeatedly until no rows affected
```

**🚨 Common Mistake: No WHERE Clause (Disaster!)**
```sql
-- THIS DELETES EVERYTHING!
DELETE FROM customers;
-- No warning, no confirmation - just gone!

-- Safety first: Write WHERE first, then go back to add DELETE
-- 1. Write: FROM customers WHERE customer_id = 123
-- 2. Add DELETE at beginning
-- 3. Double-check before executing
```

**🚨 Common Mistake: Foreign Key Violations**
```sql
-- ERROR if other tables reference this customer
DELETE FROM customers WHERE customer_id = 123;

-- Solutions:
-- 1. Delete related records first
DELETE FROM orders WHERE customer_id = 123;
DELETE FROM customers WHERE customer_id = 123;

-- 2. Use CASCADE delete (defined in foreign key)
-- 3. Set to NULL instead
```

**✅ Best Practice:** Before DELETE, always:
1. Backup the data
2. Run a SELECT with the same WHERE to see what will be deleted
3. Consider if you should archive instead of delete
4. Use transactions for multiple deletes

---

## 16. ALTER TABLE

**What is ALTER TABLE?**  
Modifies the structure of an existing table: add columns, change data types, add constraints, etc.

**Common Operations:**

**Add a Column:**
```sql
ALTER TABLE employees
ADD COLUMN bonus DECIMAL(10,2) DEFAULT 0.00;

-- With NOT NULL constraint (if column has no NULLs)
ALTER TABLE employees
ADD COLUMN middle_name TEXT;
-- First add without NOT NULL
UPDATE employees SET middle_name = '' WHERE middle_name IS NULL;
-- Then add NOT NULL constraint
ALTER TABLE employees
ALTER COLUMN middle_name SET NOT NULL;
```

**Modify a Column:**
```sql
-- Change data type
ALTER TABLE employees
ALTER COLUMN salary TYPE DECIMAL(12,2);

-- Add NOT NULL constraint
ALTER TABLE employees
ALTER COLUMN email SET NOT NULL;

-- Remove NOT NULL constraint  
ALTER TABLE employees
ALTER COLUMN city DROP NOT NULL;

-- Set default value
ALTER TABLE employees
ALTER COLUMN hire_date SET DEFAULT CURRENT_DATE;
```

**Drop a Column:**
```sql
ALTER TABLE customers
DROP COLUMN old_phone_number;

-- Some databases require CASCADE if other objects depend on it
ALTER TABLE customers
DROP COLUMN phone_number CASCADE;
```

**Rename:**
```sql
ALTER TABLE customers
RENAME COLUMN cust_name TO customer_name;

ALTER TABLE cust
RENAME TO customers;
```

**Add Constraints:**
```sql
-- Add primary key
ALTER TABLE orders
ADD PRIMARY KEY (order_id);

-- Add foreign key
ALTER TABLE orders
ADD CONSTRAINT fk_customer
FOREIGN KEY (customer_id) REFERENCES customers(customer_id);

-- Add unique constraint
ALTER TABLE employees
ADD CONSTRAINT unique_email UNIQUE (email);

-- Add check constraint
ALTER TABLE orders
ADD CONSTRAINT positive_amount CHECK (amount > 0);
```

**📝 Trick: Changing Column Type Safely**
```sql
-- When changing VARCHAR length to smaller:
-- 1. Check if any data will be truncated
SELECT MAX(LENGTH(column_name)) FROM table_name;

-- 2. If safe, proceed
ALTER TABLE table_name
ALTER COLUMN column_name TYPE VARCHAR(50);

-- For incompatible type changes, create new column:
ALTER TABLE table ADD COLUMN new_column NEW_TYPE;
UPDATE table SET new_column = CAST(old_column AS NEW_TYPE);
ALTER TABLE table DROP COLUMN old_column;
ALTER TABLE table RENAME COLUMN new_column TO old_column;
```

**🚨 Common Mistake: ALTER on Large Tables**
```sql
-- Adding NOT NULL or changing type on large tables can:
-- 1. Lock the table (blocking reads/writes)
-- 2. Take a long time
-- 3. Use lots of disk space

-- Solutions:
-- 1. Do it during maintenance window
-- 2. Use tools like pg_repack (PostgreSQL) or pt-online-schema-change (MySQL)
-- 3. For NOT NULL, add as nullable first, update data, then set NOT NULL
```

**✅ Best Practice:** Always test ALTER TABLE statements on a development/staging database first. Document schema changes for your team.

---

## 17. Joins

**What are Joins?**  
Combine rows from two or more tables based on a related column. Essential for working with relational data.

**The 5 Main Join Types:**

### 1. INNER JOIN
Returns only matching rows from both tables.
```sql
SELECT c.first_name, o.amount
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id;
```
**Result:** Customers who have placed orders (intersection).

### 2. LEFT JOIN (LEFT OUTER JOIN)
All rows from left table, matching rows from right table (NULLs if no match).
```sql
SELECT c.first_name, o.order_id
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;
```
**Result:** ALL customers, with their orders if they have any.

### 3. RIGHT JOIN (RIGHT OUTER JOIN)
All rows from right table, matching rows from left table.
```sql
SELECT c.first_name, o.order_id
FROM customers c
RIGHT JOIN orders o ON c.customer_id = o.customer_id;
```
**Result:** ALL orders, with customer info if available.

### 4. FULL JOIN (FULL OUTER JOIN)
All rows when there's a match in either table.
```sql
SELECT c.first_name, o.order_id
FROM customers c
FULL JOIN orders o ON c.customer_id = o.customer_id;
```
**Result:** All customers AND all orders.

### 5. CROSS JOIN
Every row from first table combined with every row from second table.
```sql
SELECT c.first_name, p.product_name
FROM customers c
CROSS JOIN products p;
```
**Result:** Cartesian product (customers × products). Rarely used intentionally.

**Visual Explanation:**
```
Customers (Left)     Orders (Right)
+----+-------+      +----+------------+
| id | name  |      | id | customer_id|
+----+-------+      +----+------------+
| 1  | Aman  |      | 101| 1          |
| 2  | Sara  |      | 102| 3          |
| 3  | Raj   |      +----+------------+
+----+-------+

INNER JOIN (id matches customer_id):
Aman (id 1) ↔ Order 101
Raj (id 3)  ↔ Order 102
Sara (id 2) ↔ No match (excluded)

LEFT JOIN:
Aman  ↔ Order 101
Sara  ↔ NULL (no order)
Raj   ↔ Order 102
```

**Multiple Joins:**
```sql
-- Connect customers → orders → order_items → products
SELECT 
    c.first_name,
    o.order_date,
    p.product_name,
    oi.quantity
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
INNER JOIN order_items oi ON o.order_id = oi.order_id
INNER JOIN products p ON oi.product_id = p.product_id;
```

**📝 Trick: Filtering Joined Tables**
```sql
-- WRONG: Filter in WHERE loses LEFT JOIN benefit
SELECT c.name, o.amount
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.amount > 100;  -- Excludes customers with no orders!

-- CORRECT: Filter in JOIN condition
SELECT c.name, o.amount
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id 
                   AND o.amount > 100;
-- Keeps all customers, shows orders > 100 or NULL
```

**📝 Trick: Self Join (joining table to itself)**
```sql
-- Find employees and their managers (both in employees table)
SELECT 
    e.first_name AS employee,
    m.first_name AS manager
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.employee_id;
```

**🚨 Common Mistake: Missing or Wrong JOIN Condition**
```sql
-- DANGEROUS: Creates Cartesian product (n × m rows)
SELECT * FROM customers, orders;
-- 100 customers × 1000 orders = 100,000 rows!

-- Also bad: Wrong column relationship
SELECT * 
FROM customers c
JOIN orders o ON c.customer_id = o.order_id;  -- Wrong relationship!
```

**🚨 Common Mistake: Multiple Many-to-Many Relationships**
```sql
-- If customers can have multiple addresses and orders:
SELECT c.name, o.amount, a.city
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN addresses a ON c.customer_id = a.customer_id;
-- Creates duplicate rows! Use DISTINCT or aggregate.

-- Better: Address for shipping vs billing?
SELECT c.name, o.amount, sa.city AS ship_city, ba.city AS bill_city
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN addresses sa ON o.shipping_address_id = sa.address_id
JOIN addresses ba ON o.billing_address_id = ba.address_id;
```

**✅ Best Practice:** Always:
1. Use table aliases for readability
2. Specify JOIN type explicitly (INNER, LEFT, etc.)
3. Test joins with small datasets first
4. Check for duplicate rows in results

---

## 18. Subqueries

**What are Subqueries?**  
A query nested inside another query. Also called inner queries or nested queries.

### Types of Subqueries:

#### 1. Scalar Subquery
Returns a single value (one row, one column).
```sql
-- Find employees earning more than average
SELECT * FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);
-- The subquery returns one number: average salary
```

#### 2. Row Subquery  
Returns a single row with multiple columns.
```sql
-- Find employee with highest salary
SELECT * FROM employees
WHERE (salary, hire_date) = (
  SELECT MAX(salary), MIN(hire_date) 
  FROM employees
);
```

#### 3. Column Subquery
Returns a single column with multiple rows.
```sql
-- Find customers who placed orders
SELECT * FROM customers
WHERE customer_id IN (
  SELECT DISTINCT customer_id FROM orders
);
```

#### 4. Table Subquery
Returns a table (multiple rows and columns).
```sql
-- Use in FROM clause
SELECT dept_avg.department, dept_avg.avg_salary
FROM (
  SELECT department, AVG(salary) AS avg_salary
  FROM employees
  GROUP BY department
) AS dept_avg
WHERE dept_avg.avg_salary > 50000;
```

### Correlated vs Non-Correlated Subqueries:

**Non-Correlated:** Inner query can run independently.
```sql
SELECT * FROM products
WHERE price > (SELECT AVG(price) FROM products);
-- Inner query doesn't reference outer query
```

**Correlated:** Inner query references outer query.
```sql
-- Find employees earning more than their department average
SELECT * FROM employees e1
WHERE salary > (
  SELECT AVG(salary) 
  FROM employees e2 
  WHERE e2.department = e1.department  -- Correlation
);
```

### Common Subquery Operators:

**IN / NOT IN:**
```sql
-- Customers with orders
SELECT * FROM customers
WHERE customer_id IN (SELECT customer_id FROM orders);

-- Customers without orders
SELECT * FROM customers
WHERE customer_id NOT IN (SELECT customer_id FROM orders);
-- WARNING: Returns no rows if subquery returns NULL!
```

**EXISTS / NOT EXISTS:**
```sql
-- More efficient than IN for large datasets
SELECT * FROM customers c
WHERE EXISTS (
  SELECT 1 FROM orders o 
  WHERE o.customer_id = c.customer_id
);

-- Customers without orders (handles NULLs correctly)
SELECT * FROM customers c
WHERE NOT EXISTS (
  SELECT 1 FROM orders o 
  WHERE o.customer_id = c.customer_id
);
```

**ANY/SOME / ALL:**
```sql
-- Employees earning more than ANY IT employee
SELECT * FROM employees
WHERE salary > ANY (
  SELECT salary FROM employees WHERE department = 'IT'
);

-- Employees earning more than ALL IT employees
SELECT * FROM employees
WHERE salary > ALL (
  SELECT salary FROM employees WHERE department = 'IT'
);
```

**📝 Trick: Subquery vs JOIN**
Often you can rewrite subqueries as JOINs:
```sql
-- Subquery
SELECT * FROM customers
WHERE customer_id IN (
  SELECT customer_id FROM orders WHERE amount > 1000
);

-- JOIN equivalent
SELECT DISTINCT c.*
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.amount > 1000;
```
**Rule of thumb:** JOINs are often faster, but subqueries can be more readable.

**📝 Trick: Optimizing Correlated Subqueries**
```sql
-- Slow: Runs subquery for each row
SELECT name, 
       (SELECT COUNT(*) FROM orders o WHERE o.customer_id = c.customer_id)
FROM customers c;

-- Faster: Use LEFT JOIN with aggregation
SELECT c.name, COUNT(o.order_id)
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name;
```

**🚨 Common Mistake: Subquery Returns Multiple Rows**
```sql
-- ERROR: Subquery returns more than one row
SELECT * FROM employees
WHERE salary = (
  SELECT salary FROM employees WHERE department = 'IT'
);

-- FIX: Use IN instead of =
SELECT * FROM employees
WHERE salary IN (
  SELECT salary FROM employees WHERE department = 'IT'
);
```

**🚨 Common Mistake: Performance with NOT IN and NULLs**
```sql
-- DANGEROUS: Returns no rows if subquery has NULLs
SELECT * FROM table1
WHERE id NOT IN (SELECT id FROM table2);
-- If table2 has any NULL id, whole query returns nothing

-- SAFER: Use NOT EXISTS
SELECT * FROM table1 t1
WHERE NOT EXISTS (SELECT 1 FROM table2 t2 WHERE t2.id = t1.id);
```

**✅ Best Practice:**
- Use EXISTS instead of IN when checking for existence
- Consider rewriting correlated subqueries as JOINs
- Test subqueries independently first
- Be mindful of NULL handling

---

## 19. CASE Expression

**What is CASE?**  
SQL's version of IF-THEN-ELSE logic. Creates conditional logic within queries.

**Two Syntax Forms:**

### 1. Simple CASE (compares a single value)
```sql
SELECT first_name,
  CASE department
    WHEN 'IT' THEN 'Technology'
    WHEN 'HR' THEN 'Human Resources'
    WHEN 'Sales' THEN 'Sales & Marketing'
    ELSE 'Other Department'
  END AS department_name
FROM employees;
```

### 2. Searched CASE (evaluates conditions)
```sql
SELECT first_name, salary,
  CASE
    WHEN salary > 70000 THEN 'High'
    WHEN salary > 50000 THEN 'Medium'
    WHEN salary > 30000 THEN 'Low'
    ELSE 'Very Low'
  END AS salary_level
FROM employees;
```

**Common Uses:**

**In SELECT:**
```sql
-- Categorize orders
SELECT order_id, amount,
  CASE
    WHEN amount > 1000 THEN 'Large'
    WHEN amount > 500 THEN 'Medium'
    ELSE 'Small'
  END AS order_size
FROM orders;
```

**In ORDER BY:**
```sql
-- Custom sorting: Show pending orders first
SELECT * FROM orders
ORDER BY 
  CASE status
    WHEN 'PENDING' THEN 1
    WHEN 'PROCESSING' THEN 2
    WHEN 'COMPLETED' THEN 3
    ELSE 4
  END;
```

**In UPDATE:**
```sql
-- Give different raises based on department
UPDATE employees
SET salary = salary * 
  CASE department
    WHEN 'IT' THEN 1.10
    WHEN 'Sales' THEN 1.15
    ELSE 1.05
  END;
```

**In Aggregate Functions:**
```sql
-- Count orders by size
SELECT 
  COUNT(CASE WHEN amount > 1000 THEN 1 END) AS large_orders,
  COUNT(CASE WHEN amount BETWEEN 500 AND 1000 THEN 1 END) AS medium_orders,
  COUNT(CASE WHEN amount < 500 THEN 1 END) AS small_orders
FROM orders;
```

**Multiple Conditions:**
```sql
SELECT first_name, salary, department,
  CASE
    WHEN department = 'IT' AND salary > 70000 THEN 'Senior Tech'
    WHEN department = 'IT' AND salary > 50000 THEN 'Junior Tech'
    WHEN department = 'Sales' AND salary > 60000 THEN 'Senior Sales'
    WHEN department = 'Sales' THEN 'Junior Sales'
    ELSE 'Other'
  END AS employee_category
FROM employees;
```

**📝 Trick: CASE with ELSE NULL**
```sql
-- ELSE is optional, defaults to NULL
SELECT 
  CASE WHEN score > 90 THEN 'A' END AS grade
FROM students;
-- Scores <= 90 will show NULL

-- Explicit NULL for clarity
SELECT 
  CASE 
    WHEN score > 90 THEN 'A'
    ELSE NULL  -- Makes intention clear
  END AS grade
FROM students;
```

**📝 Trick: Nested CASE**
```sql
-- Use judiciously - can get complex
SELECT 
  CASE 
    WHEN department = 'IT' THEN
      CASE 
        WHEN salary > 80000 THEN 'Principal Engineer'
        WHEN salary > 60000 THEN 'Senior Engineer'
        ELSE 'Engineer'
      END
    WHEN department = 'Sales' THEN
      CASE
        WHEN salary > 70000 THEN 'Sales Director'
        ELSE 'Sales Representative'
      END
    ELSE 'Staff'
  END AS title
FROM employees;
```

**🚨 Common Mistake: Overlapping Conditions**
```sql
-- Conditions are evaluated in order
SELECT 
  CASE
    WHEN salary > 30000 THEN 'Low'        -- ALL salaries > 30000 go here!
    WHEN salary > 50000 THEN 'Medium'     -- Never reached!
    WHEN salary > 70000 THEN 'High'       -- Never reached!
    ELSE 'Very Low'
  END
FROM employees;

-- CORRECT: Check highest first
SELECT 
  CASE
    WHEN salary > 70000 THEN 'High'
    WHEN salary > 50000 THEN 'Medium'
    WHEN salary > 30000 THEN 'Low'
    ELSE 'Very Low'
  END
FROM employees;
```

**🚨 Common Mistake: Forgetting ELSE**
```sql
-- Without ELSE, unexpected NULLs appear
SELECT 
  CASE status
    WHEN 'P' THEN 'Pending'
    WHEN 'C' THEN 'Completed'
    -- What about 'X', 'A', NULL, etc.?
  END AS status_text
FROM orders;

-- Safer with ELSE
SELECT 
  CASE status
    WHEN 'P' THEN 'Pending'
    WHEN 'C' THEN 'Completed'
    ELSE 'Unknown'
  END AS status_text
FROM orders;
```

**✅ Best Practice:**
- Always list conditions from most specific to most general
- Include ELSE clause to handle unexpected values
- Keep CASE statements simple; consider moving complex logic to application code
- Test with sample data covering all possible cases

---

## 20. Constraints

**What are Constraints?**  
Rules enforced on data columns to maintain data integrity and accuracy.

### 1. NOT NULL
Ensures a column cannot have NULL values.
```sql
CREATE TABLE customers (
  customer_id SERIAL PRIMARY KEY,
  email TEXT NOT NULL,  -- Must have email
  phone TEXT           -- Can be NULL
);

-- Add later
ALTER TABLE customers
ALTER COLUMN phone SET NOT NULL;
```

### 2. UNIQUE
Ensures all values in a column are different.
```sql
CREATE TABLE users (
  user_id SERIAL PRIMARY KEY,
  username TEXT UNIQUE,  -- No duplicate usernames
  email TEXT UNIQUE      -- No duplicate emails
);

-- Composite unique constraint
CREATE TABLE enrollments (
  student_id INT,
  course_id INT,
  UNIQUE(student_id, course_id)  -- Can't enroll same student twice
);
```

### 3. PRIMARY KEY
Uniquely identifies each row. Combination of NOT NULL and UNIQUE.
```sql
CREATE TABLE products (
  product_id SERIAL PRIMARY KEY,  -- Auto-incrementing primary key
  name TEXT NOT NULL
);

-- Composite primary key
CREATE TABLE order_items (
  order_id INT,
  product_id INT,
  quantity INT,
  PRIMARY KEY (order_id, product_id)  -- Both together are unique
);
```

### 4. FOREIGN KEY
Links two tables, ensures referential integrity.
```sql
CREATE TABLE orders (
  order_id SERIAL PRIMARY KEY,
  customer_id INT,
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- With actions on delete/update
CREATE TABLE order_items (
  order_id INT,
  FOREIGN KEY (order_id) REFERENCES orders(order_id)
    ON DELETE CASCADE     -- Delete order_items when order is deleted
    ON UPDATE CASCADE     -- Update order_id in order_items if changed
);
```

**Foreign Key Actions:**
- `NO ACTION` (default) - Error if violates constraint
- `RESTRICT` - Similar to NO ACTION
- `CASCADE` - Delete/update child rows
- `SET NULL` - Set foreign key to NULL
- `SET DEFAULT` - Set to default value

### 5. CHECK
Ensures all values satisfy a condition.
```sql
CREATE TABLE employees (
  employee_id SERIAL PRIMARY KEY,
  salary DECIMAL CHECK (salary > 0),  -- Positive salary
  age INT CHECK (age >= 18),          -- Adults only
  email TEXT CHECK (email LIKE '%@%.%')  -- Basic email format
);

-- Complex check
CREATE TABLE orders (
  order_date DATE,
  delivery_date DATE,
  CHECK (delivery_date >= order_date)  -- Can't deliver before order
);
```

### 6. DEFAULT
Sets a default value when no value is specified.
```sql
CREATE TABLE orders (
  order_id SERIAL PRIMARY KEY,
  order_date DATE DEFAULT CURRENT_DATE,
  status TEXT DEFAULT 'PENDING',
  created_at TIMESTAMP DEFAULT NOW()
);
```

**📝 Trick: Adding Constraints After Table Creation**
```sql
-- Add NOT NULL
ALTER TABLE employees ALTER COLUMN email SET NOT NULL;

-- Add UNIQUE
ALTER TABLE users ADD CONSTRAINT unique_username UNIQUE (username);

-- Add CHECK
ALTER TABLE products ADD CONSTRAINT positive_price CHECK (price > 0);

-- Add FOREIGN KEY
ALTER TABLE orders 
ADD CONSTRAINT fk_customer 
FOREIGN KEY (customer_id) REFERENCES customers(customer_id);
```

**📝 Trick: Disabling Constraints (for data migration)**
```sql
-- Some databases allow temporarily disabling constraints
ALTER TABLE table_name DISABLE TRIGGER ALL;  -- PostgreSQL
SET FOREIGN_KEY_CHECKS = 0;  -- MySQL

-- Do your data load/migration

SET FOREIGN_KEY_CHECKS = 1;  -- Re-enable
-- Then validate data: ALTER TABLE table_name VALIDATE CONSTRAINT constraint_name;
```

**🚨 Common Mistake: Circular Foreign Key References**
```sql
-- Table A references Table B
CREATE TABLE departments (
  dept_id INT PRIMARY KEY,
  manager_id INT REFERENCES employees(emp_id)
);

-- Table B references Table A  
CREATE TABLE employees (
  emp_id INT PRIMARY KEY,
  dept_id INT REFERENCES departments(dept_id)
);

-- Solution: Add one foreign key later, or use deferred constraints
ALTER TABLE departments 
ADD CONSTRAINT fk_manager 
FOREIGN KEY (manager_id) REFERENCES employees(emp_id) 
DEFERRABLE INITIALLY DEFERRED;
```

**🚨 Common Mistake: CHECK Constraints and NULL**
```sql
-- NULL passes CHECK constraints!
CREATE TABLE test (
  value INT CHECK (value > 10)
);

INSERT INTO test VALUES (NULL);  -- This works!
-- Because NULL > 10 evaluates to NULL (not FALSE)

-- To reject NULLs, add NOT NULL
CREATE TABLE test (
  value INT NOT NULL CHECK (value > 10)
);
```

**✅ Best Practice:**
- Name your constraints for easier management
- Use foreign keys to maintain referential integrity
- Add constraints at table creation when possible
- Test constraints with edge cases (NULLs, empty strings, etc.)

---

## 21. Views

**What are Views?**  
Virtual tables based on the result of a SQL query. They don't store data, just the query definition.

**Creating Views:**
```sql
-- Simple view
CREATE VIEW active_customers AS
SELECT * FROM customers 
WHERE is_active = TRUE;

-- Complex view with joins
CREATE VIEW order_summary AS
SELECT 
    o.order_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    o.order_date,
    o.amount,
    o.status
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id;

-- View with calculations
CREATE VIEW employee_stats AS
SELECT 
    department,
    COUNT(*) AS employee_count,
    AVG(salary) AS avg_salary,
    MAX(salary) AS max_salary,
    MIN(salary) AS min_salary
FROM employees
GROUP BY department;
```

**Using Views:**
```sql
-- Query like a regular table
SELECT * FROM active_customers 
WHERE city = 'Pune';

-- Join views with tables
SELECT v.*, o.order_date
FROM active_customers v
JOIN orders o ON v.customer_id = o.customer_id;

-- Update through view (with limitations)
UPDATE active_customers
SET city = 'Mumbai'
WHERE customer_id = 123;
```

**Updating and Dropping Views:**
```sql
-- Replace a view
CREATE OR REPLACE VIEW active_customers AS
SELECT * FROM customers 
WHERE is_active = TRUE 
  AND created_at > '2023-01-01';

-- Drop a view
DROP VIEW IF EXISTS old_view_name;
```

**Materialized Views (some databases):**
```sql
-- Stores actual data, needs refreshing
CREATE MATERIALIZED VIEW monthly_sales AS
SELECT 
    DATE_TRUNC('month', order_date) AS month,
    SUM(amount) AS total_sales
FROM orders
GROUP BY DATE_TRUNC('month', order_date);

-- Refresh when data changes
REFRESH MATERIALIZED VIEW monthly_sales;
```

**📝 Trick: Views for Security**
```sql
-- Hide sensitive columns
CREATE VIEW public_employee_info AS
SELECT 
    employee_id,
    first_name,
    last_name,
    department,
    hire_date
FROM employees;
-- Salary and other sensitive data is hidden

-- Grant access to view instead of table
GRANT SELECT ON public_employee_info TO analyst_role;
```

**📝 Trick: Views for Simplifying Complex Queries**
```sql
-- Instead of writing this complex join everywhere:
SELECT [complex query with multiple joins]

-- Create a view:
CREATE VIEW simplified_data AS
SELECT [complex query with multiple joins];

-- Then just use:
SELECT * FROM simplified_data WHERE condition;
```

**🚨 Common Mistake: Performance with Nested Views**
```sql
-- View on view on view...
CREATE VIEW v1 AS SELECT * FROM table WHERE condition;
CREATE VIEW v2 AS SELECT * FROM v1 JOIN another_table;
CREATE VIEW v3 AS SELECT * FROM v2 WHERE another_condition;

-- Querying v3 can be slow! Each layer adds overhead.

-- Better: Flatten when possible
CREATE VIEW v3_flat AS
SELECT * 
FROM table t
JOIN another_table a ON t.id = a.table_id
WHERE t.condition 
  AND a.another_condition;
```

**🚨 Common Mistake: Updating Through Complex Views**
```sql
-- Not all views are updatable
CREATE VIEW order_details AS
SELECT o.*, c.name
FROM orders o JOIN customers c ON o.customer_id = c.customer_id;

-- This might fail:
UPDATE order_details SET amount = 100 WHERE order_id = 1;
-- Because: Which table does 'amount' belong to? Usually okay.
-- But: UPDATE order_details SET name = 'New Name' would definitely fail.

-- Rules for updatable views (varies by database):
-- 1. Based on one table (no joins)
-- 2. No aggregates, GROUP BY, HAVING
-- 3. No DISTINCT
-- 4. No window functions
```

**✅ Best Practice:**
- Use views to simplify complex queries
- Use views for security (column/row level)
- Document what each view provides
- Be cautious with updateable views
- Consider materialized views for expensive aggregations

---

## 22. Indexing Basics

**What are Indexes?**  
Database structures that improve data retrieval speed. Like a book's index helps you find topics quickly.

**Creating Indexes:**
```sql
-- Single column index
CREATE INDEX idx_customers_email ON customers(email);

-- Composite index (multiple columns)
CREATE INDEX idx_orders_customer_date ON orders(customer_id, order_date);

-- Unique index (enforces uniqueness)
CREATE UNIQUE INDEX unique_employee_email ON employees(email);

-- Partial index (on subset of data)
CREATE INDEX idx_active_customers ON customers(customer_id) 
WHERE is_active = TRUE;
```

**When to Index:**
- Columns frequently used in WHERE clauses
- Columns used in JOIN conditions
- Columns used in ORDER BY
- Columns with high selectivity (many unique values)

**When NOT to Index:**
- Tables with frequent writes (INSERT/UPDATE/DELETE)
- Columns with few unique values (like gender)
- Small tables (under 1000 rows)
- Columns rarely used in queries

**📝 Trick: The EXPLAIN Command**
```sql
-- See how database executes your query
EXPLAIN SELECT * FROM customers WHERE email = 'test@example.com';

-- With actual execution time (PostgreSQL)
EXPLAIN ANALYZE SELECT * FROM customers WHERE email = 'test@example.com';

-- Look for:
-- Seq Scan = Full table scan (slow without index)
-- Index Scan = Using index (fast)
-- Bitmap Heap Scan = Combination
```

**📝 Trick: Covering Indexes**
```sql
-- Index that includes all columns needed by query
CREATE INDEX idx_covering ON orders(customer_id, order_date, amount);

-- This query can use just the index (no table access needed)
SELECT customer_id, order_date, amount 
FROM orders 
WHERE customer_id = 123;
```

**📝 Trick: Monitoring Index Usage**
```sql
-- PostgreSQL: See which indexes are being used
SELECT * FROM pg_stat_user_indexes;

-- Find unused indexes
SELECT schemaname, tablename, indexname
FROM pg_stat_user_indexes 
WHERE idx_scan = 0;  -- Never used
```

**🚨 Common Mistake: Over-Indexing**
```sql
-- Too many indexes hurt performance:
-- 1. Slows down INSERT/UPDATE/DELETE
-- 2. Uses more disk space
-- 3. Query optimizer gets confused

-- Bad: Index on every column
CREATE INDEX idx1 ON table(col1);
CREATE INDEX idx2 ON table(col2);
CREATE INDEX idx3 ON table(col3);
CREATE INDEX idx4 ON table(col1, col2);
CREATE INDEX idx5 ON table(col2, col3);
-- ...and so on

-- Better: Analyze query patterns, create strategic indexes
```

**🚨 Common Mistake: Wrong Column Order in Composite Indexes**
```sql
-- Index on (A, B, C) helps queries with:
-- WHERE A = ?
-- WHERE A = ? AND B = ?
-- WHERE A = ? AND B = ? AND C = ?
-- But NOT: WHERE B = ? or WHERE C = ?

-- Put most selective columns first
-- Good for: WHERE city = 'Pune' AND last_name = 'Shah'
CREATE INDEX idx_name ON customers(city, last_name);

-- Bad order if you usually search by last_name first
```

**✅ Best Practice:**
- Index based on actual query patterns
- Use EXPLAIN to verify index usage
- Regularly monitor and remove unused indexes
- Consider partial indexes for filtered queries
- Test performance with realistic data volumes

---

## 23. SQL Best Practices

### 1. Naming Conventions
```sql
-- Be consistent!
-- Tables: plural nouns
customers, orders, products

-- Columns: snake_case
first_name, order_date, unit_price

-- Primary keys: table_id
customer_id, order_id, product_id

-- Foreign keys: referenced_table_id
customer_id (in orders table), product_id (in order_items)
```

### 2. Write Readable SQL
```sql
-- Bad: Everything on one line
SELECT c.first_name, c.last_name, o.order_date, o.amount FROM customers c INNER JOIN orders o ON c.customer_id = o.customer_id WHERE o.amount > 1000 ORDER BY o.order_date DESC;

-- Good: Formatted and clear
SELECT 
    c.first_name,
    c.last_name, 
    o.order_date,
    o.amount
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
WHERE o.amount > 1000
ORDER BY o.order_date DESC;
```

### 3. Use Comments
```sql
-- Calculate monthly sales for reporting
-- Created: 2024-01-15
-- Author: Data Team
SELECT 
    DATE_TRUNC('month', order_date) AS month,
    SUM(amount) AS total_sales,
    COUNT(*) AS order_count
FROM orders
WHERE status = 'COMPLETED'  -- Only completed orders
  AND order_date >= '2024-01-01'  -- Current year only
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY month DESC;
```

### 4. Security Best Practices
```sql
-- Use parameterized queries (prevents SQL injection)
-- BAD (vulnerable):
"SELECT * FROM users WHERE username = '" + username + "'"

-- GOOD (safe):
"SELECT * FROM users WHERE username = ?"
-- Then pass username as parameter

-- Limit user privileges
GRANT SELECT, INSERT ON orders TO order_clerk;
GRANT SELECT ON customers TO analyst;
-- Don't give everyone ALL privileges!
```

### 5. Performance Considerations
```sql
-- Fetch only needed data
SELECT customer_id, first_name FROM customers;  -- Good
SELECT * FROM customers;  -- Bad (usually)

-- Use WHERE to filter early
SELECT * FROM large_table WHERE date > '2024-01-01';  -- Good
SELECT * FROM large_table;  -- Then filter in application (Bad)

-- Use EXISTS instead of IN for large datasets
SELECT * FROM customers c
WHERE EXISTS (SELECT 1 FROM orders o WHERE o.customer_id = c.customer_id);
```

### 6. Transaction Management
```sql
-- Use transactions for multiple related operations
BEGIN TRANSACTION;

UPDATE accounts SET balance = balance - 100 WHERE account_id = 1;
UPDATE accounts SET balance = balance + 100 WHERE account_id = 2;

-- Check for errors
IF everything_ok THEN
    COMMIT;  -- Save changes
ELSE
    ROLLBACK;  -- Undo everything
END IF;
```

### 7. Regular Maintenance
```sql
-- Update statistics (helps query optimizer)
ANALYZE table_name;

-- Rebuild indexes (fixes fragmentation)
REINDEX INDEX index_name;

-- Clean up old data
DELETE FROM logs WHERE created_at < CURRENT_DATE - INTERVAL '90 days';

-- Backup regularly!
pg_dump database_name > backup.sql
```

**✅ The Golden Rules:**
1. **Keep it simple** - Complex SQL is hard to debug
2. **Test thoroughly** - Especially UPDATE/DELETE
3. **Think about performance** - Consider indexes, query structure
4. **Document** - Comment complex queries
5. **Security first** - Prevent SQL injection, limit privileges
6. **Backup regularly** - Before major changes

---

## 24. Common Mistakes

### 1. NULL Handling Issues
```sql
-- WRONG: NULL comparison
SELECT * FROM customers WHERE city = NULL;  -- Always empty!
SELECT * FROM customers WHERE city != NULL; -- Always empty!

-- CORRECT:
SELECT * FROM customers WHERE city IS NULL;
SELECT * FROM customers WHERE city IS NOT NULL;

-- Also: NULL in arithmetic
SELECT 10 + NULL;  -- Result: NULL
SELECT AVG(column) FROM table;  -- NULLs are ignored in AVG
```

### 2. String Comparison Case Sensitivity
```sql
-- Database-dependent behavior
SELECT * FROM users WHERE username = 'ADMIN';  -- Might not find 'admin'

-- Safer approaches:
SELECT * FROM users WHERE LOWER(username) = LOWER('ADMIN');
SELECT * FROM users WHERE username ILIKE 'admin';  -- PostgreSQL
-- Or set database to case-insensitive collation
```

### 3. Date/Time Confusion
```sql
-- Timezone issues
SELECT * FROM events WHERE event_time > NOW();  -- Which timezone?

-- Date vs Timestamp
SELECT * FROM orders WHERE order_date = '2024-01-01';
-- Might miss orders at '2024-01-01 14:30:00'

-- Better:
SELECT * FROM orders 
WHERE order_date >= '2024-01-01' 
  AND order_date < '2024-01-02';
```

### 4. Implicit Type Conversion
```sql
-- Sometimes works, but slow and error-prone
SELECT * FROM users WHERE user_id = '123';  -- String vs Number

-- Explicit is better
SELECT * FROM users WHERE user_id = 123;  -- Number
SELECT * FROM users WHERE CAST(user_id AS TEXT) = '123';  -- Explicit
```

### 5. GROUP BY Confusion
```sql
-- ERROR: Non-aggregated column not in GROUP BY
SELECT department, first_name, AVG(salary)
FROM employees
GROUP BY department;

-- CORRECT:
SELECT department, first_name, AVG(salary)
FROM employees
GROUP BY department, first_name;  -- Add to GROUP BY

-- OR:
SELECT department, AVG(salary)
FROM employees
GROUP BY department;  -- Remove from SELECT
```

### 6. JOIN Without ON Clause
```sql
-- Creates Cartesian product (n × m rows)
SELECT * FROM customers, orders;  -- DANGEROUS!

-- Always specify join condition
SELECT * FROM customers c
JOIN orders o ON c.customer_id = o.customer_id;
```

### 7. SELECT * in Production
```sql
-- Problems:
-- 1. Performance: Fetching unnecessary data
-- 2. Maintenance: Breaks if columns are reordered/removed
-- 3. Security: Might expose sensitive columns

-- Instead:
SELECT id, name, email FROM users;  -- Explicit columns
```

### 8. Not Using Transactions
```sql
-- Problem: Partial updates if error occurs
UPDATE accounts SET balance = balance - 100 WHERE id = 1;
-- What if this fails?
UPDATE accounts SET balance = balance + 100 WHERE id = 2;

-- Solution: Use transactions
BEGIN;
UPDATE accounts SET balance = balance - 100 WHERE id = 1;
UPDATE accounts SET balance = balance + 100 WHERE id = 2;
COMMIT;
```

### 9. Ignoring Indexes
```sql
-- Slow query on large table
SELECT * FROM orders WHERE customer_id = 123;  -- Without index

-- Add index:
CREATE INDEX idx_orders_customer ON orders(customer_id);

-- Also: Functions prevent index usage
SELECT * FROM users WHERE UPPER(name) = 'JOHN';  -- Can't use index on name
SELECT * FROM users WHERE name = 'John';  -- Can use index
```

### 10. Hardcoding Values
```sql
-- Hard to maintain
SELECT * FROM orders WHERE status = 'C';

-- Better: Use constants or configuration tables
-- Define in application: const COMPLETED = 'C'
-- Or have a statuses lookup table
```

**Debugging Checklist:**
1. ✅ Check for NULL issues
2. ✅ Verify case sensitivity
3. ✅ Check data types match
4. ✅ Test with sample data
5. ✅ Use EXPLAIN to see execution plan
6. ✅ Check indexes are being used
7. ✅ Verify JOIN conditions
8. ✅ Test transactions work correctly

---

## 25. Final Cheat Sheet

### Basic Commands
```sql
-- Create
CREATE TABLE table_name (col1 TYPE, col2 TYPE);
INSERT INTO table VALUES (val1, val2);

-- Read
SELECT col1, col2 FROM table WHERE condition;
SELECT DISTINCT col FROM table;

-- Update
UPDATE table SET col = value WHERE condition;

-- Delete
DELETE FROM table WHERE condition;
```

### Filtering & Sorting
```sql
SELECT * FROM table 
WHERE col > value 
  AND col2 IN (1, 2, 3)
  AND col3 IS NOT NULL
ORDER BY col1 DESC, col2 ASC
LIMIT 10 OFFSET 20;
```

### Aggregation
```sql
SELECT 
    department,
    COUNT(*) AS emp_count,
    AVG(salary) AS avg_salary,
    MAX(salary) AS max_salary
FROM employees
WHERE hire_date > '2020-01-01'
GROUP BY department
HAVING AVG(salary) > 50000
ORDER BY avg_salary DESC;
```

### Joins
```sql
-- INNER JOIN (only matches)
SELECT c.name, o.amount
FROM customers c
JOIN orders o ON c.id = o.customer_id;

-- LEFT JOIN (all from left)
SELECT c.name, o.amount
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id;

-- Multiple joins
SELECT c.name, o.amount, p.product_name
FROM customers c
JOIN orders o ON c.id = o.customer_id
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id;
```

### Subqueries
```sql
-- Scalar
SELECT * FROM employees 
WHERE salary > (SELECT AVG(salary) FROM employees);

-- IN
SELECT * FROM customers
WHERE id IN (SELECT customer_id FROM orders);

-- EXISTS
SELECT * FROM customers c
WHERE EXISTS (SELECT 1 FROM orders o WHERE o.customer_id = c.id);
```

### CASE Statements
```sql
SELECT name, salary,
  CASE
    WHEN salary > 70000 THEN 'High'
    WHEN salary > 50000 THEN 'Medium'
    ELSE 'Low'
  END AS salary_level
FROM employees;
```

### Common Functions
```sql
-- String
UPPER(text), LOWER(text), LENGTH(text)
CONCAT(str1, str2), SUBSTRING(text FROM start FOR length)

-- Date
CURRENT_DATE, CURRENT_TIMESTAMP
DATE_TRUNC('month', date_column)
EXTRACT(YEAR FROM date_column)
date_column + INTERVAL '1 day'

-- Math
ROUND(number, decimals), CEIL(number), FLOOR(number)
ABS(number), MOD(dividend, divisor)

-- Conditional
COALESCE(col, 'default')  -- First non-NULL
NULLIF(col, 'value')      -- NULL if equal
```

### Quick Reference Table

| Task | Example |
|------|---------|
| Create table | `CREATE TABLE t (id INT PRIMARY KEY, name TEXT);` |
| Insert data | `INSERT INTO t VALUES (1, 'John');` |
| Select all | `SELECT * FROM t;` |
| Select specific | `SELECT name, email FROM t;` |
| Filter rows | `SELECT * FROM t WHERE id = 1;` |
| Sort results | `SELECT * FROM t ORDER BY name DESC;` |
| Limit results | `SELECT * FROM t LIMIT 10;` |
| Count rows | `SELECT COUNT(*) FROM t;` |
| Group data | `SELECT dept, AVG(salary) FROM t GROUP BY dept;` |
| Join tables | `SELECT * FROM a JOIN b ON a.id = b.a_id;` |
| Update data | `UPDATE t SET name = 'Jane' WHERE id = 1;` |
| Delete data | `DELETE FROM t WHERE id = 1;` |
| Add column | `ALTER TABLE t ADD COLUMN email TEXT;` |
| Create index | `CREATE INDEX idx_name ON t(name);` |

### Remember These Rules:
1. **SQL execution order:** FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY → LIMIT
2. **GROUP BY rule:** Every non-aggregate column in SELECT must be in GROUP BY
3. **NULL rule:** Use IS NULL/IS NOT NULL, not = NULL or != NULL
4. **Join rule:** Always specify ON condition to avoid Cartesian product
5. **Safety rule:** Test UPDATE/DELETE with SELECT first
6. **Performance rule:** Avoid SELECT *, use indexes, filter early

---

## Conclusion

SQL is a powerful language that takes practice to master. Start with simple queries, understand each clause's purpose, and gradually build up to complex operations. Remember:

1. **Practice regularly** - Use online SQL playgrounds
2. **Read others' code** - Learn from well-written queries
3. **Understand your data** - Know your schema and relationships
4. **Test thoroughly** - Especially with production data
5. **Keep learning** - SQL has many advanced features

**Final Tip:** Bookmark this guide and refer to it when writing SQL. With time and practice, these concepts will become second nature!

---

*Happy Querying!* 🚀