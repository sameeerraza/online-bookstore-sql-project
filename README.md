# Online Bookstore Database Project

A comprehensive SQL database project demonstrating database design, data manipulation, and advanced querying techniques for an online bookstore system.

## 🎯 Project Overview

This project showcases SQL skills through the creation and management of an online bookstore database, including:
- Database schema design and normalization
- Data import from Excel files
- Basic and advanced SQL queries
- Business intelligence and analytics queries

## 📊 Database Schema

The database consists of three main tables:

### Books Table
- `Book_ID` (Primary Key)
- `Title`, `Author`, `Genre`
- `Published_Year`, `Price`, `Stock`

### Customers Table
- `Customer_ID` (Primary Key)
- `Name`, `Email`, `Phone`
- `City`, `Country`

### Orders Table
- `Order_ID` (Primary Key)
- `Customer_ID` (Foreign Key)
- `Book_ID` (Foreign Key)
- `Order_Date`, `Quantity`, `Total_Amount`

## 🔧 Technologies Used

- **Database**: SQL Server
- **Data Source**: Excel files (Books, Customers, Orders)
- **Tools**: SQL Server Management Studio

## 📁 Project Structure

```
├── database/
│   └── onlinebookstore.sql     # Main SQL script with schema and queries
├── data/
│   ├── books.xlsx              # Sample books data
│   ├── customers.xlsx          # Sample customer data
│   └── orders.xlsx             # Sample orders data
└── README.md                   # Project documentation
```

## 🚀 Getting Started

### Prerequisites
- SQL Server or SQL Server Express
- SQL Server Management Studio (SSMS)

### Setup Instructions

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/online-bookstore-sql-project.git
   ```

2. **Import data into temporary tables**
   - Import the Excel files into temporary tables (`Temp_Books`, `Temp_Customers`, `Temp_Orders`)
   - Or modify the script to use direct INSERT statements

3. **Run the SQL script**
   - Open `database/onlinebookstore.sql` in SSMS
   - Execute the script to create database, tables, and sample queries

## 📈 Key Queries and Analytics

### Basic Queries
- Filtering by genre, publication year, and country
- Date-based order filtering
- Stock and revenue calculations
- Finding extreme values (most/least expensive books)

### Advanced Analytics
- **Sales Analysis**: Total books sold by genre
- **Customer Insights**: Customers with multiple orders, highest spenders
- **Inventory Management**: Remaining stock calculations
- **Business Intelligence**: Revenue trends, popular authors, geographic analysis

## 🎯 Sample Query Results

### Top Selling Genres
```sql
SELECT b.genre, SUM(o.quantity) AS Total_Books_Sold
FROM orders AS o
JOIN books AS b ON o.book_id = b.book_id
GROUP BY b.genre;
```

### Customer Spending Analysis
```sql
SELECT c.name, SUM(o.total_amount) AS Amount_Spent
FROM customers c
JOIN orders o ON c.Customer_ID = o.Customer_ID
GROUP BY c.customer_id, c.name
ORDER BY Amount_Spent DESC;
```

## 🏆 Skills Demonstrated

- **Database Design**: Normalization, relationships, constraints
- **SQL Fundamentals**: SELECT, INSERT, JOIN, WHERE, GROUP BY, HAVING
- **Advanced SQL**: Window functions, subqueries, aggregations
- **Data Analysis**: Business metrics, KPI calculations
- **Data Import**: Excel to SQL Server integration

---
*This project is part of my AI Engineer portfolio, demonstrating data management and analytical skills essential for AI/ML projects.*
