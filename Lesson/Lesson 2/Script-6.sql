use classicmodels;

-- -----------------------------------------------------
-- Count and Distinct
-- -----------------------------------------------------

-- QUESTION: Report the total number of payments received before October 28, 2004.
select count(*) from payments p 
where paymentDate < "2004-10-28";

-- QUESTION: Report the number of customer who have made payments before October 28, 2004.
SELECT COUNT(DISTINCT customerNumber) FROM payments WHERE paymentDate<"2004-10-28";

-- QUESTION: Retrieve the list of customer numbers for customer who have made a payment before October 28, 2004.
SELECT DISTINCT customerNumber FROM payments WHERE paymentDate<"2004-10-28";

-- -----------------------------------------------------
-- Chaining Queries
-- -----------------------------------------------------

-- QUESTION: Retrieve the details all customers who have made a payment before October 28, 2004.
SELECT * FROM customers WHERE customerNumber in 
 (SELECT DISTINCT customerNumber FROM payments WHERE paymentDate<"2004-10-28");

-- EXERCISE: Retrieve details of all the customers in the United States who have made payments between April 1st 2003 and March 31st 2004.
select * from customers c
where customerNumber in 
(select distinct customerNumber from payments where paymentDate>"2003-04-01" and paymentDate<"2004-03-31" and country='USA');

-- -----------------------------------------------------
-- Group By and AS
-- -----------------------------------------------------

-- QUESTION: Find the total number of payments made each customer before October 28, 2004.
SELECT customerNumber, COUNT(*) as totalPayments FROM payments WHERE paymentDate<"2004-10-28" GROUP BY customerNumber;

-- -----------------------------------------------------
-- SUM
-- -----------------------------------------------------

-- QUESTION: Find the total amount paid by each customer payment before October 28, 2004.
SELECT customerNumber, SUM(amount) as totalPayment 
   FROM payments WHERE paymentDate<"2004-10-28" 
   GROUP BY customerNumber;

-- EXERCISE: Determine the total number of units sold for each produc
SELECT productcode, SUM(quantityordered) AS sold_units FROM orderdetails GROUP BY productcode;

-- -----------------------------------------------------
-- SUM and COUNT
-- -----------------------------------------------------

-- QUESTION: Find the total no. of payments and total payment amount for each customer for payments made before October 28, 2004.
SELECT customerNumber, 
  COUNT(*) as numberOfPayments,  
  SUM(amount) as totalPayment 
  FROM payments 
  WHERE paymentDate<"2004-10-28" 
  GROUP BY customerNumber;
 
 -- -----------------------------------------------------
-- MIN, MAX and AVERAGE
-- -----------------------------------------------------

-- EXERCISE: Modify the above query to also show the minimum, maximum and average payment value for each customer
 SELECT customerNumber, 
  MIN(amount) AS min_amount,
MAX(amount) AS max_amount, 
AVG(amount) AS average_amount
FROM payments 
WHERE paymentdate < '2004-10-28' GROUP BY customernumber;

-- -----------------------------------------------------
-- Sorting and Pagination
-- -----------------------------------------------------

-- ORDER BY and LIMIT
-- QUESTION: Retrieve the customer number for 10 customers who made the highest total payment in 2004

SELECT customerNumber, SUM(amount) as totalPayment 
	FROM payments 
    WHERE paymentDate<"2004-10-28" 
    GROUP BY customerNumber 
    ORDER BY totalPayment DESC
    LIMIT 10;

-- OFFSET
-- To get the next 10 results, we can simply add an OFFSET with the number of rows to skip.

SELECT customerNumber, SUM(amount) as totalPayment 
	FROM payments 
    WHERE paymentDate<"2004-10-28" 
    GROUP BY customerNumber 
    ORDER BY totalPayment DESC
    LIMIT 10 
    OFFSET 10;
   
-- -----------------------------------------------------
-- Mapping Functions
-- -----------------------------------------------------
   
-- UCASE and CONCAT
-- QUESTION: Display the full name of point of contact each customer in the United States in upper case, along with their phone number, sorted by alphabetical order of customer name.

SELECT customerName, 
	CONCAT(UCASE(contactFirstName), " ", UCASE(contactLastName)) AS contact, 
    phone 
    FROM customers 
    WHERE country="USA" 
    ORDER BY customerName;
   
-- SUBSTRING and LCASE
-- QUESTION: Display a paginated list of customers (sorted by customer name), with a country code column. The country is simply the first 3 letters in the country name, in lower case.
   
   select customerName, 
	LCASE(SUBSTRING(country, 1, 3)) 
    AS countryCode 
    FROM customers ORDER BY customerName;
 
-- ROUND
-- QUESTION: Display the list of the 5 most expensive products in the "Motorcycles" product line with their price (MSRP) rounded to dollars.

   select productName, 
	ROUND(MSRP) AS salePrice 
    FROM products 
    WHERE productLine="Motorcycles" 
    ORDER BY salePrice DESC 
    LIMIT 5;
   
-- -----------------------------------------------------
-- Arithmetic Operations
-- -----------------------------------------------------
  
--    QUESTION: Display the product code, product name, buy price, sale price and profit margin percentage ((MSRP - buyPrice)*100/buyPrice) for the 10 products with the highest profit margin. Round the profit margin to 2 decimals.
 SELECT productCode, 
	productName, 
    buyPrice, 
    MSRP, 
    ROUND(((MSRP - buyPrice)*100/buyPrice), 2) AS profitMargin 
    FROM products 
    ORDER BY profitMargin DESC 
    LIMIT 10;
  
 -- -----------------------------------------------------
-- Working with Dates
-- -----------------------------------------------------
   
-- YEAR
-- QUESTION: List the largest single payment done by every customer in the year 2004, ordered by the transaction value (highest to lowest).
   
   SELECT customerNumber, 
	MAX(amount) AS largestPayment 
    FROM payments 
    WHERE YEAR(paymentDate)=2004 
    GROUP BY customerNumber 
    ORDER BY largestPayment DESC;
  
-- MONTH
-- QUESTION: Show the total payments received month by month for every year.
   
   SELECT YEAR(paymentDate) as `year`, 
	MONTH(paymentDate) as `month`, 
	ROUND(SUM(amount), 2) as `totalPayments`
    FROM payments 
    GROUP BY `year`, `month` 
    ORDER BY `year`, `month`;
  
--   DATE_FORMAT and FORMAT
--    QUESTION: For the above query, format the amount properly with a dollar symbol and comma separation (e.g $26,267.62), and also show the month as a string.
   
SELECT YEAR(paymentDate) as `year`, 
	DATE_FORMAT(paymentDate, "%b") AS `monthName`, 
	CONCAT("$", FORMAT(SUM(amount), 2)) AS `totalPayments`
    FROM payments 
    GROUP BY `year`, MONTH(paymentDate), `monthName` 
    ORDER BY `year`, MONTH(paymentDate);
  
-- -----------------------------------------------------
-- Combining Tables using Joins
-- -----------------------------------------------------
  
--  Inner Join
--    QUESTION: Show the 10 most recent payments with customer details (name & phone no.).
   
SELECT checkNumber, paymentDate, amount, customers.customerNumber, customerName, phone 
	FROM payments JOIN customers 
    ON payments.customerNumber=customers.customerNumber 
    ORDER BY paymentDate DESC LIMIT 10;
   
--    EXERCISE: Show the full office address and phone number for each employee.
   SELECT employees.employeenumber, addressline1,addressline2, phone, offices.officecode 
FROM offices 
JOIN employees ON offices.officecode=employees.officecode;
--    EXERCISE: Show the full order information and product details for order no. 10100.
   
   SELECT ordernumber, products.productcode, products.productname,
products.productdescription,quantityordered, priceeach, 
orderlineNumber FROM orderdetails 
JOIN products ON orderdetails.productcode= products.productcode 
WHERE ordernumber='10100';
   
   
   