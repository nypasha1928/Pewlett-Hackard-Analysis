-- Create table for Employee.
CREATE TABLE employees (
emp_no INT NOT NULL,
birth_date DATE NOT NULL,
first_name VARCHAR NOT NULL,
last_name VARCHAR NOT NULL,
gender VARCHAR NOT NULL,
hire_date DATE NOT NULL,
PRIMARY KEY (emp_no)
);

CREATE TABLE dept_manager (
dept_no VARCHAR(4) NOT NULL,
    emp_no INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE salaries (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no)
);

CREATE TABLE dept_emp (
dept_no varchar NOT NULL,
emp_no INT NOT NULL,
from_date DATE NOT NULL,
to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
PRIMARY KEY (emp_no)
);

CREATE TABLE titles (
emp_no INT NOT NULL,
title INT NOT NULL,
from_date DATE NOT NULL,
to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
PRIMARY KEY (emp_no, title)
);

SELECT* FROM titles;
SELECT* FROM dept_emp;
SELECT* FROM departments;


-- Quick DBD
departments
-
dept_no varchar pk
dept_name varchar 

employees
-
emp_no int pk 
birth_date date
first_name varchar
last_name varchar
gender varchar
hire_date date

dept_emp
-
emp_no int pk FK >- employees.emp_no
dept_no varchar pk fk - departments.dept_no
from_date date
to_date date

dept_manager
-
dept_no varchar pk fk - departments.dept_no
emp_no int pk fk - employees.emp_no
from_date date
to_date date

titles
-
emp_no int pk FK >- employees.emp_no
title VARCHAR pk 
from_date date pk
to_date date 

salaries
-
emp_no int pk FK >- employees.emp_no
salary int pk
from_date date 
to_date date 
_________________________________________
-- 7.3.1 Query Dates

-- Determine Retirement Eligibility

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';
--
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';
__
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';
--
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31';
--
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31';
--
-- Narrow the Search for Retirement Eligibility

-- Retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';
--
-- Retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31') AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
--
-- Count the Queries 
-- Number of employees retiring (COUNT)

SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
------------
-- Create New Tables.(important)

SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
---
SELECT* FROM retirment_info;
------
-- Export Data .
----

---- 7.3.2 Join the Tables .
--Make Sense of Tables with Joins
-- Recreate the retirement_info Table with the emp_no Column

-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;
----------

-- Use Different Types of Joins
-- An inner join:  also known as a simple join, 
-- will return matching data from two tables.
-- A left join (or "left outer join") : will take all of the data from Table 1 
-- and only the matching data from Table 2 .
-- A right join : takes all of the data from Table 2 and only the matching data from Table 1.
-- A full outer join : is a comprehensive join that combines all data from both tables.

-- 7.3.3...  Joins in Action
-- Use Inner Join for Departments and dept-manager Tables .
-- Joining departments and dept_manager tables

SELECT departments.dept_name,
     dept_manager.emp_no,
     dept_manager.from_date,
     dept_manager.to_date
FROM departments
INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no;

-- Use Left Join to Capture retirement-info Table.
-- Joining retirement_info and dept_emp tables
SELECT retirement_info.emp_no,
    retirement_info.first_name,
    retirement_info.last_name,
    dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;


-- Use Aliases for Code Readability.

SELECT ri.emp_no,
    ri.first_name,
    ri.last_name,
    de.to_date
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no;

------------
-- Joining departments and dept_manager tables
SELECT d.dept_name,
       dm.emp_no,
	   dm.from_date,
	   dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;
-------------------------------
-- Use Left Join for retirement_info and dept_emp tables.
SELECT ri.emp_no,
    ri.first_name,
    ri.last_name,
de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');
----------------------------------
--- 7.3.5... Create Additional Lists
--List 1: Employee Information
SELECT * FROM salaries
ORDER BY to_date DESC;
--
SELECT e.emp_no,
    e.first_name,
    e.last_name,
    e.gender,
    s.salary,
    de.to_date
INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND (de.to_date = '9999-01-01');

-- List 2: Management

-- List of managers per department
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);
------

--List 3: Department Retirees
SELECT ce.emp_no,
ce.first_name,
ce.last_name,
d.dept_name
INTO dept_info
FROM current_emp as ce
INNER JOIN dept_emp AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no);
-------------
--7,3,6.. Create a Tailored List
-- List all employees in the Sales department, including their
-- employee number, last name, first name, and department name.
SELECT 
e.emp_no, 
e.last_name, 
e.first_name,
dept_emp.dept_no
INTO sales_info
FROM employees as e
LEFT JOIN dept_emp 
ON e.emp_no=dept_emp.emp_no
INNER JOIN departments 
ON departments.dept_no=dept_emp.dept_no
WHERE departments.dept_name='Sales';
---
--List all employees in the Sales and Development departments, including their 
--employee number, last name, first name, and department name.
SELECT 
e.emp_no, 
e.last_name, 
e.first_name,
dept_emp.dept_no
INTO sales_development_info
FROM employees as e
LEFT JOIN dept_emp 
ON e.emp_no=dept_emp.emp_no
INNER JOIN departments 
ON departments.dept_no=dept_emp.dept_no
WHERE departments.dept_name in ('Sales', 'Development')
----



