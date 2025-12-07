/* ========================================================================
   EMPLOYEES PRACTICE SCRIPT
   - Covers: CREATE, INSERT, SELECT (WHERE, ORDER BY, LIMIT, GROUP BY, HAVING),
             UPDATE, DELETE, ALTER TABLE, CASE, aggregates
   - Designed for revision: every block is commented + has a demo SELECT.
   - Target: PostgreSQL (SERIAL, BOOLEAN, etc.)
   ======================================================================== */

-- SAFETY: Drop table if it already exists so the script can be re-run.
-- Trick: Always use DROP TABLE IF EXISTS in practice scripts so they are idempotent.
DROP TABLE IF EXISTS employees;

/* ========================================================================
   1. CREATE TABLE
   ======================================================================== */

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

/* ========================================================================
   2. INSERT SAMPLE DATA
   ======================================================================== */

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

/* ========================================================================
   3. SELECT ACTIVE EMPLOYEES ORDERED BY HIRE DATE
   ======================================================================== */

-- Get only active employees, newest hires first.
SELECT *
FROM employees
WHERE is_active = TRUE              -- Filter condition: only rows where is_active is TRUE.
ORDER BY hire_date DESC;            -- DESC: newest date at top.

-- Trick / Remember:
-- - WHERE filters rows BEFORE ORDER BY.
-- - Boolean columns can often be written as WHERE is_active (in PostgreSQL),
--   but using = TRUE is clearer for beginners.

/* ========================================================================
   4. FILTER BY DEPARTMENT AND SALARY RANGE
   ======================================================================== */

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

/* ========================================================================
   5. TOP 3 HIGHEST SALARIES (ORDER BY + LIMIT)
   ======================================================================== */

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

/* ========================================================================
   6. COMPUTED COLUMN (ANNUAL SALARY)
   ======================================================================== */

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

/* ========================================================================
   7. GROUP BY + COUNT PER DEPARTMENT
   ======================================================================== */

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

/* ========================================================================
   8. GROUP BY + HAVING (FILTER AGGREGATES)
   ======================================================================== */

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
-- - You can’t use aggregate functions in WHERE, only in HAVING or SELECT.

/* ========================================================================
   9. COUNT INACTIVE EMPLOYEES
   ======================================================================== */

-- Count how many employees are inactive.
SELECT
  COUNT(*) AS inactive_count
FROM employees
WHERE is_active = FALSE;

-- Trick / Remember:
-- - COUNT(*) counts all rows; efficient with indexes.
-- - Often used to quickly check how many rows match a condition.

/* ========================================================================
   10. UPDATE: GIVE 10% RAISE TO IT DEPARTMENT
   ======================================================================== */

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

/* ========================================================================
   11. UPDATE: MARK OLD HIRES AS INACTIVE
   ======================================================================== */

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

/* ========================================================================
   12. DELETE: REMOVE LOW-SALARY INACTIVE EMPLOYEES
   ======================================================================== */

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

/* ========================================================================
   13. ALTER TABLE: ADD BONUS COLUMN
   ======================================================================== */

-- Add a new bonus column with default 0.00.
ALTER TABLE employees
ADD COLUMN bonus NUMERIC(10,2) DEFAULT 0.00;

-- Check table structure + data to see new column.
SELECT * FROM employees;

-- Trick / Remember:
-- - ALTER TABLE lets you MODIFY schema after creation.
-- - Common operations: ADD COLUMN, DROP COLUMN, RENAME COLUMN, ALTER TYPE.
-- - Adding a column with DEFAULT fills existing rows with that default value.

/* ========================================================================
   14. UPDATE WITH CASE: SET BONUS BASED ON DEPARTMENT
   ======================================================================== */

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

/* ========================================================================
   END OF SCRIPT
   ======================================================================== */
