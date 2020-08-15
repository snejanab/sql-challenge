-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.

-- Modify this code to update the DB schema diagram.
-- To reset the sample schema, replace everything with
-- two dots ('..' - without quotes).

CREATE TABLE "employees" (
    "emp_no" int   NOT NULL,
    "emp_title_id" varchar   NOT NULL,
    "birth_date" date   NOT NULL,
    "first_name" varchar   NOT NULL,
    "last_name" varchar   NOT NULL,
    "sex" varchar   NOT NULL,
    "hire_date" date   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "depts" (
    "dept_no" varchar   NOT NULL,
    "dept_name" varchar   NOT NULL,
    CONSTRAINT "pk_depts" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "dept_emp" (
    "emp_no" int   NOT NULL,
    "dept_no" varchar   NOT NULL
);

CREATE TABLE "dept_manager" (
    "dept_no" varchar   NOT NULL,
    "emp_no" int   NOT NULL,
    CONSTRAINT "pk_dept_manager" PRIMARY KEY (
        "dept_no","emp_no"
     )
);

CREATE TABLE "salaries" (
    "emp_no" int   NOT NULL,
    "salary" int   NOT NULL
);

CREATE TABLE "titles" (
    "title_id" varchar   NOT NULL,
    "title" varchar   NOT NULL,
    CONSTRAINT "pk_titles" PRIMARY KEY (
        "title_id"
     )
);

ALTER TABLE "employees" ADD CONSTRAINT "fk_employees_emp_title_id" FOREIGN KEY("emp_title_id")
REFERENCES "titles" ("title_id");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "depts" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "depts" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

-- 1. List the following details of each employee: employee number, last name, first name, sex, and salary.

SELECT employees.emp_no as "Emp Number", employees.last_name as "Emp Last Name", employees.first_name as "Emp First Name", 
employees.sex "Emp Gender", salaries.salary as "Emp Salary"
FROM salaries
INNER JOIN employees ON 
employees.emp_no=salaries.emp_no;


-- 2. List first name, last name, and hire date for employees who were hired in 1986.

SELECT first_name as "Emp First Name", last_name as "Emp Last Name", hire_date as "Emp Hire Date" 
FROM employees
WHERE hire_date BETWEEN '1986-01-01' AND '1986-12-31' ;

-- 3. List the manager of each department with the following information: 
--    department number, department name, the manager's employee number, last name, first name.

SELECT depts.dept_no as "Dept Number", depts.dept_name as "Department Number", dept_manager.emp_no "Employee Number", 
employees.last_name as "Emp Last Name", employees.first_name as "Emp First Name" 
FROM dept_manager
INNER JOIN employees ON 
employees.emp_no=dept_manager.emp_no
INNER JOIN dept_emp ON
dept_emp.emp_no=employees.emp_no
INNER JOIN depts ON
dept_emp.dept_no=depts.dept_no;


-- 4. List the department of each employee with the following information: employee number, last name, first name, and department name. 

SELECT employees.emp_no as "Emp Number", employees.last_name as "Emp Last Name", 
employees.first_name as "Emp First Name", employees.sex as "Emp Gender", depts.dept_name as "Dept Name"
FROM dept_emp
INNER JOIN employees ON 
employees.emp_no=dept_emp.emp_no
INNER JOIN depts ON
dept_emp.dept_no=depts.dept_no;


-- 5. List first name, last name, and sex for employees whose first name is "Hercules" and last names begin with "B."

SELECT first_name as "Emp First Name", last_name as "Emp Last Name", sex as "Emp Gender" 
FROM employees
WHERE first_name = 'Hercules' AND last_name LIKE 'B%';

-- 6. List all employees in the Sales department, including their employee number, last name, first name, and department name.
SELECT employees.emp_no as "Emp Number", employees.last_name as "Emp Last Name", 
employees.first_name as "Emp First Name", sex as "Emp Gender", depts.dept_name as "Dept Name"
FROM dept_emp
INNER JOIN employees ON 
employees.emp_no=dept_emp.emp_no
INNER JOIN depts ON
dept_emp.dept_no=depts.dept_no
WHERE dept_name = 'Sales';

-- 7. List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.

SELECT employees.emp_no as "Emp Number", employees.last_name as "Emp Last Name", employees.first_name "Emp First Name", 
depts.dept_name as "Dept Name"
FROM dept_emp
INNER JOIN employees ON 
employees.emp_no=dept_emp.emp_no
INNER JOIN depts ON
dept_emp.dept_no=depts.dept_no
WHERE dept_name = 'Sales' OR dept_name = 'Development'
ORDER BY dept_name;

-- 8. In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.
SELECT last_name as "Emp Last Name", COUNT(*) as "Name Count"
FROM employees
GROUP BY last_name
ORDER BY COUNT(*) DESC;

-- Epilogue: Search your ID number." You look down at your badge to see that your employee ID number is 499942.
SELECT emp_no as "Emp Number", first_name as "Emp First Name", last_name as "Emp Last Name", sex as "Emp Gender", hire_date as "Emp Hire Date" 
FROM employees
WHERE emp_no = '499942';
