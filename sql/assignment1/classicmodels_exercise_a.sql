USE classicmodels;

-- 1. Who are the top 5 sales representatives based on revenue generated?
SELECT e.employeeNumber, SUM(p.amount) as totalRev
FROM payments p
LEFT JOIN customers c ON p.customerNumber = c.customerNumber
JOIN employees e ON c.salesRepEmployeeNumber = e.employeeNumber 
GROUP BY e.employeeNumber
ORDER BY totalRev DESC
LIMIT 5;

-- 2. Which product line generates the most revenue?
SELECT pl.productLine, SUM(od.priceEach * od.quantityOrdered) as RevGenerated
FROM orderdetails od
LEFT JOIN products p ON od.productCode = p.productCode
LEFT JOIN productlines pl ON p.productLine = pl.productLine
GROUP BY pl.productLine
ORDER BY RevGenerated DESC
LIMIT 1;

-- 3. Are there products that have never been sold?
SELECT COUNT(*) as productsNotSold
FROM products p
LEFT JOIN orderdetails od ON p.productCode = od.productCode
WHERE od.orderNumber= NULL;

-- 4. How many orders were placed per month in the last year?
SELECT MONTH(o.orderDate) as 2005_Months, COUNT(o.orderNumber)
FROM orders o
WHERE YEAR(o.orderDate) = 2005
GROUP BY MONTH(o.orderDate);

-- 5. What are the most frequently ordered products?
SELECT od.productCode, SUM(od.quantityOrdered) as num_ordered
FROM orderdetails od
GROUP BY od.productCode
ORDER BY num_ordered DESC;

-- Q1 : Write a query using a CTE to find the top 5 customers who have made the highest total payment amount.

WITH cte AS 
(
	SELECT customerNumber, SUM(amount) as total_payment
    FROM payments p
    GROUP BY p.customerNumber
    ORDER BY total_payment DESC
)
SELECT *
FROM cte
LIMIT 5;

-- Q2 : Write a query using a CTE to calculate how many customers each employee (sales rep) manages.

WITH cte AS 
(
	SELECT salesRepEmployeeNumber, COUNT(customerNumber)
    FROM customers c
    GROUP BY salesRepEmployeeNumber
	
)
SELECT * FROM cte;




