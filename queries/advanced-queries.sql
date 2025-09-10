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