-- active database: classicmodels   (use classicmodels;)

# introduction to the MySQL Subquery
 EXPLAIN SELECT
    lastName,
    firstName
FROM
    employees
WHERE
    officeCode  IN
        (
        SELECT officeCode
        FROM offices
        WHERE country = 'USA'
        );


# 1.1 MySQL subquery:  with comparison operators
SELECT
    customerNumber,
    checkNumber,
    amount
FROM
    payments
WHERE
    amount = (
    SELECT MAX(amount)
    FROM payments
        );

SELECT
    payment_table.customerNumber,
    payment_table.checkNumber,
    payment_table.amount
FROM
    payments as payment_table
JOIN
    (SELECT MAX(amount) AS max_amount FROM payments) AS max_payments_table
ON
    payment_table.amount = max_payments_table.max_amount;



# 1.2 MySQL subquery:  with comparison operators
SELECT
    customerNumber,
    checkNumber,
    amount
FROM
    payments
WHERE
    amount > (
        SELECT AVG(amount)
        FROM payments
            );



SELECT
    payment_table.customerNumber,
    payment_table.checkNumber,
    payment_table.amount
FROM
    payments AS  payment_table
CROSS JOIN
    (SELECT AVG(amount) AS avg_amount FROM payments) AS avg_payments_table
WHERE
    payment_table.amount > avg_payments_table.avg_amount;


# 1.3 MySQL subquery: with IN and NOT IN operators
SELECT
    customerName
FROM
    customers
WHERE
    customerNumber NOT IN (
        SELECT DISTINCT customerNumber
        FROM orders
            );


SELECT
   customers_table.customerName
FROM
   customers as customers_table
LEFT JOIN
   orders as order_table
ON
   customers_table.customerNumber = order_table.customerNumber
WHERE
    order_table.customerNumber IS NULL;



# Example 2: MySQL subquery in the FROM clause

SELECT
  MAX(item_count) AS max_items,
  MIN(item_count) AS min_items,
  FLOOR(AVG(item_count)) AS avg_items
FROM (
  SELECT
    orderNumber,
    COUNT(orderNumber) AS item_count
  FROM
    orderdetails
  GROUP BY
    orderNumber
) AS lineitems;


# MySQL correlated subquery
SELECT
    productname,
    buyprice
FROM
    products as product_table
WHERE
    buyprice > (
        SELECT AVG(buyprice)
        FROM products
        WHERE productline = product_table.productline
        );





SELECT *
FROM products as product_table
WHERE EXISTS (
           SELECT 1
           FROM orderdetails as orderdetails_table
           WHERE orderdetails_table.productCode = product_table.productCode
           );



SELECT *
FROM products as product_table
WHERE NOT EXISTS (
           SELECT 1
           FROM orderdetails as orderdetails_table
           WHERE orderdetails_table.productCode = product_table.productCode
           )


# MySQL Derived Tables

SELECT
    productCode,
    ROUND(SUM(quantityOrdered * priceEach)) as sales
FROM
    orderdetails
INNER JOIN
    orders USING (orderNumber)
WHERE
    YEAR(shippedDate) = 2003
GROUP BY productCode
ORDER BY sales DESC
LIMIT 5;


SELECT
    productName, sales
FROM
    (SELECT
        productCode,
        ROUND(SUM(quantityOrdered * priceEach)) sales
    FROM
        orderdetails
    INNER JOIN orders USING (orderNumber)
    WHERE
        YEAR(shippedDate) = 2003
    GROUP BY productCode
    ORDER BY sales DESC
    LIMIT 5) as top5products2003
INNER JOIN
    products USING (productCode);


# complex sql query
SELECT
    customerNumber,
    ROUND(SUM(quantityOrdered * priceEach)) sales,
    (CASE
        WHEN SUM(quantityOrdered * priceEach) < 10000 THEN 'Silver'
        WHEN SUM(quantityOrdered * priceEach) BETWEEN 10000 AND 100000 THEN 'Gold'
        WHEN SUM(quantityOrdered * priceEach) > 100000 THEN 'Platinum'
    END) customerGroup
FROM
    orderdetails
        INNER JOIN
    orders USING (orderNumber)
WHERE
    YEAR(shippedDate) = 2003
GROUP BY customerNumber;



SELECT
    customerGroup,
    COUNT(cg.customerGroup) AS groupCount
FROM
    (SELECT
        customerNumber,
            ROUND(SUM(quantityOrdered * priceEach)) sales,
            (CASE
                WHEN SUM(quantityOrdered * priceEach) < 10000 THEN 'Silver'
                WHEN SUM(quantityOrdered * priceEach) BETWEEN 10000 AND 100000 THEN 'Gold'
                WHEN SUM(quantityOrdered * priceEach) > 100000 THEN 'Platinum'
            END) customerGroup
    FROM
        orderdetails
    INNER JOIN orders USING (orderNumber)
    WHERE
        YEAR(shippedDate) = 2003
    GROUP BY customerNumber) cg
GROUP BY cg.customerGroup;
Code language: SQL (Structured Query Language) (sql)


# EXIST
SELECT
    customerNumber,
    customerName
FROM
    customers
WHERE
    NOT EXISTS(
	SELECT
            1
        FROM
            orders
        WHERE
            orders.customernumber = customers.customernumber
	);


SELECT
    customerNumber,
    customerName
FROM
    customers
WHERE
    EXISTS(
	SELECT 1
        FROM
            orders
        WHERE
            orders.customernumber
		= customers.customernumber);



SELECT
    customerName,
    COUNT(orderNumber) AS orderCount
FROM
    customers
RIGHT JOIN
    orders ON customers.customerNumber = orders.customerNumber
GROUP BY
    customerName;

SELECT
    employeenumber,
    firstname,
    lastname,
    extension
FROM
    employees
WHERE
    EXISTS(
        SELECT
            1
        FROM
            offices
        WHERE
            city = 'San Francisco' AND
           offices.officeCode = employees.officeCode);


UPDATE employees
SET
    extension = CONCAT(extension, '1')
WHERE
    EXISTS(
        SELECT
            1
        FROM
            offices
        WHERE
            city = 'San Francisco'
                AND offices.officeCode = employees.officeCode);



SELECT DISTINCT r.customer_id
        FROM rental r
        INNER JOIN inventory i ON r.inventory_id = i.inventory_id
        INNER JOIN film f ON i.film_id = f.film_id
        INNER JOIN film_category fc ON f.film_id = fc.film_id
        INNER JOIN category c ON fc.category_id = c.category_id
        WHERE c.name = 'Sci-Fi';
        

SELECT 
    customer_id,
    first_name,
    last_name,
    email
FROM 
    customer
WHERE 
    customer_id IN (
        SELECT DISTINCT r.customer_id
        FROM rental r
        INNER JOIN inventory i ON r.inventory_id = i.inventory_id
        INNER JOIN film f ON i.film_id = f.film_id
        INNER JOIN film_category fc ON f.film_id = fc.film_id
        INNER JOIN category c ON fc.category_id = c.category_id
        WHERE c.name = 'Sci-Fi'
    );



--

SELECT DISTINCT f.film_id
        FROM rental r
        INNER JOIN inventory i ON r.inventory_id = i.inventory_id
        INNER JOIN film f ON i.film_id = f.film_id; 


SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email
FROM 
    customer c
WHERE 
    EXISTS (
        SELECT 1
        FROM rental r
        WHERE r.customer_id = c.customer_id
    );
    
    
SELECT DISTINCT r.customer_id
    FROM rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film_category fc ON i.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
    WHERE c.name = 'Action';
    
    
SELECT customer_id
    FROM rental
    ORDER BY rental_date DESC
    LIMIT 1; 

-- 
SELECT 
    film_id,
    title,
    LENGTH,
    (   SELECT 
            MAX(LENGTH) 
        FROM 
            film) AS longest_film_duration
FROM 
    film
WHERE 
    LENGTH < 
    (   SELECT 
            MAX(LENGTH)
        FROM 
            film )
ORDER BY 
    LENGTH DESC;
    
--
SELECT film_id, 
       title, 
       length,
       (SELECT MAX(length) FROM film) AS longest_film_duration
FROM film; 

-- 
SELECT c.category_id, 
       c.name,
       COUNT(fc.film_id) AS film_count
FROM category c
LEFT JOIN film_category fc ON c.category_id = fc.category_id
GROUP BY c.category_id, 
          c.name
HAVING COUNT(fc.film_id) > (
select avg(films_per_category)
from (
SELECT 
    category_id,
    COUNT(*) AS films_per_category
FROM 
    film_category
GROUP BY 
    category_id) as info); 

-- 

SELECT film_id, title, rental_rate
FROM film
WHERE rental_rate = (
    SELECT MAX(rental_rate)
    FROM film
);

-- 
SELECT
   c.customer_id,
   c.first_name,
   c.last_name,
   SUM(p.amount) AS total_spent,
   ( SELECT
      AVG(customer_total)
   FROM ( SELECT
         customer_id,
         SUM(amount) AS customer_total
      FROM payment
      GROUP BY
         customer_id) AS totals) AS avg_spending
FROM customer c
JOIN payment p 
ON c.customer_id = p.customer_id
GROUP BY
   c.customer_id,
   c.first_name,
   c.last_name
HAVING SUM(p.amount) =
   ( SELECT
      AVG(customer_total)
   FROM ( SELECT
         customer_id,
         SUM(amount) AS customer_total
      FROM payment
      GROUP BY
         customer_id ) AS customer_totals );




































