-- =====================================================
-- CIA 1
-- =====================================================
-- TOPIC: DATABASE CREATION 
-- =====================================================
CREATE DATABASE complete_db;
USE complete_db;
-- =====================================================
-- TOPIC: TABLE CREATION WITH CONSTRAINTS
-- =====================================================
CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50) NOT NULL,
    location VARCHAR(50) NOT NULL
);
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50) NOT NULL,
    salary DECIMAL(10,2) NOT NULL,
    dept_id INT,
    manager_id INT,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);
-- =====================================================
-- TOPIC: DATA INSERTION
-- =====================================================
INSERT INTO departments VALUES
(1, 'IT', 'Chennai'),
(2, 'HR', 'Bangalore'),
(3, 'Finance', 'Mumbai'),
(4, 'Marketing', 'Delhi');

INSERT INTO employees VALUES
(101, 'Anu', 60000, 1, NULL),
(102, 'Ravi', 45000, 2, 101),
(103, 'Meena', 70000, 1, 101),
(104, 'Karthik', 30000, 3, NULL),
(105, 'Sita', 50000, NULL, NULL);

-- =====================================================
-- TOPIC: SELECT (DATA RETRIEVAL)
-- =====================================================
SELECT * FROM employees;

-- =====================================================
-- TOPIC: PROJECTION
-- =====================================================
SELECT emp_name, salary FROM employees;

-- =====================================================
-- TOPIC: WHERE CLAUSE (SELECTION)
-- =====================================================
SELECT * FROM employees WHERE salary > 50000;

-- =====================================================
-- TOPIC: COMPARISON OPERATORS
-- =====================================================
SELECT * FROM employees WHERE salary != 30000;

-- =====================================================
-- TOPIC: LOGICAL OPERATORS (AND, OR, NOT)
-- =====================================================
SELECT * FROM employees WHERE dept_id = 1 AND salary > 50000;
SELECT * FROM employees WHERE dept_id = 2 OR dept_id = 3;
SELECT * FROM employees WHERE NOT dept_id = 4;

-- =====================================================
-- TOPIC: NULL HANDLING
-- =====================================================
SELECT * FROM employees WHERE manager_id IS NULL;

-- =====================================================
-- TOPIC: AGGREGATE FUNCTIONS
-- =====================================================
SELECT COUNT(*) FROM employees;
SELECT AVG(salary) FROM employees;
SELECT MAX(salary), MIN(salary) FROM employees;
SELECT SUM(salary) FROM employees;

-- =====================================================
-- TOPIC: GROUP BY  (MISSING TOPIC ADDED)
-- =====================================================
SELECT dept_id, COUNT(*) AS total_employees
FROM employees
GROUP BY dept_id;

-- =====================================================
-- TOPIC: HAVING  (MISSING TOPIC ADDED)
-- =====================================================
SELECT dept_id, COUNT(*) AS total
FROM employees
GROUP BY dept_id
HAVING COUNT(*) > 1;

-- =====================================================
-- TOPIC: ORDER BY  (MISSING TOPIC ADDED)
-- =====================================================
SELECT * FROM employees ORDER BY salary ASC;
SELECT * FROM employees ORDER BY salary DESC;

-- =====================================================
-- TOPIC: DISTINCT  (MISSING TOPIC ADDED)
-- =====================================================
SELECT DISTINCT dept_id FROM employees;

-- =====================================================
-- TOPIC: INNER JOIN
-- =====================================================
SELECT e.emp_name, d.dept_name
FROM employees e
INNER JOIN departments d
ON e.dept_id = d.dept_id;

-- =====================================================
-- TOPIC: LEFT JOIN
-- =====================================================
SELECT e.emp_name, d.dept_name
FROM employees e
LEFT JOIN departments d
ON e.dept_id = d.dept_id;

-- =====================================================
-- TOPIC: RIGHT JOIN
-- =====================================================
SELECT e.emp_name, d.dept_name
FROM employees e
RIGHT JOIN departments d
ON e.dept_id = d.dept_id;

-- =====================================================
-- TOPIC: CROSS JOIN
-- =====================================================
SELECT *
FROM employees
CROSS JOIN departments;

-- =====================================================
-- TOPIC: UNION
-- =====================================================
SELECT dept_id FROM employees
UNION
SELECT dept_id FROM departments;

-- =====================================================
-- TOPIC: SUBQUERY (IN / NOT IN)
-- =====================================================
SELECT emp_name
FROM employees
WHERE dept_id IN (
    SELECT dept_id FROM departments WHERE location = 'Chennai'
);

-- =====================================================
-- TOPIC: EXISTS / NOT EXISTS
-- =====================================================
SELECT dept_name
FROM departments d
WHERE EXISTS (
    SELECT * FROM employees e WHERE e.dept_id = d.dept_id
);

-- =====================================================
-- TOPIC: SUBQUERY WITH AGGREGATE
-- =====================================================
SELECT emp_name
FROM employees
WHERE salary > (
    SELECT AVG(salary) FROM employees
);

-- =====================================================
-- TOPIC: ANY / ALL
-- =====================================================
SELECT emp_name
FROM employees
WHERE salary > ANY (
    SELECT salary FROM employees WHERE dept_id = 2
);

-- =====================================================
-- TOPIC: UPDATE  (MISSING TOPIC ADDED)
-- =====================================================
UPDATE employees
SET salary = salary + 5000
WHERE emp_id = 101;

-- =====================================================
-- TOPIC: DELETE  (MISSING TOPIC ADDED)
-- =====================================================
DELETE FROM employees
WHERE emp_id = 105;

-- =====================================================
-- TOPIC: ALTER TABLE  (MISSING TOPIC ADDED)
-- =====================================================
ALTER TABLE employees ADD email VARCHAR(50);

-- =====================================================
-- TOPIC: DROP TABLE  (MISSING TOPIC ADDED)
-- =====================================================
DROP TABLE departments;

-- ======================================================
-- NORMALISATION
-- ======================================================
CREATE SCHEMA CUSTOMER_DBS;
USE CUSTOMER_DBS;

-- 1NF Table

CREATE TABLE CustomerOrders (
order_id VARCHAR(5),
order_date DATE,
cust_id VARCHAR(5),
cust_name VARCHAR(50),
cust_city VARCHAR(50),
product_id VARCHAR(5),
product_name VARCHAR(50),
price INT,
sales_id VARCHAR(5),
sales_name VARCHAR(50),
PRIMARY KEY (order_id, product_id)
);

INSERT INTO CustomerOrders VALUES
('O1','2024-01-10','C1','Meena','Chennai','P1','Laptop',60000,'S1','Arjun'),
('O1','2024-01-10','C1','Meena','Chennai','P2','Mouse',800,'S1','Arjun'),
('O2','2024-01-11','C2','Rahul','Mumbai','P3','Printer',15000,'S2','Kavya'),
('O3','2024-01-12','C3','Anil','Delhi','P1','Laptop',60000,'S1','Arjun'),
('O3','2024-01-12','C3','Anil','Delhi','P4','Keyboard',1500,'S3','Ramesh');

SELECT * FROM CustomerOrders;
-- =====================================
-- a) First Normal Form (1NF)
-- Ensure atomic values and remove repeating groups.
-- Each column contains a single value.
-- The composite key (order_id, product_id) uniquely identifies each row.
-- =====================================

-- Orders table 2NF
CREATE TABLE Orders (
order_id VARCHAR(5) PRIMARY KEY,
order_date DATE,
cust_id VARCHAR(5),
sales_id VARCHAR(5)
);

INSERT INTO Orders VALUES
('O1','2024-01-10','C1','S1'),
('O2','2024-01-11','C2','S2'),
('O3','2024-01-12','C3','S1');

-- Products table
CREATE TABLE Products (
product_id VARCHAR(5) PRIMARY KEY,
product_name VARCHAR(50),
price INT
);

INSERT INTO Products VALUES
('P1','Laptop',60000),
('P2','Mouse',800),
('P3','Printer',15000),
('P4','Keyboard',1500);

-- Order Items table
CREATE TABLE Order_Items (
order_id VARCHAR(5),
product_id VARCHAR(5),
PRIMARY KEY (order_id, product_id)
);

INSERT INTO Order_Items VALUES
('O1','P1'),
('O1','P2'),
('O2','P3'),
('O3','P1'),
('O3','P4');

SELECT * FROM Orders;
SELECT * FROM Products;
SELECT * FROM Order_Items;


-- =====================================
-- b) Second Normal Form (2NF)
-- Remove partial dependency from the composite key (order_id, product_id).
-- Attributes depending only on order_id and product_id are separated.
-- Tables created: Orders, Products, Order_Items.
-- =====================================

-- Customers table 3NF
CREATE TABLE Customers (
cust_id VARCHAR(5) PRIMARY KEY,
cust_name VARCHAR(50),
cust_city VARCHAR(50)
);

INSERT INTO Customers VALUES
('C1','Meena','Chennai'),
('C2','Rahul','Mumbai'),
('C3','Anil','Delhi');

-- Salespersons table
CREATE TABLE Salespersons (
sales_id VARCHAR(5) PRIMARY KEY,
sales_name VARCHAR(50)
);

INSERT INTO Salespersons VALUES
('S1','Arjun'),
('S2','Kavya'),
('S3','Ramesh');

SELECT * FROM Customers;
SELECT * FROM Salespersons;
SELECT * FROM Orders;
SELECT * FROM Products;
SELECT * FROM Order_Items;

-- =====================================
-- c) Third Normal Form (3NF)
-- Remove transitive dependency.
-- cust_id determines cust_name and cust_city.
-- sales_id determines sales_name.
-- New tables created: Customers and Salespersons.
-- =====================================

 -- BCNF
SELECT * FROM Customers;
SELECT * FROM Salespersons;
SELECT * FROM Orders;
SELECT * FROM Products;
SELECT * FROM Order_Items;
-- =====================================
-- d) Boyce-Codd Normal Form (BCNF)
-- In all relations, the determinants are candidate keys.
-- Therefore the tables already satisfy BCNF.
-- No further decomposition is required.
-- =====================================


-- =====================================
-- TRANSACTIONS
-- =====================================
CREATE SCHEMA UNIVERSITY_DB;
USE UNIVERSITY_DB;

-- A) Create table UniversityAccounts
-- CHECK constraint ensures balance cannot be negative
CREATE TABLE UniversityAccounts (
account_id INT PRIMARY KEY,
holder_name VARCHAR(50),
balance INT CHECK (balance >= 0)
);

-- Insert given records into the table
INSERT INTO UniversityAccounts VALUES (301,'Priya',12000);
INSERT INTO UniversityAccounts VALUES (302,'Aravind',7000);
INSERT INTO UniversityAccounts VALUES (303,'Sneha',9000);

-- Display the table
SELECT * FROM UniversityAccounts;

-- B) 
-- Start a transaction to transfer money
START TRANSACTION;

-- Deduct ₹1500 from account 301
UPDATE UniversityAccounts
SET balance = balance - 1500
WHERE account_id = 301;

-- Add ₹1500 to account 302
UPDATE UniversityAccounts
SET balance = balance + 1500
WHERE account_id = 302;

-- Save the transaction permanently
COMMIT;

-- Display updated balances
SELECT * FROM UniversityAccounts; 

-- C)
-- Create stored procedure to transfer money between accounts
DELIMITER //

CREATE PROCEDURE TransferAmountProc(
IN sender INT,
IN receiver INT,
IN amount INT
)
BEGIN

-- Variable to store sender balance
DECLARE current_balance INT;

-- Start transaction
START TRANSACTION;

-- Get sender balance
SELECT balance INTO current_balance
FROM UniversityAccounts
WHERE account_id = sender;

-- Check if sufficient balance exists
IF current_balance >= amount THEN

-- Deduct amount from sender
UPDATE UniversityAccounts
SET balance = balance - amount
WHERE account_id = sender;

-- Add amount to receiver
UPDATE UniversityAccounts
SET balance = balance + amount
WHERE account_id = receiver;

-- Save transaction
COMMIT;

ELSE

-- Cancel transaction if balance insufficient
ROLLBACK;

END IF;

END //

DELIMITER ;

-- D) -- Start transaction
START TRANSACTION;

-- Attempt to deduct ₹4000 from account 303
UPDATE UniversityAccounts
SET balance = balance - 4000
WHERE account_id = 303;

SELECT * FROM UniversityAccounts;

-- Cancel the transaction
ROLLBACK;

-- Display table to show balance unchanged
SELECT * FROM UniversityAccounts;

-- E)
-- Start transaction
START TRANSACTION;
-- Deduct ₹800 from account 301
UPDATE UniversityAccounts
SET balance = balance - 800
WHERE account_id = 301;
-- Create a savepoint
SAVEPOINT sp1;
-- Deduct ₹600 from account 302
UPDATE UniversityAccounts
SET balance = balance - 600
WHERE account_id = 302;
-- Rollback to savepoint (undo second deduction)
ROLLBACK TO sp1;
-- Commit remaining change
COMMIT;
-- Display final balances
SELECT * FROM UniversityAccounts;
-- =====================================
