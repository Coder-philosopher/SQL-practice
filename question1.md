# SQL Employees Practice Script - Complete Guide with Detailed Explanations

## 📋 Table of Contents
1. [Introduction](#introduction)
2. [Setting Up: DROP TABLE](#1-setting-up-drop-table)
3. [CREATE TABLE Explained](#2-create-table-explained)
4. [INSERT Sample Data](#3-insert-sample-data)
5. [SELECT Active Employees](#4-select-active-employees)
6. [Filter by Department and Salary](#5-filter-by-department-and-salary)
7. [Top 3 Highest Salaries](#6-top-3-highest-salaries)
8. [Computed Column - Annual Salary](#7-computed-column-annual-salary)
9. [Group by Department - Count Employees](#8-group-by-department-count-employees)
10. [Group by with HAVING - Filter Averages](#9-group-by-with-having-filter-averages)
11. [Count Inactive Employees](#10-count-inactive-employees)
12. [UPDATE - Give 10% Raise](#11-update-give-10-raise)
13. [UPDATE - Mark Old Hires Inactive](#12-update-mark-old-hires-inactive)
14. [DELETE - Remove Specific Employees](#13-delete-remove-specific-employees)
15. [ALTER TABLE - Add Bonus Column](#14-alter-table-add-bonus-column)
16. [UPDATE with CASE - Calculate Bonus](#15-update-with-case-calculate-bonus)

---

## Introduction

This is a **complete SQL practice script** that teaches you how to work with an `employees` table. We'll cover everything from creating tables to complex updates. Think of it as a **hands-on tutorial** where each step builds on the previous one.

**What You'll Learn:**
- How to create and manage database tables
- How to insert, update, and delete data
- How to write queries to analyze data
- Real-world patterns used in actual database work

**Prerequisites:**
- Basic understanding of SQL
- PostgreSQL database (or similar)
- A willingness to learn by doing!

---

## 1. Setting Up: DROP TABLE

```sql
-- SAFETY: Drop table if it already exists so the script can be re-run.
-- Trick: Always use DROP TABLE IF EXISTS in practice scripts so they are idempotent.
DROP TABLE IF EXISTS employees;
```

### What This Does:
This command **removes** the `employees` table if it exists. It's like saying "start fresh" - wipe the slate clean before we begin.

### Detailed Explanation:
- **`DROP TABLE`**: Deletes the entire table structure and all its data
- **`IF EXISTS`**: Safety check - only drops if the table exists. Without this, you'd get an error if the table doesn't exist
- **Why do this?**: In practice scripts, we want to be able to run the script multiple times. If we don't drop first, we'd get errors saying "table already exists"

### Real-World Analogy:
Imagine you're painting a wall. Before starting, you might say:
1. "If there's old paint, scrape it off" (DROP TABLE)
2. "But only scrape if there actually IS old paint" (IF EXISTS)
3. "Now I have a clean surface to work on"

### Common Mistakes:
```sql
-- WRONG: Will crash if table doesn't exist
DROP TABLE employees;

-- BETTER: Safer approach
DROP TABLE IF EXISTS employees;
```

### Pro Tip:
The comment says "idempotent" - that's a fancy word meaning "you can run this multiple times and get the same result." Good practice scripts are always idempotent!

---

## 2. CREATE TABLE Explained

```sql
-- Create the employees table to store basic employee info.
CREATE TABLE employees (
  employee_id SERIAL PRIMARY KEY,      -- SERIAL: auto-incrementing integer, PRIMARY KEY ensures uniqueness.
  first_name  TEXT NOT NULL,           -- NOT NULL: value is required.
  last_name   TEXT NOT NULL,           -- TEXT type is fine for names.
  email       TEXT NOT NULL UNIQUE,    -- UNIQUE: no two employees can have same email.
  department  TEXT,                    -- Nullable: department can be NULL (e.g., not assigned).
  salary      NUMERIC(10,2) NOT NULL,  -- Fixed-point number: good for money. (10 digits, 2 decimal places)
  hire_date   DATE NOT NULL,           -- Date the employee was hired.
  is_active   BOOLEAN DEFAULT TRUE     -- TRUE/FALSE, default is TRUE when not specified.
);

-- Check table structure.
-- Trick: Use \d employees in psql or DESCRIBE in MySQL-like clients.
-- Here we just select nothing to confirm table exists.
SELECT * FROM employees;
```

### What This Does:
Creates a new table called `employees` with 8 columns. Each column has specific rules about what kind of data it can store.

### Column-by-Column Breakdown:

1. **`employee_id SERIAL PRIMARY KEY`**
   - `SERIAL`: Auto-incrementing number. First employee gets 1, next gets 2, etc.
   - `PRIMARY KEY`: Unique identifier for each employee. No two employees can have the same ID.
   - **Example**: Like employee badge numbers - each is unique and assigned automatically.

2. **`first_name TEXT NOT NULL`**
   - `TEXT`: Stores text data (names, descriptions, etc.)
   - `NOT NULL`: This field MUST be filled. You can't create an employee without a first name.
   - **Example**: "John", "Sarah", "Michael"

3. **`last_name TEXT NOT NULL`**
   - Same as first_name - must have a value.
   - **Example**: "Smith", "Johnson", "Williams"

4. **`email TEXT NOT NULL UNIQUE`**
   - `NOT NULL`: Must provide an email
   - `UNIQUE`: No duplicate emails allowed. Each email can belong to only one employee.
   - **Example**: "john.smith@company.com"

5. **`department TEXT`**
   - No `NOT NULL`, so this can be empty (NULL).
   - **Example**: "IT", "HR", "Sales", or NULL if not assigned yet.

6. **`salary NUMERIC(10,2) NOT NULL`**
   - `NUMERIC(10,2)`: Decimal number with 10 total digits, 2 after decimal point.
   - Good for money: Can store up to 99,999,999.99
   - **Example**: 50000.00, 75320.50, 100000.00

7. **`hire_date DATE NOT NULL`**
   - `DATE`: Stores only dates (no time).
   - Format: YYYY-MM-DD
   - **Example**: '2023-12-12'

8. **`is_active BOOLEAN DEFAULT TRUE`**
   - `BOOLEAN`: True/False values
   - `DEFAULT TRUE`: If not specified, assumes TRUE (employee is active)
   - **Example**: TRUE (active), FALSE (inactive/left company)

### Visualizing the Table Structure:
```
employees table:
┌──────────────┬────────────────┬─────────┐
│ Column Name  │ Data Type      │ Rules   │
├──────────────┼────────────────┼─────────┤
│ employee_id  │ SERIAL         │ PK      │
│ first_name   │ TEXT           │ NOT NULL│
│ last_name    │ TEXT           │ NOT NULL│
│ email        │ TEXT           │ UNIQUE  │
│ department   │ TEXT           │         │
│ salary       │ NUMERIC(10,2)  │ NOT NULL│
│ hire_date    │ DATE           │ NOT NULL│
│ is_active    │ BOOLEAN        │ DEFAULT │
└──────────────┴────────────────┴─────────┘
```

### The SELECT Statement:
```sql
SELECT * FROM employees;
```
- This shows all columns from the employees table
- Since we just created it, it's empty (0 rows)
- Good practice: Run this to confirm table was created

### Common Mistakes to Avoid:
```sql
-- WRONG: Forgetting data types
CREATE TABLE employees (employee_id, first_name);  -- ERROR!

-- WRONG: Missing required fields
INSERT INTO employees (first_name) VALUES ('John');  
-- ERROR: last_name is NOT NULL but not provided

-- RIGHT: Complete record
INSERT INTO employees (first_name, last_name, email, salary, hire_date)
VALUES ('John', 'Doe', 'john@example.com', 50000.00, '2023-01-01');
```

### Pro Tip:
Always design your tables with future needs in mind. Ask yourself:
1. What data do I absolutely need? (NOT NULL)
2. What should be unique? (UNIQUE)
3. What are sensible defaults? (DEFAULT)

---

## 3. INSERT Sample Data

```sql
-- Insert multiple rows in one statement.
-- Trick: Always list columns explicitly; it prevents bugs when schema changes.
INSERT INTO employees
  (first_name, last_name, email, department, salary, hire_date, is_active)
VALUES
  ('John', 'One',   'john1@example.com', NULL,      35340.00, '2023-12-12', TRUE),
  ('John', 'Two',   'john2@example.com', 'IT',      54340.00, '2023-12-09', FALSE),
  ('John', 'Three', 'john3@example.com', 'Finance', 75020.00, '2022-05-12', TRUE),
  ('John', 'Four',  'john4@example.com', 'IT',      54340.00, '2023-10-01', TRUE),
  ('John', 'Five',  'john5@example.com', 'Finance', 30000.00, '2023-12-12', FALSE),
  ('John', 'Six',   'john6@example.com', 'HR',      30000.00, '2024-12-12', TRUE),
  ('John', 'Seven', 'john7@example.com', 'HR',      50000.00, '2021-12-12', FALSE),
  ('John', 'Eight', 'john8@example.com', 'Sales',   64340.00, '2020-12-12', TRUE);

-- View all inserted rows.
SELECT * FROM employees;
```

### What This Does:
Adds 8 employee records to our empty table. Each `VALUES` line creates one employee.

### Breaking Down the Data:
Let's look at the first employee:
```sql
('John', 'One', 'john1@example.com', NULL, 35340.00, '2023-12-12', TRUE)
```
This becomes:
- `first_name`: 'John'
- `last_name`: 'One'
- `email`: 'john1@example.com'
- `department`: NULL (not assigned)
- `salary`: 35340.00
- `hire_date`: '2023-12-12'
- `is_active`: TRUE

### Important Notes:

1. **Column Order Matters!**
   The values must match the column order specified:
   ```sql
   (first_name, last_name, email, department, salary, hire_date, is_active)
   VALUES (John,      One,    email...)
   ```

2. **NULL Values**
   - First employee has `NULL` for department
   - `NULL` means "unknown" or "not applicable"
   - Different from empty string '' or zero 0

3. **Boolean Values**
   - `TRUE` or `FALSE` (case-insensitive in PostgreSQL)
   - Can also use `1`/`0` or `'t'`/`'f'` in some databases

### What the Data Looks Like:
After inserting, `SELECT * FROM employees` shows:

```
employee_id | first_name | last_name | email               | department | salary  | hire_date  | is_active
------------|------------|-----------|---------------------|------------|---------|------------|----------
1           | John       | One       | john1@example.com   | NULL       | 35340.00| 2023-12-12 | true
2           | John       | Two       | john2@example.com   | IT         | 54340.00| 2023-12-09 | false
3           | John       | Three     | john3@example.com   | Finance    | 75020.00| 2022-05-12 | true
... and so on for all 8 employees
```

### Why List Columns Explicitly?
The comment says "prevents bugs when schema changes." Here's why:

```sql
-- BAD: Implicit column order
INSERT INTO employees VALUES (1, 'John', 'Doe', ...);
-- If table structure changes (columns added/removed), this breaks!

-- GOOD: Explicit columns
INSERT INTO employees (first_name, last_name, email, ...)
VALUES ('John', 'Doe', 'john@example.com', ...);
-- Still works even if new columns are added later
```

### Pro Tip: Inserting Multiple Rows
Notice the syntax:
```sql
VALUES
  (row1 values),
  (row2 values),
  (row3 values);
```
- Each row in parentheses
- Rows separated by commas
- Much faster than 8 separate INSERT statements!

### Common Errors:
```sql
-- WRONG: Missing values for NOT NULL columns
INSERT INTO employees (first_name, last_name) 
VALUES ('John', 'Doe');  -- ERROR: email, salary, hire_date are NOT NULL!

-- WRONG: Duplicate email (violates UNIQUE)
INSERT INTO employees (first_name, last_name, email, salary, hire_date)
VALUES ('Jane', 'Doe', 'john1@example.com', 50000, '2024-01-01');
-- ERROR: john1@example.com already exists!
```

---

## 4. SELECT Active Employees

```sql
-- Get only active employees, newest hires first.
SELECT *
FROM employees
WHERE is_active = TRUE              -- Filter condition: only rows where is_active is TRUE.
ORDER BY hire_date DESC;            -- DESC: newest date at top.

-- Trick / Remember:
-- - WHERE filters rows BEFORE ORDER BY.
-- - Boolean columns can often be written as WHERE is_active (in PostgreSQL),
--   but using = TRUE is clearer for beginners.
```

### What This Does:
Shows all columns for employees who are currently active, sorted with the most recently hired employees first.

### Step-by-Step Execution:

1. **`FROM employees`**
   - Start with all 8 employees in our table

2. **`WHERE is_active = TRUE`**
   - Filter: Keep only active employees
   - Based on our data: Employees 1, 3, 4, 6, 8 are active (TRUE)
   - Employees 2, 5, 7 are inactive (FALSE) - these are excluded

3. **`ORDER BY hire_date DESC`**
   - Sort the remaining active employees by hire_date
   - `DESC` = descending = newest to oldest
   - Latest hire date: '2024-12-12' (John Six) comes first
   - Oldest hire date: '2020-12-12' (John Eight) comes last

4. **`SELECT *`**
   - Show all columns for the filtered, sorted results

### Expected Result:
```
employee_id | first_name | last_name | email               | department | salary  | hire_date  | is_active
------------|------------|-----------|---------------------|------------|---------|------------|----------
6           | John       | Six       | john6@example.com   | HR         | 30000.00| 2024-12-12 | true
1           | John       | One       | john1@example.com   | NULL       | 35340.00| 2023-12-12 | true
4           | John       | Four      | john4@example.com   | IT         | 54340.00| 2023-10-01 | true
3           | John       | Three     | john3@example.com   | Finance    | 75020.00| 2022-05-12 | true
8           | John       | Eight     | john8@example.com   | Sales      | 64340.00| 2020-12-12 | true
```

### Alternative Syntax:
```sql
-- These are equivalent in PostgreSQL:
WHERE is_active = TRUE
WHERE is_active
WHERE is_active IS TRUE
-- All mean "where is_active is true"

-- For inactive:
WHERE is_active = FALSE
WHERE NOT is_active
WHERE is_active IS FALSE
```

### Understanding ORDER BY DESC:
- `ASC` (ascending): A-Z, 1-10, oldest to newest (default)
- `DESC` (descending): Z-A, 10-1, newest to oldest

```sql
-- Newest first:
ORDER BY hire_date DESC

-- Oldest first:
ORDER BY hire_date ASC  -- or just ORDER BY hire_date
```

### Pro Tip: SQL Execution Order
Remember this sequence (it's important!):
1. **FROM** - Get data from table
2. **WHERE** - Filter rows
3. **ORDER BY** - Sort rows
4. **SELECT** - Choose which columns to display

This explains why you can use column names in ORDER BY that aren't in SELECT!

---

## 5. Filter by Department and Salary

```sql
-- Select employees in IT or HR departments with salary between 40k and 80k.
SELECT
  employee_id,
  first_name,
  department,
  salary
FROM employees
WHERE department IN ('IT', 'HR')    -- IN: shorthand for department = 'IT' OR department = 'HR'.
  AND salary BETWEEN 40000 AND 80000;  -- BETWEEN is inclusive: >= 40000 AND <= 80000.

-- Trick / Remember:
-- - BETWEEN is inclusive on both ends.
-- - The AND combines both conditions (department filter + salary range).
-- - Watch operator precedence: AND vs OR (use parentheses when mixing them).
```

### What This Does:
Finds employees who work in either IT or HR departments AND earn between 40,000 and 80,000 (inclusive).

### Breaking Down the WHERE Clause:

**Condition 1: `department IN ('IT', 'HR')`**
- This is equivalent to:
  ```sql
  WHERE department = 'IT' OR department = 'HR'
  ```
- Includes employees from IT department OR HR department
- Excludes: Finance, Sales, and NULL departments

**Condition 2: `salary BETWEEN 40000 AND 80000`**
- This is equivalent to:
  ```sql
  WHERE salary >= 40000 AND salary <= 80000
  ```
- Includes salaries from 40,000 up to 80,000
- 40,000 and 80,000 are INCLUDED (that's what "inclusive" means)

**Combining with AND:**
- Both conditions must be true
- Employee must be in (IT OR HR) AND have salary between 40k-80k

### Step-by-Step Filtering:

From our 8 employees:
1. **Check department condition:**
   - IT: Employees 2 and 4
   - HR: Employees 6 and 7
   - Others: Excluded

2. **Check salary condition on remaining 4:**
   - Employee 2 (IT): 54340.00 ✅ (between 40k-80k)
   - Employee 4 (IT): 54340.00 ✅ (between 40k-80k)
   - Employee 6 (HR): 30000.00 ❌ (below 40k)
   - Employee 7 (HR): 50000.00 ✅ (between 40k-80k)

3. **Final result:** Employees 2, 4, and 7

### Expected Result:
```
employee_id | first_name | department | salary
------------|------------|------------|---------
2           | John       | IT         | 54340.00
4           | John       | IT         | 54340.00
7           | John       | HR         | 50000.00
```

### Important Notes:

1. **BETWEEN is Inclusive**
   ```sql
   -- These are the same:
   BETWEEN 40000 AND 80000
   >= 40000 AND <= 80000
   
   -- If you want exclusive (not including endpoints):
   > 40000 AND < 80000
   ```

2. **IN Operator**
   Great for checking against multiple values:
   ```sql
   -- Instead of:
   WHERE department = 'IT' OR department = 'HR' OR department = 'Sales'
   
   -- Use:
   WHERE department IN ('IT', 'HR', 'Sales')
   ```

3. **Operator Precedence**
   ```sql
   -- DANGEROUS: Might not do what you expect
   WHERE department = 'IT' OR department = 'HR' AND salary > 50000
   -- This means: (department = 'IT') OR (department = 'HR' AND salary > 50000)
   
   -- CLEAR: Use parentheses
   WHERE (department = 'IT' OR department = 'HR') AND salary > 50000
   -- This means: Must be in IT or HR, AND salary > 50000
   ```

### Pro Tip: NULL Values with IN
```sql
-- NULL doesn't work with IN like you might expect
WHERE department IN ('IT', 'HR', NULL)  -- Won't find NULL departments!
-- Use this instead for NULL:
WHERE department IN ('IT', 'HR') OR department IS NULL
```

---

## 6. Top 3 Highest Salaries

```sql
-- Get top 3 highest-paid employees.
SELECT
  employee_id,
  first_name,
  last_name,
  salary
FROM employees
ORDER BY salary DESC   -- DESC: highest salary first.
LIMIT 3;               -- LIMIT: restrict result to 3 rows.

-- Trick / Remember:
-- - ORDER BY always comes *after* WHERE.
-- - LIMIT depends on the DB (MySQL/Postgres use LIMIT, SQL Server uses TOP).
-- - If two salaries are equal, order between them is not guaranteed
--   unless you add a second sort column (e.g., ORDER BY salary DESC, employee_id ASC).
```

### What This Does:
Finds the 3 employees with the highest salaries and displays their details.

### How It Works:

1. **`ORDER BY salary DESC`**
   - Sort all employees by salary
   - `DESC` = descending = highest to lowest
   - From our data, salaries in order: 75020, 64340, 54340, 54340, 50000, 35340, 30000, 30000

2. **`LIMIT 3`**
   - Take only the first 3 rows from the sorted list
   - Like saying "show me the top 3"

### Expected Result:
```
employee_id | first_name | last_name | salary
------------|------------|-----------|---------
3           | John       | Three     | 75020.00
8           | John       | Eight     | 64340.00
2           | John       | Two       | 54340.00
```

### Important Notes:

1. **Ties with LIMIT**
   What if two employees have the same salary (like John Two and John Four both have 54340)?
   ```sql
   ORDER BY salary DESC LIMIT 3
   ```
   Could return either John Two OR John Four - it's not guaranteed!
   
   **Solution:** Add a second sort column:
   ```sql
   ORDER BY salary DESC, employee_id ASC
   -- Now ties are broken by employee_id (smaller ID first)
   ```

2. **Different Database Syntax**
   ```sql
   -- PostgreSQL, MySQL:
   SELECT ... ORDER BY ... LIMIT 3
   
   -- SQL Server:
   SELECT TOP 3 ... ORDER BY ...
   
   -- Oracle (old syntax):
   SELECT ... WHERE ROWNUM <= 3 ORDER BY ...
   ```

3. **LIMIT with OFFSET for Pagination**
   ```sql
   -- Get rows 4-6 (second "page" of 3 results)
   ORDER BY salary DESC
   LIMIT 3 OFFSET 3
   -- OFFSET 3 = skip first 3 rows
   ```

### Pro Tip: Getting Both Top AND Bottom
```sql
-- Top 3 highest salaries
(SELECT ... ORDER BY salary DESC LIMIT 3)

UNION ALL

-- Top 3 lowest salaries (but watch for NULLs!)
(SELECT ... ORDER BY salary ASC LIMIT 3)

ORDER BY salary DESC;
```

### Common Mistake:
```sql
-- WRONG: LIMIT before ORDER BY (syntax error)
SELECT * FROM employees LIMIT 3 ORDER BY salary DESC;

-- RIGHT: ORDER BY comes before LIMIT
SELECT * FROM employees ORDER BY salary DESC LIMIT 3;
```

---

## 7. Computed Column - Annual Salary

```sql
-- Calculate annual salary (simple 12 * monthly salary assumption).
SELECT 
  employee_id,
  first_name,
  last_name,
  salary * 12 AS annual_salary  -- Expression: computed column with alias.
FROM employees;

-- Trick / Remember:
-- - AS annual_salary: alias for readability.
-- - You can use expressions in SELECT, ORDER BY, GROUP BY etc.
```

### What This Does:
Calculates yearly income for each employee by multiplying their monthly salary by 12.

### Understanding Computed Columns:
A computed column is a column that doesn't exist in the table - it's calculated on the fly during the query.

**Original salary data:**
```
employee_id | salary
------------|---------
1           | 35340.00
2           | 54340.00
3           | 75020.00
```

**After calculation (`salary * 12`):**
```
employee_id | annual_salary
------------|--------------
1           | 424080.00
2           | 652080.00
3           | 900240.00
```

### The AS Keyword (Alias):
- `AS annual_salary` gives the calculated column a name
- Without AS, the column would be named `?column?` or something ugly
- The AS is optional but highly recommended

```sql
-- With alias (good):
SELECT salary * 12 AS annual_salary

-- Without alias (works but ugly):
SELECT salary * 12  -- Column shows as "?column?"
```

### Expected Result:
```
employee_id | first_name | last_name | annual_salary
------------|------------|-----------|---------------
1           | John       | One       | 424080.00
2           | John       | Two       | 652080.00
3           | John       | Three     | 900240.00
... and so on for all employees
```

### More Calculation Examples:
```sql
-- Calculate with commission (10% of salary)
SELECT salary * 0.10 AS commission

-- Calculate tax (30% of salary)
SELECT salary * 0.30 AS tax_amount

-- Net salary after tax
SELECT salary - (salary * 0.30) AS net_salary

-- Complex calculation
SELECT (salary * 12) + (bonus * 4) AS total_compensation
```

### Using Computed Columns in ORDER BY:
```sql
-- Sort by annual salary (even though it's not stored)
SELECT first_name, salary * 12 AS annual
FROM employees
ORDER BY annual DESC;  -- Can use the alias here!

-- Or use the expression directly:
ORDER BY salary * 12 DESC
```

### Pro Tip: Formatting Numbers
```sql
-- Add thousand separators and currency symbol
SELECT 
  first_name,
  TO_CHAR(salary * 12, '$999,999.00') AS annual_salary
FROM employees;

-- Result: "$424,080.00" instead of 424080.00
```

### Common Error:
```sql
-- Can't use alias in WHERE (different execution order)
SELECT salary * 12 AS annual
FROM employees
WHERE annual > 500000  -- ERROR: column "annual" doesn't exist yet!

-- CORRECT: Use the expression
WHERE salary * 12 > 500000
```

---

## 8. Group by Department - Count Employees

```sql
-- Count how many employees are in each department.
SELECT
  department,
  COUNT(department) AS employee_count
FROM employees
GROUP BY department              -- Group rows by department.
ORDER BY employee_count DESC;    -- Show departments with most employees first.

-- Trick / Remember:
-- - All non-aggregate columns in SELECT must appear in GROUP BY.
-- - COUNT(column) ignores NULLs; COUNT(*) counts all rows.
-- - department can be NULL; NULL is treated as its own "group" in GROUP BY.
```

### What This Does:
Counts how many employees work in each department and shows the results sorted by department size.

### Understanding GROUP BY:
GROUP BY organizes rows into groups based on column values. Think of it as "put all identical department values together."

**Before GROUP BY:**
```
employee_id | department
------------|-----------
1           | NULL
2           | IT
3           | Finance
4           | IT
5           | Finance
6           | HR
7           | HR
8           | Sales
```

**After GROUP BY department:**
- Group 1: NULL (employee 1)
- Group 2: IT (employees 2 and 4)
- Group 3: Finance (employees 3 and 5)
- Group 4: HR (employees 6 and 7)
- Group 5: Sales (employee 8)

### COUNT() Function:
- `COUNT(department)`: Counts non-NULL values in the department column
- `COUNT(*)`: Counts all rows in the group

For NULL group: `COUNT(department)` = 0 (no non-NULL values), but `COUNT(*)` = 1 (there is 1 row)

### Expected Result:
```
department | employee_count
-----------|---------------
IT         | 2
Finance    | 2
HR         | 2
Sales      | 1
NULL       | 1
```

### Important Rules:

1. **The GROUP BY Rule:**
   Every column in SELECT that's not inside an aggregate function (COUNT, SUM, AVG, etc.) MUST be in GROUP BY.
   
   ```sql
   -- ERROR: first_name not in GROUP BY
   SELECT department, first_name, COUNT(*)
   FROM employees
   GROUP BY department;
   
   -- CORRECT:
   SELECT department, COUNT(*)
   FROM employees
   GROUP BY department;
   ```

2. **COUNT Variations:**
   ```sql
   COUNT(*)            -- Count all rows in group
   COUNT(column)       -- Count non-NULL values in column
   COUNT(DISTINCT col) -- Count unique non-NULL values
   
   -- Examples:
   COUNT(DISTINCT department)  -- How many unique departments?
   ```

3. **NULLs in GROUP BY:**
   NULL values are grouped together. If 3 employees have NULL department, they form one "NULL group."

### Pro Tip: Multiple Column GROUP BY
```sql
-- Group by department AND is_active status
SELECT 
  department,
  is_active,
  COUNT(*) AS count
FROM employees
GROUP BY department, is_active;

-- Result shows how many active/inactive in each department
```

### Common Mistake:
```sql
-- Trying to see individual names with GROUP BY (won't work)
SELECT department, first_name
FROM employees
GROUP BY department;  -- ERROR: What first_name to show for the group?

-- If you want department with sample employee, use:
SELECT 
  department,
  ARRAY_AGG(first_name) AS employees  -- PostgreSQL
FROM employees
GROUP BY department;
```

---

## 9. Group by with HAVING - Filter Averages

```sql
-- Find departments where average salary is more than 60,000.
SELECT
  department,
  AVG(salary) AS average_salary
FROM employees
GROUP BY department
HAVING AVG(salary) > 60000.00;  -- HAVING filters groups by aggregate conditions.

-- Trick / Remember:
-- - WHERE filters *rows* before grouping.
-- - HAVING filters *groups* after GROUP BY.
-- - You can't use aggregate functions in WHERE, only in HAVING or SELECT.
```

### What This Does:
Finds departments where the average salary of employees is greater than 60,000.

### Understanding HAVING vs WHERE:
This is a **CRITICAL** distinction in SQL:

- **WHERE**: Filters individual rows BEFORE grouping
- **HAVING**: Filters groups AFTER grouping

### Step-by-Step Execution:

1. **FROM employees**: Start with all 8 employees
2. **GROUP BY department**: Create 5 groups (NULL, IT, Finance, HR, Sales)
3. **Calculate AVG(salary)** for each group:
   - NULL: 35340.00 (just employee 1)
   - IT: (54340 + 54340) / 2 = 54340.00
   - Finance: (75020 + 30000) / 2 = 52510.00
   - HR: (30000 + 50000) / 2 = 40000.00
   - Sales: 64340.00 (just employee 8)
4. **HAVING AVG(salary) > 60000**: Keep only groups with average > 60000
   - NULL: 35340 ❌
   - IT: 54340 ❌ (not > 60000)
   - Finance: 52510 ❌
   - HR: 40000 ❌
   - Sales: 64340 ✅
5. **SELECT**: Show department and its average salary

### Expected Result:
```
department | average_salary
-----------|---------------
Sales      | 64340.0000000000000000
```

### HAVING vs WHERE Examples:

```sql
-- WHERE (row filter): Exclude interns before calculating averages
SELECT department, AVG(salary)
FROM employees
WHERE title != 'Intern'        -- Filter rows first
GROUP BY department;

-- HAVING (group filter): Show only departments with high average
SELECT department, AVG(salary)
FROM employees
GROUP BY department
HAVING AVG(salary) > 60000;    -- Filter groups after
```

### Using Aliases in HAVING:
```sql
-- Some databases allow using SELECT aliases in HAVING
SELECT department, AVG(salary) AS avg_sal
FROM employees
GROUP BY department
HAVING avg_sal > 60000;        -- Using alias (works in PostgreSQL)

-- But safer/more portable: repeat the expression
HAVING AVG(salary) > 60000;
```

### Multiple HAVING Conditions:
```sql
-- Departments with avg salary between 50k and 70k AND at least 2 employees
SELECT department, AVG(salary), COUNT(*)
FROM employees
GROUP BY department
HAVING AVG(salary) BETWEEN 50000 AND 70000
   AND COUNT(*) >= 2;
```

### Pro Tip: The Complete SQL Order
Remember this execution order:
1. FROM
2. WHERE
3. GROUP BY
4. HAVING
5. SELECT
6. ORDER BY
7. LIMIT

This explains why:
- WHERE can't use aggregate functions (aggregation happens after WHERE)
- HAVING can use aggregate functions
- Aliases from SELECT can't be used in WHERE (SELECT happens after WHERE)

### Common Mistake:
```sql
-- ERROR: Aggregate in WHERE
SELECT department, AVG(salary)
FROM employees
WHERE AVG(salary) > 60000      -- WRONG!
GROUP BY department;

-- CORRECT: Use HAVING
SELECT department, AVG(salary)
FROM employees
GROUP BY department
HAVING AVG(salary) > 60000;    -- RIGHT!
```

---

## 10. Count Inactive Employees

```sql
-- Count how many employees are inactive.
SELECT
  COUNT(*) AS inactive_count
FROM employees
WHERE is_active = FALSE;

-- Trick / Remember:
-- - COUNT(*) counts all rows; efficient with indexes.
-- - Often used to quickly check how many rows match a condition.
```

### What This Does:
Counts how many employees have `is_active = FALSE` (are inactive).

### Simple but Useful:
This is one of the most common queries - getting a count of records matching a condition.

### How COUNT(*) Works:
- `COUNT(*)`: Counts all rows that pass the WHERE filter
- Returns a single number
- Very efficient - databases are optimized for counting

### From Our Data:
We have 8 employees. Checking each:
- Employee 1: TRUE ✅ (active)
- Employee 2: FALSE ❌ (inactive) ← Count this
- Employee 3: TRUE ✅
- Employee 4: TRUE ✅
- Employee 5: FALSE ❌ ← Count this
- Employee 6: TRUE ✅
- Employee 7: FALSE ❌ ← Count this
- Employee 8: TRUE ✅

**Total inactive: 3**

### Expected Result:
```
inactive_count
---------------
3
```

### COUNT Variations:
```sql
-- All give same result if no NULLs in is_active:
COUNT(*)                    -- Count all rows matching WHERE
COUNT(is_active)            -- Count non-NULL is_active values
COUNT(1)                    -- Count constant expression
COUNT(employee_id)          -- Count non-NULL primary key values

-- But different if column can be NULL:
COUNT(department)           -- Counts only non-NULL departments
COUNT(*)                    -- Counts all rows regardless of NULLs
```

### Pro Tip: Counting Multiple Conditions
```sql
-- Count inactive in IT department only
SELECT COUNT(*)
FROM employees
WHERE is_active = FALSE 
  AND department = 'IT';

-- Count both active and inactive
SELECT 
  COUNT(*) FILTER (WHERE is_active = TRUE) AS active_count,
  COUNT(*) FILTER (WHERE is_active = FALSE) AS inactive_count
FROM employees;
-- Result: active_count | inactive_count
--          5           | 3
```

### Common Use Cases:
1. **Dashboard metrics:** "Show me how many users are active"
2. **Data quality checks:** "How many records are missing email?"
3. **Monitoring:** "Alert me if more than 10% of users are inactive"

### Performance Note:
```sql
-- For counting specific values, this can be faster:
SELECT COUNT(*) FROM employees WHERE is_active = FALSE;

-- Than this:
SELECT COUNT(CASE WHEN is_active = FALSE THEN 1 END) FROM employees;
```

---

## 11. UPDATE - Give 10% Raise

```sql
-- Increase salary by 10% for all employees in IT.
UPDATE employees
SET salary = salary + (salary * 0.10)  -- New salary = old salary + 10% of old salary.
WHERE department = 'IT';               -- Only IT department rows are affected.

-- Check the effect of the update.
SELECT * FROM employees WHERE department = 'IT';

-- Trick / Remember:
-- - ALWAYS use WHERE in UPDATE unless you truly want to update every row.
-- - You can also write salary = salary * 1.10 for a 10% increment.
-- - Good habit: run a SELECT with the same WHERE before running UPDATE/DELETE.
```

### What This Does:
Gives a 10% salary increase to all employees in the IT department.

### Understanding UPDATE:
UPDATE modifies existing data in the table. It has three parts:
1. **UPDATE employees**: Which table to update
2. **SET salary = ...**: What to change and to what value
3. **WHERE department = 'IT'**: Which rows to update

### The Math:
- Original salary: 54340.00
- 10% of salary: 54340.00 × 0.10 = 5434.00
- New salary: 54340.00 + 5434.00 = 59774.00

**Simpler formula:** `salary = salary * 1.10`

### Before and After:
**Before UPDATE:**
```
employee_id | first_name | department | salary
------------|------------|------------|---------
2           | John       | IT         | 54340.00
4           | John       | IT         | 54340.00
```

**After UPDATE:**
```
employee_id | first_name | department | salary
------------|------------|------------|---------
2           | John       | IT         | 59774.00  (54340 * 1.10)
4           | John       | IT         | 59774.00  (54340 * 1.10)
```

### The Safety Habit:
ALWAYS test with SELECT first:
```sql
-- Step 1: See what will be affected
SELECT * FROM employees WHERE department = 'IT';

-- Step 2: Check the count
SELECT COUNT(*) FROM employees WHERE department = 'IT';

-- Step 3: Write your UPDATE with same WHERE
UPDATE employees SET salary = salary * 1.10 WHERE department = 'IT';

-- Step 4: Verify
SELECT * FROM employees WHERE department = 'IT';
```

### DANGER: Forgetting WHERE Clause
```sql
-- DISASTER: Updates EVERY row in the table!
UPDATE employees
SET salary = salary * 1.10;  -- No WHERE clause = all rows updated

-- Someone's getting fired for this mistake!
```

### Multiple Column UPDATE:
```sql
-- Update both salary and bonus
UPDATE employees
SET salary = salary * 1.10,
    bonus = bonus * 1.05
WHERE department = 'IT';
```

### Pro Tip: Update from Another Table
```sql
-- Give raises based on department budget
UPDATE employees e
SET salary = salary * (
  SELECT raise_percentage 
  FROM department_budget d
  WHERE d.department = e.department
)
WHERE department IN ('IT', 'Engineering');
```

### Common Error: Rounding Issues
```sql
-- Watch for floating point precision
UPDATE employees SET salary = salary * 1.10;

-- Better with decimals:
UPDATE employees SET salary = salary * 1.10::DECIMAL;

-- Or round to 2 decimal places:
UPDATE employees SET salary = ROUND(salary * 1.10, 2);
```

---

## 12. UPDATE - Mark Old Hires Inactive

```sql
-- Set is_active = FALSE for employees hired before 2022-01-01.
UPDATE employees
SET is_active = FALSE
WHERE hire_date < '2022-01-01';

-- Check which employees are now inactive.
SELECT * FROM employees WHERE is_active = FALSE;

-- Trick / Remember:
-- - Date comparison uses the normal <, >, <=, >= operators.
-- - Be consistent with your date format (YYYY-MM-DD is standard and safe).
-- - This kind of query is typical for "archiving" or deactivating old records.
```

### What This Does:
Marks employees hired before January 1, 2022 as inactive.

### Date Comparison:
- `hire_date < '2022-01-01'` means "hire date is before 2022-01-01"
- This is comparing dates, so it looks at year, month, and day
- '2022-01-01' is NOT included (that's why `<` not `<=`)

### From Our Data:
Checking each employee's hire_date:
- Employee 1: 2023-12-12 ❌ (after 2022, remains active)
- Employee 2: 2023-12-09 ❌
- Employee 3: 2022-05-12 ❌ (2022 but after Jan 1)
- Employee 4: 2023-10-01 ❌
- Employee 5: 2023-12-12 ❌
- Employee 6: 2024-12-12 ❌
- Employee 7: 2021-12-12 ✅ (before 2022, mark inactive)
- Employee 8: 2020-12-12 ✅ (before 2022, mark inactive)

### Understanding Date Formats:
Always use `YYYY-MM-DD` format - it's standard and unambiguous:
- '2022-01-01' = January 1, 2022
- '01/02/2023' = Ambiguous! January 2 or February 1?

### Before and After:
**Before UPDATE:**
Inactive employees: 2, 5, 7 (3 total)

**After UPDATE:**
Employee 7 and 8 also become inactive
Inactive employees: 2, 5, 7, 8 (4 total)

### Date Functions in WHERE:
```sql
-- Employees hired more than 1 year ago
WHERE hire_date < CURRENT_DATE - INTERVAL '1 year'

-- Employees hired in 2021
WHERE hire_date BETWEEN '2021-01-01' AND '2021-12-31'

-- Employees hired this month
WHERE EXTRACT(YEAR_MONTH FROM hire_date) = EXTRACT(YEAR_MONTH FROM CURRENT_DATE)
```

### Pro Tip: Soft Delete Pattern
Instead of physically deleting old records, we often "soft delete" by marking as inactive:
```sql
-- Add timestamp for when record was deactivated
ALTER TABLE employees ADD COLUMN deactivated_at TIMESTAMP;

-- Soft delete with timestamp
UPDATE employees
SET is_active = FALSE,
    deactivated_at = CURRENT_TIMESTAMP
WHERE hire_date < '2022-01-01';

-- Can still query "deleted" records
SELECT * FROM employees WHERE deactivated_at IS NOT NULL;
```

### Common Mistake: Timezone Issues
```sql
-- If hire_date is TIMESTAMP WITH TIME ZONE
UPDATE employees
SET is_active = FALSE
WHERE hire_date < '2022-01-01';  -- Might not work as expected

-- Better:
WHERE hire_date < TIMESTAMP '2022-01-01 00:00:00'
-- Or specify timezone
WHERE hire_date < '2022-01-01'::TIMESTAMPTZ
```

---

## 13. DELETE - Remove Specific Employees

```sql
-- Delete rows that are both inactive AND have salary less than 35,000.
DELETE FROM employees
WHERE is_active = FALSE
  AND salary < 35000.00;

-- Verify which inactive employees remain (if any).
SELECT * FROM employees WHERE is_active = FALSE;

-- Trick / Remember:
-- - DELETE without WHERE = goodbye entire table! Be careful.
-- - Combine conditions with AND/OR and double-check them.
-- - Again: run SELECT with same WHERE clause first, then DELETE.
```

### What This Does:
Permanently removes employees who are inactive AND earn less than 35,000.

### Understanding DELETE:
DELETE removes entire rows from a table. Once deleted, they're gone (unless you have backups).

### The WHERE Conditions:
Two conditions must BOTH be true:
1. `is_active = FALSE` - Employee is inactive
2. `salary < 35000.00` - Salary is under 35,000

**AND** means both must be true. **OR** would mean either one is true.

### From Our Data:
Inactive employees after previous UPDATE: 2, 5, 7, 8

Check each:
- Employee 2: Salary 59774.00 ❌ (not < 35000)
- Employee 5: Salary 30000.00 ✅ (inactive AND < 35000) ← DELETE
- Employee 7: Salary 50000.00 ❌ (not < 35000)
- Employee 8: Salary 64340.00 ❌ (not < 35000)

**Only employee 5 gets deleted.**

### The Safety Dance:
```sql
-- Step 1: SELECT to see what will be deleted
SELECT * FROM employees 
WHERE is_active = FALSE AND salary < 35000;
-- Should show employee 5

-- Step 2: Check the count
SELECT COUNT(*) FROM employees 
WHERE is_active = FALSE AND salary < 35000;
-- Should be 1

-- Step 3: DELETE
DELETE FROM employees 
WHERE is_active = FALSE AND salary < 35000;

-- Step 4: Verify
SELECT COUNT(*) FROM employees 
WHERE is_active = FALSE AND salary < 35000;
-- Should be 0
```

### DANGER ZONE: Common DELETE Mistakes
```sql
-- MISTAKE 1: No WHERE clause (deletes everything!)
DELETE FROM employees;  -- ALL GONE!

-- MISTAKE 2: Wrong condition
DELETE FROM employees WHERE is_active = TRUE;  -- Oops, meant FALSE!

-- MISTAKE 3: Missing parentheses
DELETE FROM employees 
WHERE department = 'IT' OR department = 'HR' AND salary < 30000;
-- This deletes ALL IT + low-salary HR, not what you probably wanted!
```

### Pro Tip: Use Transactions for Safety
```sql
BEGIN;  -- Start transaction

-- First, test with SELECT
SELECT * FROM employees WHERE is_active = FALSE AND salary < 35000;

-- If it looks right, delete
DELETE FROM employees WHERE is_active = FALSE AND salary < 35000;

-- Check results
SELECT COUNT(*) FROM employees WHERE is_active = FALSE;

-- If happy:
COMMIT;  -- Save changes

-- If mistake:
ROLLBACK;  -- Undo everything
```

### Alternative: Archive Instead of Delete
```sql
-- Instead of deleting, move to archive table
INSERT INTO employees_archive
SELECT * FROM employees 
WHERE is_active = FALSE AND salary < 35000;

-- Then delete
DELETE FROM employees 
WHERE is_active = FALSE AND salary < 35000;
```

---

## 14. ALTER TABLE - Add Bonus Column

```sql
-- Add a new bonus column with default 0.00.
ALTER TABLE employees
ADD COLUMN bonus NUMERIC(10,2) DEFAULT 0.00;

-- Check table structure + data to see new column.
SELECT * FROM employees;

-- Trick / Remember:
-- - ALTER TABLE lets you MODIFY schema after creation.
-- - Common operations: ADD COLUMN, DROP COLUMN, RENAME COLUMN, ALTER TYPE.
-- - Adding a column with DEFAULT fills existing rows with that default value.
```

### What This Does:
Adds a new column called `bonus` to the employees table. All existing employees get a default bonus of 0.00.

### Understanding ALTER TABLE:
ALTER TABLE changes the structure of an existing table. It's how you modify your database design after it's already created.

### The New Column:
- Name: `bonus`
- Type: `NUMERIC(10,2)` - Same as salary, good for monetary values
- Default: `0.00` - If no value is specified, use 0.00

### Before ALTER TABLE:
Table structure:
```
employee_id | first_name | last_name | email | department | salary | hire_date | is_active
```

### After ALTER TABLE:
Table structure:
```
employee_id | first_name | last_name | email | department | salary | hire_date | is_active | bonus
                                                                                                ^
                                                                                          New column!
```

### What Happens to Existing Data:
All current employees (7 remaining after delete) get `bonus = 0.00` automatically because of `DEFAULT 0.00`.

### Other Common ALTER TABLE Operations:

**Add column without default:**
```sql
ALTER TABLE employees
ADD COLUMN middle_name TEXT;
-- Existing rows get NULL for middle_name
```

**Drop a column:**
```sql
ALTER TABLE employees
DROP COLUMN bonus;  -- Goodbye bonus column!
```

**Rename a column:**
```sql
ALTER TABLE employees
RENAME COLUMN bonus TO yearly_bonus;
```

**Change column type:**
```sql
ALTER TABLE employees
ALTER COLUMN salary TYPE DECIMAL(12,2);  -- Allow bigger salaries
```

**Add constraint:**
```sql
ALTER TABLE employees
ADD CONSTRAINT positive_salary CHECK (salary > 0);
```

### Pro Tip: Adding NOT NULL Columns
```sql
-- Can't add NOT NULL column directly if rows exist
ALTER TABLE employees
ADD COLUMN phone TEXT NOT NULL;  -- ERROR: needs default

-- Solution 1: Add nullable, update, then add NOT NULL
ALTER TABLE employees ADD COLUMN phone TEXT;
UPDATE employees SET phone = '' WHERE phone IS NULL;
ALTER TABLE employees ALTER COLUMN phone SET NOT NULL;

-- Solution 2: Add with DEFAULT
ALTER TABLE employees
ADD COLUMN phone TEXT NOT NULL DEFAULT '';
```

### Common Mistakes:
```sql
-- Adding duplicate column
ALTER TABLE employees ADD COLUMN salary NUMERIC;  -- ERROR: column exists

-- Changing to incompatible type
ALTER TABLE employees ALTER COLUMN email TYPE INTEGER;  -- ERROR: can't convert text to int

-- Dropping column used elsewhere
ALTER TABLE employees DROP COLUMN employee_id;  -- ERROR: primary key
```

### Checking Table Structure:
Different databases have different commands:
```sql
-- PostgreSQL
\d employees

-- MySQL
DESC employees;
SHOW COLUMNS FROM employees;

-- SQL Server
sp_help 'employees';
```

---

## 15. UPDATE with CASE - Calculate Bonus

```sql
-- Set bonus depending on department:
--   - Sales: 5% of salary
--   - Everyone else: 2% of salary
UPDATE employees
SET bonus = CASE
  WHEN department = 'Sales' THEN salary * 0.05  -- Higher bonus for Sales.
  ELSE salary * 0.02                            -- Default 2% for other departments (including NULL).
END;

-- Check the final state of the table with bonuses applied.
SELECT * FROM employees ORDER BY employee_id;

-- Trick / Remember:
-- - CASE is like an if/else chain inside SQL.
-- - CASE expressions can be used in SELECT, UPDATE, ORDER BY, etc.
-- - ELSE is optional; if omitted and no WHEN matches, result is NULL.
```

### What This Does:
Calculates and sets bonus amounts based on department:
- Sales department: 5% of salary
- All other departments (including NULL): 2% of salary

### Understanding CASE in UPDATE:
CASE provides conditional logic within SQL. Think of it as IF-THEN-ELSE statements.

### How CASE Works:
```
CASE
  WHEN condition1 THEN result1
  WHEN condition2 THEN result2
  ...
  ELSE default_result
END
```

### For Each Employee:
The UPDATE goes through each row and evaluates:

1. **Is department = 'Sales'?**
   - If YES: bonus = salary × 0.05
   - If NO: Move to ELSE (bonus = salary × 0.02)

### Calculating Bonuses:
From our remaining 7 employees:

1. Employee 1 (NULL department): 35340 × 0.02 = 706.80
2. Employee 2 (IT): 59774 × 0.02 = 1195.48
3. Employee 3 (Finance): 75020 × 0.02 = 1500.40
4. Employee 4 (IT): 59774 × 0.02 = 1195.48
5. Employee 6 (HR): 30000 × 0.02 = 600.00
6. Employee 7 (HR): 50000 × 0.02 = 1000.00
7. Employee 8 (Sales): 64340 × 0.05 = 3217.00  ← Higher rate!

### Expected Final Data:
```
employee_id | first_name | department | salary   | is_active | bonus
------------|------------|------------|----------|-----------|---------
1           | John       | NULL       | 35340.00 | true      | 706.80
2           | John       | IT         | 59774.00 | false     | 1195.48
3           | John       | Finance    | 75020.00 | true      | 1500.40
4           | John       | IT         | 59774.00 | true      | 1195.48
6           | John       | HR         | 30000.00 | true      | 600.00
7           | John       | HR         | 50000.00 | false     | 1000.00
8           | John       | Sales      | 64340.00 | true      | 3217.00
```

### CASE Without ELSE:
```sql
-- If no ELSE and no WHEN matches, bonus becomes NULL
UPDATE employees
SET bonus = CASE
  WHEN department = 'Sales' THEN salary * 0.05
  WHEN department = 'IT' THEN salary * 0.03
  -- No ELSE: other departments get NULL
END;
```

### Multiple WHEN Conditions:
```sql
-- Complex bonus structure
UPDATE employees
SET bonus = CASE
  WHEN department = 'Sales' AND salary > 60000 THEN salary * 0.10
  WHEN department = 'Sales' THEN salary * 0.05
  WHEN department = 'IT' AND is_active = TRUE THEN salary * 0.03
  WHEN department = 'IT' THEN salary * 0.01
  ELSE salary * 0.02
END;
```

### Pro Tip: Using CASE in SELECT
```sql
-- Create a bonus description column
SELECT 
  first_name,
  department,
  bonus,
  CASE
    WHEN bonus > 2000 THEN 'High Bonus'
    WHEN bonus > 1000 THEN 'Medium Bonus'
    ELSE 'Standard Bonus'
  END AS bonus_category
FROM employees;
```

### Common Mistake: Overlapping Conditions
```sql
-- WRONG: Second WHEN never reached
UPDATE employees
SET bonus = CASE
  WHEN salary > 30000 THEN salary * 0.02  -- All salaries > 30000 go here!
  WHEN salary > 50000 THEN salary * 0.05  -- Never reached!
END;

-- CORRECT: Check highest first
UPDATE employees
SET bonus = CASE
  WHEN salary > 50000 THEN salary * 0.05
  WHEN salary > 30000 THEN salary * 0.02
  ELSE 0
END;
```

### Using CASE in ORDER BY:
```sql
-- Custom sorting: Sales first, then active employees
SELECT * FROM employees
ORDER BY
  CASE WHEN department = 'Sales' THEN 1 ELSE 2 END,
  CASE WHEN is_active THEN 1 ELSE 2 END,
  salary DESC;
```

---

## 🎯 Summary & Key Takeaways

### What We've Covered:
1. **Creating tables** with proper data types and constraints
2. **Inserting data** safely with explicit column names
3. **Querying data** with WHERE, ORDER BY, LIMIT
4. **Aggregating data** with GROUP BY and HAVING
5. **Calculating values** with expressions and CASE statements
6. **Modifying data** with UPDATE and DELETE (safely!)
7. **Changing structure** with ALTER TABLE

### Golden Rules to Remember:

1. **Always test UPDATE/DELETE with SELECT first**
2. **Never forget WHERE clause in UPDATE/DELETE** (unless you mean it!)
3. **GROUP BY rule:** Non-aggregate columns in SELECT must be in GROUP BY
4. **HAVING vs WHERE:** WHERE filters rows, HAVING filters groups
5. **NULL handling:** Use IS NULL/IS NOT NULL, not = NULL

### Practice Makes Perfect:
Try these exercises:
1. Add a "years_of_service" column calculated from hire_date
2. Give a 15% raise to employees with 5+ years of service
3. Find departments with more than 2 active employees
4. Create a view showing employee name, department, and total compensation (salary + bonus)

### Final Pro Tip:
Bookmark this guide! Refer back to it whenever you're writing SQL. With practice, these patterns will become second nature.

**Happy querying!** 🚀