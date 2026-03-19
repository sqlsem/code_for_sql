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
-- THOERY
-- =====================================
-- UNIT I : IMPORTANT BASICS
-- ======================================
-- What is DBMS?
-- DBMS (Database Management System) is software used to store, manage, and retrieve data efficiently.
-- It allows multiple users to access data in a controlled manner.
-- It reduces redundancy and ensures data consistency and security.

-- What is schema?
-- A schema is the logical structure or design of a database.
-- It defines tables, attributes, relationships, and constraints.
-- It acts as a blueprint for how data is organized.

-- What is data redundancy?
-- Data redundancy refers to unnecessary duplication of data in a database.
-- It increases storage usage and leads to inconsistency.
-- It can cause update, insertion, and deletion anomalies.

-- What is data abstraction?
-- Data abstraction hides complex database details from users.
-- It shows only relevant information based on user needs.
-- It has three levels: physical, logical, and view level.

-- Three levels of data abstraction
-- Physical level describes how data is stored internally.
-- Logical level defines structure like tables and relationships.
-- View level shows only required data to users.

-- What is ER diagram?
-- ER diagram is a graphical representation of entities and relationships.
-- It shows how data elements are connected in a system.
-- It is used during database design.

-- What are integrity constraints?
-- Integrity constraints are rules to maintain data accuracy and validity.
-- They prevent invalid data entry into the database.
-- Example: primary key must be unique and not NULL.

-- What is DDL and DML?
-- DDL (Data Definition Language) is used to define database structure like CREATE, ALTER.
-- DML (Data Manipulation Language) is used to modify data like INSERT, UPDATE, DELETE.
-- Both are essential parts of SQL.

-- What is data inconsistency?
-- Data inconsistency occurs when same data has different values in different places.
-- It is mainly caused by data redundancy.
-- It leads to incorrect and unreliable information.

-- What is a view?
-- A view is a virtual table created from a query.
-- It does not store data physically but shows data from base tables.
-- It improves security and simplifies complex queries.

-- Who is DBA?
-- DBA (Database Administrator) manages and controls the database system.
-- They handle security, backups, and performance tuning.
-- They ensure smooth database operation.

-- What are entities and attributes?
-- Entities are real-world objects like Student or Employee.
-- Attributes are properties of entities like name or age.
-- They are basic components of database design.
-- ======================================
-- UNIT II : IMPORTANT SQL & RELATIONAL
-- ======================================
-- SQL for σSALARY ≥ 50000 (EMPLOYEE)
SELECT * FROM EMPLOYEE WHERE SALARY >= 50000;

-- SQL for σAGE > 20 (STUDENT)
SELECT * FROM STUDENT WHERE AGE > 20;

-- SQL for πDISTINCT DEPARTMENT (STUDENT)
SELECT DISTINCT DEPARTMENT FROM STUDENT;

-- SQL for πCUST_NAME (σCITY='Chennai' CUSTOMER)
SELECT CUST_NAME FROM CUSTOMER WHERE CITY = 'Chennai';

-- Difference between UNION and UNION ALL
-- UNION combines results and removes duplicate rows.
-- UNION ALL combines results but keeps duplicates.
-- UNION is slower because it performs duplicate elimination.

-- What are aggregate functions?
-- Aggregate functions perform calculations on multiple rows of data.
-- They return a single value as output.
-- Examples include SUM(), AVG(), COUNT(), MAX(), MIN().

-- What is IN operator?
-- IN operator checks whether a value exists in a list or subquery.
-- It simplifies multiple OR conditions in SQL.
-- It is commonly used with WHERE clause.

-- What is EXISTS operator?
-- EXISTS checks whether a subquery returns any result.
-- It returns TRUE if rows exist, otherwise FALSE.
-- It is efficient for checking existence of records.

-- What is nested query?
-- A nested query is a query written inside another query.
-- It is also called a subquery.
-- It is used to perform complex filtering operations.

-- What is JOIN?
-- JOIN is used to combine data from two or more tables.
-- It is based on a related column between tables.
-- Common types include INNER JOIN and OUTER JOIN.

-- What is OUTER JOIN?
-- OUTER JOIN returns matching as well as non-matching rows.
-- Missing values are filled with NULL.
-- Types include LEFT, RIGHT, and FULL OUTER JOIN.

-- What is NULL in SQL?
-- NULL represents missing or unknown data.
-- It is different from zero or empty string.
-- Special operators like IS NULL are used to check it.

-- Selection (σ) operation
-- Selection operation filters rows based on a condition.
-- It reduces the number of tuples in a relation.
-- It is represented using sigma (σ).

-- Projection (π) operation
-- Projection selects specific columns from a table.
-- It reduces the number of attributes.
-- It is represented using pi (π).

-- Relational Algebra vs Relational Calculus
-- Relational Algebra is procedural and specifies how to retrieve data.
-- Relational Calculus is non-procedural and specifies what to retrieve.
-- Both are used for query processing.
-- ======================================
-- UNIT III : IMPORTANT NORMALIZATION
-- ======================================
-- What is normalization?
-- Normalization is the process of organizing data to minimize redundancy.
-- It improves data consistency and eliminates anomalies.
-- It divides tables into smaller related tables.

-- What is 1NF?
-- First Normal Form ensures all attributes have atomic values.
-- It removes repeating groups and multi-valued attributes.
-- Each field contains only one value.

-- What is 2NF?
-- Second Normal Form removes partial dependency.
-- All non-key attributes must depend fully on primary key.
-- It is achieved after 1NF.

-- What is 3NF?
-- Third Normal Form removes transitive dependency.
-- Non-key attributes depend only on primary key.
-- It improves data integrity.

-- What is BCNF?
-- BCNF is a stricter form of 3NF.
-- Every determinant must be a candidate key.
-- It removes anomalies completely.

-- What is functional dependency?
-- Functional dependency means one attribute determines another.
-- Example: Roll No determines Name.
-- It is essential for normalization.

-- What is transitive dependency?
-- Occurs when one attribute depends on another non-key attribute.
-- Example: A → B and B → C, then A → C.
-- It is removed in 3NF.

-- What is partial dependency?
-- Occurs when attribute depends on part of composite key.
-- It violates 2NF.
-- It is removed during normalization.

-- What is candidate key?
-- Candidate key uniquely identifies each record in a table.
-- It has no redundant attributes.
-- One candidate key is chosen as primary key.

-- What is lossless join?
-- Lossless join ensures no data is lost after decomposition.
-- Original table can be reconstructed using joins.
-- It is an important property of normalization.

-- Problems of redundancy
-- Redundancy leads to update, insertion, and deletion anomalies.
-- It increases storage usage.
-- It reduces data consistency.
-- ======================================
-- UNIT IV : IMPORTANT TRANSACTIONS
-- ======================================
-- What is transaction?
-- A transaction is a sequence of database operations.
-- It is treated as a single logical unit.
-- Example: transferring money between accounts.

-- ACID properties
-- ACID ensures reliable transactions in DBMS.
-- It includes Atomicity, Consistency, Isolation, and Durability.
-- These properties maintain data integrity.

-- Atomicity
-- Atomicity ensures all operations complete or none.
-- If one fails, entire transaction is rolled back.
-- Prevents partial updates.

-- Consistency
-- Consistency ensures database remains in valid state.
-- All rules and constraints must be satisfied.
-- No invalid data is allowed.

-- Isolation
-- Isolation ensures transactions execute independently.
-- Intermediate results are hidden from other transactions.
-- Prevents interference.

-- Durability
-- Durability ensures committed data is permanently saved.
-- It survives system failures.
-- Data is stored in stable storage.

-- What is deadlock?
-- Deadlock occurs when transactions wait indefinitely for each other.
-- It blocks system execution.
-- It is detected using wait-for graph.

-- What is concurrency control?
-- Concurrency control manages multiple transactions safely.
-- It prevents conflicts and maintains consistency.
-- It ensures correct execution order.

-- What is serializability?
-- Serializability ensures transactions produce same result as serial execution.
-- It is a correctness criterion.
-- It avoids inconsistencies.

-- What is two-phase locking (2PL)?
-- 2PL is a protocol for concurrency control.
-- It has growing phase (acquire locks) and shrinking phase (release locks).
-- It ensures serializability.

-- What are transaction states?
-- Transaction states include Active, Committed, Failed, and Aborted.
-- They represent lifecycle of a transaction.
-- Used for managing execution.
-- ======================================
-- UNIT V : IMPORTANT FILE ORGANIZATION
-- ======================================

-- What is indexing?
-- Indexing is a technique to improve data retrieval speed.
-- It creates a separate data structure for quick access.
-- It reduces search time.

-- Types of index
-- Primary index is based on primary key.
-- Secondary index is based on non-key attributes.
-- Both improve query performance.

-- Dense vs Sparse index
-- Dense index has an entry for every record.
-- Sparse index has entries for selected records only.
-- Sparse index uses less space.

-- What is hashing?
-- Hashing maps a key to a specific storage location.
-- It uses a hash function.
-- It provides fast direct access.

-- Static vs Dynamic hashing
-- Static hashing uses fixed number of buckets.
-- Dynamic hashing allows bucket size to grow or shrink.
-- Dynamic hashing reduces overflow.

-- What is B+ tree?
-- B+ tree is a balanced tree used for indexing.
-- It stores data in leaf nodes.
-- It supports fast search and range queries.

-- What is RAID?
-- RAID stores data across multiple disks.
-- It improves reliability and performance.
-- It provides data redundancy.

-- What is file organization?
-- File organization defines how records are stored on disk.
-- It affects access speed and performance.
-- Examples: heap, sequential.

-- What is heap file organization?
-- Records are stored in no particular order.
-- It is simple and easy to use.
-- Searching is slower compared to indexed files.