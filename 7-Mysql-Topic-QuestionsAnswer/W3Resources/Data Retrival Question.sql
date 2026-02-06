-- Write a query to display the names (first_name, last_name) using alias name "First Name", "Last Name"

SELECT FIRST_NAME, last_name
from employees;

-- 2. Write a query to get unique department ID from employee table.
select DISTINCT DEPARTMENT_ID
from employees;

-- 3. Write a query to get all employee details from the employee table order by first name, descending.
select *
from employees
ORDER by FIRST_NAME DESC;


-- 4. Write a query to get the names (first_name, last_name), salary, PF of all the employees (PF is calculated as 15% of salary).
SELECT 
     FIRST_NAME, 
     last_name, 
     round(salary,0),
     round(salary * .15, 0) as '15%_salary'
from employees;

-- 5. Write a query to get the employee ID, names (first_name, last_name), salary in ascending order of salary.
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, round(SALARY, 0) as salary
FROM EMPLOYEES
ORDER by salary ASC;


-- 6. Write a query to get the total salaries payable to employees.
select sum(SALARY)
from(
select EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY
from employees) as a;


-- 7. Write a query to get the maximum and minimum salary from employees table.
Select max(salary), min(salary)
from employees;

-- 8. Write a query to get the average salary and number of employees in the employees table.
select round(AVG(salary),2) as average_salary, count(*) as count
from employees


-- 9. Write a query to get the number of employees working with the company.
SELECT count(*)


















