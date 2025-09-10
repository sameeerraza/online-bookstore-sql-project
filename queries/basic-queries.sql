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