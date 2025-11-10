/* ASSIGNMENT 1 */
/* SECTION 2 */


--SELECT
/* 1. Write a query that returns everything in the customer table. */

SELECT customer_id, customer_first_name, customer_last_name, customer_postal_code -- returns everything

FROM customer; -- table


/* 2. Write a query that displays all of the columns and 10 rows from the cus- tomer table, 
sorted by customer_last_name, then customer_first_ name. */

SELECT customer_id, customer_first_name, customer_last_name, customer_postal_code -- returns all columns

FROM customer -- table 

--WHERE 10; -- 10 rows from customer table

ORDER BY customer_last_name, customer_first_name -- sorted by customer_last_name,  customer_first_name

LIMIT 10; -- limits to 10 rows

--WHERE
/* 1. Write a query that returns all customer purchases of product IDs 4 and 9. */

SELECT product_id, vendor_id, market_date, customer_id, quantity, cost_to_customer_per_qty, transaction_time

FROM customer_purchases

WHERE product_id = '4'
OR product_id = '9';


/*2. Write a query that returns all customer purchases and a new calculated column 'price' (quantity * cost_to_customer_per_qty), 
filtered by customer IDs between 8 and 10 (inclusive) using either:
	1.  two conditions using AND
	2.  one condition using BETWEEN
*/
-- option 1

SELECT product_id, vendor_id, market_date, customer_id, quantity, cost_to_customer_per_qty,
transaction_time, quantity*cost_to_customer_per_qty AS price -- customer purchases and new price column

FROM customer_purchases

WHERE customer_id <= 10 AND customer_id >= 8; -- uses two conditions

-- option 2

SELECT product_id, vendor_id, market_date, customer_id, quantity, cost_to_customer_per_qty,
transaction_time, quantity*cost_to_customer_per_qty AS price -- customer purchases and new price column

FROM customer_purchases

WHERE customer_id BETWEEN 8 AND 10; -- uses one condition using BETWEEN


--CASE
/* 1. Products can be sold by the individual unit or by bulk measures like lbs. or oz. 
Using the product table, write a query that outputs the product_id and product_name
columns and add a column called prod_qty_type_condensed that displays the word “unit” 
if the product_qty_type is “unit,” and otherwise displays the word “bulk.” */

SELECT 
product_id, -- outputs product_id and product_name
product_name,

CASE -- adds column prod_qty_type
	WHEN product_qty_type = 'unit' THEN 'unit' 
	ELSE 'bulk' 
END AS prod_qty_type

FROM product; 

/* 2. We want to flag all of the different types of pepper products that are sold at the market. 
add a column to the previous query called pepper_flag that outputs a 1 if the product_name 
contains the word “pepper” (regardless of capitalization), and otherwise outputs 0. */

SELECT
product_id, -- outputs product_id and product_name
product_name,

CASE -- adds column prod_qty_type
	WHEN product_qty_type = 'unit' THEN 'unit' 
	ELSE 'bulk' 
END AS prod_qty_type,

CASE 
	WHEN product_name LIKE '%pepper%' THEN 1
	ELSE 0
END AS pepper_flag

FROM product; 

--JOIN
/* 1. Write a query that INNER JOINs the vendor table to the vendor_booth_assignments table on the 
vendor_id field they both have in common, and sorts the result by vendor_name, then market_date. */

SELECT DISTINCT
v.vendor_id,
vendor_name,
vendor_type,
vendor_owner_first_name,
vendor_owner_last_name,
booth_number,
market_date 

FROM vendor as v
INNER JOIN vendor_booth_assignments as vba
	ON v.vendor_id = vba.vendor_id;


/* SECTION 3 */

-- AGGREGATE
/* 1. Write a query that determines how many times each vendor has rented a booth 
at the farmer’s market by counting the vendor booth assignments per vendor_id. */

SELECT vendor_id, booth_number, COUNT(*) AS assignments -- counts number of assignments
FROM vendor_booth_assignments
GROUP by vendor_id, booth_number;

/* 2. The Farmer’s Market Customer Appreciation Committee wants to give a bumper 
sticker to everyone who has ever spent more than $2000 at the market. Write a query that generates a list 
of customers for them to give stickers to, sorted by last name, then first name. 

HINT: This query requires you to join two tables, use an aggregate function, and use the HAVING keyword. */

SELECT DISTINCT 
c.customer_id,
customer_first_name,
customer_last_name,
SUM(quantity*cost_to_customer_per_qty) AS total_spending -- total spending calculation

FROM customer as c

INNER JOIN customer_purchases as cp ON c.customer_id = cp.customer_id
	
GROUP BY c.customer_id

HAVING total_spending > 2000 -- spending exceeding $2000

ORDER BY customer_last_name, customer_first_name; -- sorting by last name, then first name


--Temp Table
/* 1. Insert the original vendor table into a temp.new_vendor and then add a 10th vendor: 
Thomass Superfood Store, a Fresh Focused store, owned by Thomas Rosenthal

HINT: This is two total queries -- first create the table from the original, then insert the new 10th vendor. 
When inserting the new vendor, you need to appropriately align the columns to be inserted 
(there are five columns to be inserted, I've given you the details, but not the syntax) 

-> To insert the new row use VALUES, specifying the value you want for each column:
VALUES(col1,col2,col3,col4,col5) 
*/

CREATE TABLE temp.new_vendor (
	vendor_id,
	vendor_name,
	vendor_type,
	vendor_owner_first_name,
	vendor_owner_last_name
);

INSERT INTO temp.new_vendor(vendor_id, vendor_name, vendor_type, vendor_owner_first_name, vendor_owner_last_name)
SELECT vendor_id, vendor_name, vendor_type, vendor_owner_first_name, vendor_owner_last_name 
FROM vendor;

INSERT INTO temp.new_vendor
VALUES('10', 'Thomas Superfood Store', 'a Fresh Focused store', 'Thomas', 'Rosenthal')
