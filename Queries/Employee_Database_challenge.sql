-- Deliverable 1 (step 1 to 7)
SELECT e.emp_no,
e.first_name, 
e.last_name,
titles.title,
titles.from_date,
titles.to_date 

INTO retirement_titles
FROM employees as e
INNER JOIN titles
ON e.emp_no = titles.emp_no
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY emp_no, from_date, to_date DESC;
---
-- Deliverable 1 ( step 8 to 14)

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no) emp_no,
first_name,
last_name,
title

--INTO unique_titles
FROM retirement_titles
ORDER BY emp_no, title DESC;
---
-- Deliverable 1 ( step 14 to 21)

SELECT COUNT(ut.emp_no), ut.title
INTO retiring_titles
FROM unique_titles as ut

GROUP BY ut.title
ORDER BY ut.count DESC;