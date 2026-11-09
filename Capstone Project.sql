-- Creating Customers Table
CREATE TABLE Customers(
	Customer_id VARCHAR(20) PRIMARY KEY,
	Company_Name VARCHAR(50),
	Contact_Name  VARCHAR(50),
	Title VARCHAR(50),
	City VARCHAR(25),
	Country VARCHAR(30)
	
);


--Creating Categories Table
CREATE TABLE Categories(
	Category_id INTEGER PRIMARY KEY,
	Category_name VARCHAR(20),
	Description VARCHAR(100)

);

--Creating Products Table
CREATE TABLE Products(
	Product_id INTEGER PRIMARY KEY,
	Product_name VARCHAR(50),
	Quantity_per_unit VARCHAR(50),
	Unit_price NUMERIC (10,2),
	Discontinued INTEGER,
	Category_id INTEGER,
	FOREIGN KEY (Category_id) REFERENCES Categories(Category_id)
	
);





--Creating Employees Table
CREATE TABLE Employees(
	Employee_id INTEGER PRIMARY KEY,
	Employee_name VARCHAR(25),
	Title VARCHAR(50),
	City VARCHAR(15),
	Country VARCHAR(10),
	Reports_to INTEGER
);

--Creating Shippers Table
CREATE TABLE Shippers(
	Shipper_id INTEGER PRIMARY KEY,
	Company_name VARCHAR(30)
);

--Creating Orders Table
CREATE TABLE Orders(
	Order_id INTEGER PRIMARY KEY,
	Customer_id VARCHAR,
	FOREIGN KEY (Customer_id) REFERENCES Customers(Customer_id),
	Employee_id INTEGER,
	Order_date DATE,
	Required_date DATE,
	Shipped_date DATE,
	Shipper_id INTEGER,
	FOREIGN KEY (Shipper_id) REFERENCES Shippers(Shipper_id),
	Freight NUMERIC(10,2)
);

--Creating Order Details Table
CREATE TABLE Order_details(
	Order_id INTEGER,
	Product_id INTEGER,
	FOREIGN KEY (Order_id) REFERENCES Orders(Order_id),
	FOREIGN KEY (Product_id) REFERENCES Products(Product_id),
	Quantity INTEGER,
	Discount NUMERIC(10,2)
);


--QUESTION 1
/*How have total orders and revenue changed over time, and are there any
noticeable sales trends?*/

SELECT 
    COUNT(o.order_id) AS Total_orders,
    SUM(p.unit_price * d.quantity) AS Total_revenue
FROM order_details AS d
JOIN Products AS p
    ON p.product_id = d.product_id
JOIN Orders AS o
    ON o.order_id = d.order_id
WHERE EXTRACT(YEAR FROM o.order_date) IN (2013, 2014,2015)



--QUESTION 2
/*Which products are the best-selling and worst-selling based on sales quantity?*/


SELECT 
	product_name,
	SUM (quantity) AS sales_quantity
FROM order_details AS d
JOIN products AS p
ON p.product_id = d.product_id
GROUP BY product_name
ORDER BY sales_quantity DESC

--QUESTION 3
/*Which customers generate the highest number of orders and contribute the
most revenue?*/



SELECT 
    title,
    COUNT(DISTINCT o.order_id) AS Total_orders,
    SUM(p.unit_price * d.quantity) AS Total_revenue
FROM customers AS c
JOIN orders AS o
    ON o.customer_id = c.customer_id
JOIN order_details AS d
    ON d.order_id = o.order_id
JOIN products AS p
    ON p.product_id = d.product_id
GROUP BY title
ORDER BY Total_revenue DESC;


--QUESTION 4
/*Are shipping costs consistent across different shipping providers?*/
SELECT 
	s.company_name,
	AVG(o.freight) AS Average_shipping_cost
FROM shippers AS s
JOIN orders AS o
ON o.shipper_id = s.shipper_id
GROUP BY s.company_name

--QUESTION 5
/*5. How efficient is the delivery process, and how many orders are delivered on
time versus late?*/

SELECT 
	shipped_date - order_date AS Days
FROM Orders
ORDER BY days DESC

--B.And how many orders are delivered ontime versus late?

SELECT
    CASE
        WHEN shipped_date <= required_date THEN 'On Time'
        WHEN shipped_date > required_date THEN 'Late'
        ELSE 'Not Shipped'
    END AS Delivery_Status,
    COUNT(order_id) AS Total_Orders
FROM Orders
GROUP BY Delivery_Status
ORDER BY Delivery_Status;






