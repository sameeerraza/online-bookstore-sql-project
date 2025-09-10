-- Creating Database
CREATE DATABASE OnlineBookStore;

-- Switching to our newly created database
USE OnlineBookStore;

-- Creating Tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
	Book_ID INT IDENTITY(1,1) PRIMARY KEY,
	Title VARCHAR(100),
	Author VARCHAR(100),
	Genre VARCHAR(50),
	Published_Year INT,
	Price DECIMAL(10, 2),
	Stock INT
);

DROP TABLE IF EXISTS Customers;
CREATE TABLE Customers (
	Customer_ID INT IDENTITY(1,1) PRIMARY KEY,
	Name VARCHAR(100),
	Email VARCHAR(100),
	Phone VARCHAR(15),
	City VARCHAR(50),
	Country VARCHAR(150)
);

DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders (
	Order_ID INT IDENTITY(1,1) PRIMARY KEY,
	Customer_ID INT FOREIGN KEY REFERENCES Customers(Customer_ID),
	Book_ID INT FOREIGN KEY REFERENCES Books(Book_ID),
	Order_Date DATE,
	Quantity INT,
	Total_Amount Decimal(10, 2)
);

-- Importing and Inserting Data
INSERT INTO Books (Title, Author, Genre, Published_Year, Price, Stock)
SELECT Title, Author, Genre, Published_Year, Price, Stock
FROM Temp_Books;
DROP TABLE Temp_Books;

INSERT INTO Customers (Name, Email, Phone, City, Country)
SELECT Name, Email, Phone, City, Country
FROM Temp_Customers;
DROP TABLE Temp_Customers;

INSERT INTO Orders (Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount)
SELECT Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount
FROM Temp_Orders;
DROP TABLE Temp_Orders;


SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

-- Basic Queries

-- 1) Retrieving all books in the "Fiction" genre:
SELECT * FROM books WHERE genre = 'Fiction';


-- 2) Finding books published after the year 1950:
SELECT * FROM books WHERE published_year > 1950;


-- 3) Listing all customers from the Canada
SELECT * FROM Customers WHERE country = 'Canada';


-- 4) Showing orders placed in November 2023
-- SELECT * FROM orders WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';
SELECT * FROM orders WHERE order_date LIKE '2023-11-%';


-- 5) Retrieving the total stock of books available
SELECT SUM(stock) AS Total_Stock FROM books;


-- 6) Finding the details of the most expensive book
-- SELECT TOP 1 * FROM books ORDER BY price DESC;
SELECT * FROM books WHERE price = (SELECT MAX(price) FROM books);


-- 7) Showing all customers who ordered more than 1 quantity of a book
SELECT * FROM customers WHERE customer_id IN (SELECT customer_id FROM orders WHERE quantity > 1);


-- 8) Retrieving all orders where the total amount exceeds $20
SELECT * from orders WHERE total_amount > 20;


-- 9) Listing all genres available in the Books Table
SELECT DISTINCT genre FROM books;


-- 10) Finding the books with the lowest stock
SELECT * FROM books WHERE stock IN (SELECT MIN(stock) FROM books);


-- 11) Calculate the total revenue generated from all orders
SELECT SUM(total_amount) AS Total_Revenue FROM orders;


-- Advanced Queries

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

-- 1) Retrieving the total number of books sold for each genre
SELECT b.genre, SUM(o.quantity) AS Total_Books_Sold
FROM orders AS o
JOIN books AS b 
	ON o.book_id = b.book_id
GROUP BY b.genre;


-- 2) Finding the average price of books for each genre
SELECT 
	genre,
	CAST(ROUND(AVG(price), 2) AS DECIMAL(10, 2)) AS AVG_Price
FROM books
GROUP BY genre;


-- 3) Listing customers who have placed at least 2 orders
/*
SELECT *
FROM customers
WHERE customer_id IN (
	SELECT customer_id
	FROM orders
	WHERE quantity >= 2);
	*/

SELECT c.customer_id, c.name, COUNT(o.order_id) AS order_count
FROM orders o
JOIN customers c
	ON o.Customer_ID = c.Customer_ID
GROUP BY c.customer_id, c.name
HAVING count(o.order_id) >= 2;


-- 4) Finding the most frequently ordered books
/*
SELECT TOP 1 
	o.book_id,
	b.title,
	COUNT(o.order_id) AS order_count
FROM orders o
JOIN books b
	ON o.book_id = b.book_id
GROUP BY o.book_id, b.title
ORDER BY order_count DESC;
*/

SELECT TOP 1 
    b.book_id, b.title, 
    SUM(o.quantity) AS highest_ordered
FROM books AS b
JOIN orders AS o
  ON b.book_id = o.book_id
GROUP BY b.book_id, b.title
ORDER BY highest_ordered DESC;


-- 5) Showing the top 3 most expensive book of 'Fantasy' Genre
SELECT TOP 3 book_id, title, price
FROM books
ORDER BY price DESC;


-- 6) Retrieving the total quantity of books sold by each author
SELECT 
	b.author, 
	SUM(o.quantity) AS Total_Quantity
FROM
	books b
JOIN
	orders o
  ON b.book_id = o.book_id
GROUP BY 
	b.author
ORDER BY 
	Total_Quantity DESC;


-- 7) Listing the cities where customers who spent over $30 are located
SELECT DISTINCT c.city, SUM(o.total_amount) AS Amount_Spent
FROM customers c
JOIN orders o
  ON c.Customer_ID = o.Customer_ID
GROUP BY c.customer_id, c.city
HAVING SUM(o.total_amount) > 30;


-- 8) Finding the customer who has spent most on orders
SELECT TOP 1
	c.customer_id, c.name, c.phone, 
	SUM(o.total_amount) AS Amount_Spent
FROM customers c
JOIN orders o
  ON c.Customer_ID = o.Customer_ID
GROUP BY 
	c.customer_id, c.name, c.phone
ORDER BY amount_spent DESC;


-- 9) Calculating the remaining stock after fulfilling all orders
SELECT 
	b.book_id, b.title, b.stock,
	COALESCE(SUM(o.quantity), 0) AS Order_Quantity,
	b.stock - COALESCE(SUM(o.quantity), 0) AS Remaining_Quantity
FROM
	books b
LEFT JOIN
	orders o
  ON b.book_id = o.book_id
GROUP BY
	b.book_id, b.title, b.stock
ORDER BY
	b.book_id;


-- Ranking by book price
SELECT title, author, price,
       ROW_NUMBER() OVER (PARTITION BY genre ORDER BY price DESC) as price_rank
FROM books;


-- Using CTE to check total amount spent by each customer
WITH customer_spending AS (
    SELECT customer_id, SUM(total_amount) as total_spent
    FROM orders
    GROUP BY customer_id
)
SELECT c.name, cs.total_spent
FROM customers c
JOIN customer_spending cs ON c.customer_id = cs.customer_id;