-- ============================================================
--  PROJECT   : Online Retail Database 
--  AUTHOR    : Manav Gulati
--  PLATFORM  : SQL Server
--  CREATED   : 2026																				
--  DESCRIPTION:
--    End-to-end relational database for a fictional e-commerce
--    company. Covers schema design, realistic data population,
--    and 25+ analytical queries ranging from basic aggregations
--    to advanced window functions and CTEs.
-- ============================================================


-- ============================================================
-- SECTION 1 — DATABASE SETUP
-- ============================================================

CREATE DATABASE OnlineRetailDB;
GO

USE OnlineRetailDB;
GO


-- ============================================================
-- SECTION 2 — SCHEMA DESIGN
-- ============================================================

-- Stores product categories (Electronics, Clothing, etc.)
CREATE TABLE Categories
(
    CategoryID   INT PRIMARY KEY IDENTITY(1,1),
    CategoryName VARCHAR(100)  NOT NULL,
    [Description] VARCHAR(255)
);

-- Stores registered customers with full address info
CREATE TABLE Customers
(
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    FirstName  VARCHAR(50)  NOT NULL,
    LastName   VARCHAR(50)  NOT NULL,
    Email      VARCHAR(100) UNIQUE NOT NULL,
    Phone      VARCHAR(20),
    [Address]  VARCHAR(150),
    City       VARCHAR(50),
    [State]    VARCHAR(50),
    ZipCode    VARCHAR(20),
    Country    VARCHAR(30),
    CreatedAt  DATETIME DEFAULT GETDATE(),
    UpdatedAt  DATETIME NULL
);

-- Stores product catalog with pricing and stock info
-- Price and StockQuantity are constrained to non-negative values
CREATE TABLE Products
(
    ProductID     INT PRIMARY KEY IDENTITY(1,1),
    ProductName   VARCHAR(100) NOT NULL,
    CategoryID    INT,
    Price         DECIMAL(10,2) NOT NULL CHECK (Price >= 0),
    StockQuantity INT CHECK (StockQuantity >= 0),
    CreatedAt     DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

-- Stores order header info — one row per customer order
CREATE TABLE Orders
(
    OrderID     INT PRIMARY KEY IDENTITY(1,1),
    CustomerID  INT,
    OrderDate   DATETIME DEFAULT GETDATE(),
    TotalAmount DECIMAL(10,2),
    [Status]    VARCHAR(20) DEFAULT 'Completed', -- e.g. Completed, Pending, Cancelled
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Stores line items — each product within an order
-- Amount = price at time of purchase (important: products can change price later)
CREATE TABLE OrderItems
(
    OrderItemID INT PRIMARY KEY IDENTITY(1,1),
    OrderID     INT,
    ProductID   INT,
    Quantity    INT           NOT NULL CHECK (Quantity > 0),
    Amount      DECIMAL(10,2) NOT NULL CHECK (Amount >= 0),
    FOREIGN KEY (OrderID)   REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);


-- ============================================================
-- SECTION 3 — SAMPLE DATA
-- Realistic volume: 5 categories, 15 products, 12 customers,
-- 18 orders, 35+ order line items
-- ============================================================

-- Categories
INSERT INTO Categories (CategoryName, [Description]) VALUES
('Electronics',     'Devices, gadgets, and accessories'),
('Clothing',        'Apparel for men, women, and children'),
('Books',           'Printed books, e-books, and journals'),
('Home & Kitchen',  'Furniture, appliances, and cookware'),
('Sports & Fitness','Equipment and activewear for fitness enthusiasts');


-- Products
INSERT INTO Products (ProductName, CategoryID, Price, StockQuantity) VALUES
('Smartphone',        1,  699.99,  50),
('Laptop',            1,  999.99,  30),
('Wireless Earbuds',  1,  149.99,  80),
('Smart Watch',       1,  249.99,  45),
('USB-C Hub',         1,   49.99,   0),   -- Out of stock
('T-Shirt',           2,   19.99, 100),
('Jeans',             2,   49.99,  60),
('Winter Jacket',     2,   89.99,  35),
('Running Shoes',     2,  119.99,  40),
('Fiction Novel',     3,   14.99, 200),
('Science Journal',   3,   29.99, 150),
('Self-Help Book',    3,   19.99, 175),
('Coffee Maker',      4,   79.99,  25),
('Non-Stick Pan',     4,   39.99,  55),
('Yoga Mat',          5,   29.99,  90);


-- Customers
INSERT INTO Customers (FirstName, LastName, Email, Phone, [Address], City, [State], ZipCode, Country) VALUES
('Sameer',   'Khanna',    'sameer.khanna@example.com',   '123-456-7890', '123 Elm St',      'Springfield', 'IL',          '62701', 'USA'),
('Jane',     'Smith',     'jane.smith@example.com',      '234-567-8901', '456 Oak St',      'Madison',     'WI',          '53703', 'USA'),
('Harshad',  'Patel',     'harshad.patel@example.com',   '345-678-9012', '789 Dalal St',    'Mumbai',      'Maharashtra', '41520', 'India'),
('Emily',    'Johnson',   'emily.j@example.com',         '456-789-0123', '12 Maple Ave',    'Austin',      'TX',          '73301', 'USA'),
('Rohan',    'Mehta',     'rohan.mehta@example.com',     '567-890-1234', '34 MG Road',      'Bengaluru',   'Karnataka',   '56001', 'India'),
('Sophia',   'Williams',  'sophia.w@example.com',        '678-901-2345', '99 Pine Blvd',    'Seattle',     'WA',          '98101', 'USA'),
('Liam',     'Brown',     'liam.b@example.com',          '789-012-3456', '77 Birch Lane',   'Denver',      'CO',          '80201', 'USA'),
('Aisha',    'Khan',      'aisha.khan@example.com',      '890-123-4567', '5 Lotus Colony',  'Delhi',       'Delhi',       '11001', 'India'),
('Carlos',   'Garcia',    'carlos.g@example.com',        '901-234-5678', '200 Sunrise Rd',  'Miami',       'FL',          '33101', 'USA'),
('Priya',    'Sharma',    'priya.sharma@example.com',    '012-345-6789', '88 Park Street',  'Chennai',     'Tamil Nadu',  '60001', 'India'),
('Noah',     'Davis',     'noah.davis@example.com',      '111-222-3333', '300 Lakeview Dr', 'Chicago',     'IL',          '60601', 'USA'),
('Fatima',   'Ali',       'fatima.ali@example.com',      '222-333-4444', '14 Green Park',   'Lahore',      NULL,          '54000', 'Pakistan');


-- Orders
INSERT INTO Orders (CustomerID, OrderDate, TotalAmount, [Status]) VALUES
(1,  DATEADD(DAY, -60, GETDATE()), 719.98,  'Completed'),
(2,  DATEADD(DAY, -55, GETDATE()),  49.99,  'Completed'),
(3,  DATEADD(DAY, -50, GETDATE()),  44.98,  'Completed'),
(4,  DATEADD(DAY, -45, GETDATE()), 999.99,  'Completed'),
(5,  DATEADD(DAY, -40, GETDATE()), 269.98,  'Completed'),
(6,  DATEADD(DAY, -35, GETDATE()), 189.98,  'Completed'),
(7,  DATEADD(DAY, -30, GETDATE()), 149.99,  'Completed'),
(8,  DATEADD(DAY, -25, GETDATE()),  99.98,  'Completed'),
(9,  DATEADD(DAY, -20, GETDATE()), 249.99,  'Completed'),
(10, DATEADD(DAY, -15, GETDATE()),  79.99,  'Completed'),
(11, DATEADD(DAY, -10, GETDATE()), 119.99,  'Completed'),
(1,  DATEADD(DAY,  -8, GETDATE()), 249.99,  'Pending'),
(3,  DATEADD(DAY,  -6, GETDATE()),  89.99,  'Completed'),
(4,  DATEADD(DAY,  -5, GETDATE()),  69.98,  'Completed'),
(5,  DATEADD(DAY,  -4, GETDATE()), 119.99,  'Pending'),
(6,  DATEADD(DAY,  -3, GETDATE()),  29.99,  'Completed'),
(2,  DATEADD(DAY,  -2, GETDATE()),  59.98,  'Completed'),
(7,  DATEADD(DAY,  -1, GETDATE()), 109.98,  'Pending');


-- Order Items
INSERT INTO OrderItems (OrderID, ProductID, Quantity, Amount) VALUES
(1,  1, 1, 699.99),
(1,  6, 1,  19.99),
(2,  7, 1,  49.99),
(3, 10, 1,  14.99),
(3, 11, 1,  29.99),
(4,  2, 1, 999.99),
(5,  4, 1, 249.99),
(5,  6, 1,  19.99),
(6,  8, 1,  89.99),
(6,  6, 1,  19.99), 
(7,  3, 1, 149.99),
(8, 10, 1,  14.99),
(8, 12, 1,  19.99), 
(8,  6, 2,  19.99),
(9,  4, 1, 249.99),
(10, 13, 1, 79.99),
(11,  9, 1, 119.99),
(12,  4, 1, 249.99),
(13,  8, 1,  89.99),
(14, 12, 1,  19.99),
(14, 11, 1,  29.99), 
(15,  9, 1, 119.99),
(16, 15, 1,  29.99),
(17, 14, 1,  39.99),
(17, 15, 1,  19.99),
(18, 13, 1,  79.99),
(18, 14, 1,  29.99);


-- ============================================================
-- SECTION 4 — ANALYTICAL QUERIES
-- ============================================================

-- ── BASIC RETRIEVAL ─────────────────────────────────────────

-- Query 1: All orders for a specific customer (CustomerID = 1)
-- Useful for a customer order history page or support lookup
SELECT
    o.OrderID,
    o.OrderDate,
    o.TotalAmount,
    o.[Status],
    p.ProductName,
    oi.Quantity,
    oi.Amount
FROM Orders o
JOIN OrderItems oi ON o.OrderID   = oi.OrderID
JOIN Products  p  ON oi.ProductID = p.ProductID
WHERE o.CustomerID = 1
ORDER BY o.OrderDate DESC;


-- Query 2: All products that are currently out of stock
-- Inventory team would use this to trigger restocking
SELECT
    p.ProductID,
    p.ProductName,
    c.CategoryName,
    p.StockQuantity
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE p.StockQuantity = 0;


-- Query 3: Customers who have NEVER placed an order
-- Useful for targeted re-engagement marketing campaigns
SELECT
    c.CustomerID,
    c.FirstName,
    c.LastName,
    c.Email,
    c.Country
FROM Customers c
WHERE c.CustomerID NOT IN (SELECT DISTINCT CustomerID FROM Orders);


-- Query 4: Most recent order placed on the platform
SELECT TOP 1
    o.OrderID,
    o.OrderDate,
    o.[Status],
    o.TotalAmount,
    c.FirstName + ' ' + c.LastName AS CustomerName
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
ORDER BY o.OrderDate DESC;


-- Query 5: Customers who placed orders in the last 30 days
-- Helps identify active/engaged customers
SELECT DISTINCT
    c.CustomerID,
    c.FirstName,
    c.LastName,
    c.Email,
    c.Country
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderDate >= DATEADD(DAY, -30, GETDATE());


-- ── AGGREGATIONS ────────────────────────────────────────────

-- Query 6: Total sales revenue per product (descending)
-- Core metric for any retail analytics dashboard
SELECT
    p.ProductID,
    p.ProductName,
    SUM(oi.Quantity) AS UnitsSold,
    SUM(oi.Quantity * oi.Amount) AS TotalRevenue
FROM Products p
JOIN OrderItems oi ON p.ProductID = oi.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY TotalRevenue DESC;


-- Query 7: Total revenue generated per category
SELECT
    c.CategoryID,
    c.CategoryName,
    SUM(oi.Quantity * oi.Amount) AS TotalRevenue
FROM Categories c
JOIN Products   p  ON c.CategoryID  = p.CategoryID
JOIN OrderItems oi ON p.ProductID   = oi.ProductID
GROUP BY c.CategoryID, c.CategoryName
ORDER BY TotalRevenue DESC;


-- Query 8: Average order value across all orders
SELECT ROUND(AVG(TotalAmount), 2) AS AvgOrderValue FROM Orders;


-- Query 9: Total number of orders placed each month
-- Useful for spotting seasonal trends in order volume
SELECT
    YEAR(OrderDate)  AS OrderYear,
    MONTH(OrderDate) AS OrderMonth,
    COUNT(OrderID)   AS TotalOrders,
    SUM(TotalAmount) AS MonthlyRevenue
FROM Orders
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY OrderYear, OrderMonth;


-- Query 10: Customer count by country
-- Helps understand geographic distribution of the customer base
SELECT
    Country,
    COUNT(CustomerID) AS TotalCustomers
FROM Customers
GROUP BY Country
ORDER BY TotalCustomers DESC;


-- Query 11: Average product price per category
SELECT
    c.CategoryName,
    ROUND(AVG(p.Price), 2) AS AvgPrice,
    MIN(p.Price)           AS CheapestProduct,
    MAX(p.Price)           AS MostExpensiveProduct
FROM Categories c
JOIN Products p ON c.CategoryID = p.CategoryID
GROUP BY c.CategoryName;


-- Query 12: Top 5 customers by total spending
SELECT TOP 5
    c.CustomerID,
    c.FirstName + ' ' + c.LastName AS CustomerName,
    c.Country,
    COUNT(o.OrderID)   AS TotalOrders,
    SUM(o.TotalAmount) AS TotalSpent
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName, c.Country
ORDER BY TotalSpent DESC;


-- Query 13: Most popular product category by quantity sold
SELECT TOP 1
    c.CategoryName,
    SUM(oi.Quantity) AS TotalUnitsSold
FROM Categories c
JOIN Products   p  ON c.CategoryID = p.CategoryID
JOIN OrderItems oi ON p.ProductID  = oi.ProductID
GROUP BY c.CategoryName
ORDER BY TotalUnitsSold DESC;


-- Query 14: Orders with a total amount above $500
-- High-value orders often warrant priority fulfilment
SELECT
    o.OrderID,
    c.FirstName + ' ' + c.LastName AS CustomerName,
    o.OrderDate,
    o.TotalAmount,
    o.[Status]
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE o.TotalAmount > 500
ORDER BY o.TotalAmount DESC;


-- Query 15: Top 3 most frequently ordered products
SELECT TOP 3
    p.ProductName,
    COUNT(oi.OrderID) AS TimesOrdered,
    SUM(oi.Quantity) AS TotalUnitsSold
FROM OrderItems oi
JOIN Products   p ON oi.ProductID = p.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY TimesOrdered DESC;


-- ── SUBQUERIES ──────────────────────────────────────────────

-- Query 16: Highest-priced product in each category (correlated subquery)
SELECT
    c.CategoryName,
    p.ProductName,
    p.Price
FROM Categories c
JOIN Products p ON c.CategoryID = p.CategoryID
WHERE p.Price = (
    SELECT MAX(p2.Price)
    FROM Products p2
    WHERE p2.CategoryID = p.CategoryID
)
ORDER BY p.Price DESC;


-- Query 17: Products that have never been ordered
-- Useful for identifying dead inventory
SELECT
    p.ProductID,
    p.ProductName,
    c.CategoryName,
    p.StockQuantity
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE p.ProductID NOT IN (SELECT DISTINCT ProductID FROM OrderItems);


-- Query 18: Customers whose total spending exceeds the platform average
SELECT
    c.FirstName + ' ' + c.LastName AS CustomerName,
    SUM(o.TotalAmount) AS TotalSpent
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName
HAVING SUM(o.TotalAmount) > (SELECT AVG(TotalAmount) FROM Orders);


-- ── CTEs ────────────────────────────────────────────────────

-- Query 19: Customer lifetime value (CLV) using a CTE
-- CLV = total revenue a customer has generated since joining
WITH CustomerSpending AS (
    SELECT
        c.CustomerID,
        c.FirstName + ' ' + c.LastName AS CustomerName,
        c.Country,
        COUNT(o.OrderID) AS TotalOrders,
        SUM(o.TotalAmount) AS LifetimeValue
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
    GROUP BY c.CustomerID, c.FirstName, c.LastName, c.Country
)
SELECT
    CustomerName,
    Country,
    TotalOrders,
    LifetimeValue,
    CASE
        WHEN LifetimeValue >= 1000 THEN 'High Value'
        WHEN LifetimeValue >= 300  THEN 'Mid Value'
        ELSE                            'Low Value'
    END AS CustomerSegment
FROM CustomerSpending
ORDER BY LifetimeValue DESC;


-- Query 20: Monthly revenue trend with running total using CTE
WITH MonthlyRevenue AS (
    SELECT
        YEAR(OrderDate)  AS OrderYear,
        MONTH(OrderDate) AS OrderMonth,
        SUM(TotalAmount) AS Revenue
    FROM Orders
    GROUP BY YEAR(OrderDate), MONTH(OrderDate)
)
SELECT
    OrderYear,
    OrderMonth,
    Revenue,
    SUM(Revenue) OVER (ORDER BY OrderYear, OrderMonth) AS RunningTotal
FROM MonthlyRevenue
ORDER BY OrderYear, OrderMonth;


-- ── WINDOW FUNCTIONS ────────────────────────────────────────

-- Query 21: Rank customers by total spending within each country
-- Useful for country-level leaderboards or region-specific promotions
SELECT
    c.Country,
    c.FirstName + ' ' + c.LastName AS CustomerName,
    SUM(o.TotalAmount) AS TotalSpent,
    RANK() OVER (
        PARTITION BY c.Country
        ORDER BY SUM(o.TotalAmount) DESC
    ) AS RankWithinCountry
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.Country, c.CustomerID, c.FirstName, c.LastName
ORDER BY c.Country, RankWithinCountry;


-- Query 22: Each order's contribution as % of that customer's total spend
-- Great for understanding which single purchase drove the most value
SELECT
    c.FirstName + ' ' + c.LastName AS CustomerName,
    o.OrderID,
    o.OrderDate,
    o.TotalAmount AS OrderValue,
    SUM(o.TotalAmount) OVER (PARTITION BY c.CustomerID) AS CustomerTotal,
    CAST(ROUND(
        100.0 * o.TotalAmount /
        SUM(o.TotalAmount) OVER (PARTITION BY c.CustomerID),
        2
    ) AS DECIMAL(10,2)) AS PctOfCustomerTotal
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
ORDER BY CustomerName, o.OrderDate;


-- Query 23: Running revenue total per customer over time
SELECT
    c.FirstName + ' ' + c.LastName AS CustomerName,
    o.OrderID,
    o.OrderDate,
    o.TotalAmount,
    SUM(o.TotalAmount) OVER (
        PARTITION BY c.CustomerID
        ORDER BY o.OrderDate
    ) AS RunningSpend
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
ORDER BY CustomerName, o.OrderDate;


-- Query 24: Products ranked by revenue within each category
WITH ProductRevenue AS (
    SELECT
        c.CategoryName,
        p.ProductName,
        SUM(oi.Quantity * oi.Amount) AS Revenue
    FROM Categories c
    JOIN Products   p  ON c.CategoryID = p.CategoryID
    JOIN OrderItems oi ON p.ProductID  = oi.ProductID
    GROUP BY c.CategoryName, p.ProductID, p.ProductName
)
SELECT
    CategoryName,
    ProductName,
    Revenue,
    DENSE_RANK() OVER (PARTITION BY CategoryName ORDER BY Revenue DESC) AS RankInCategory
FROM ProductRevenue
ORDER BY CategoryName, RankInCategory;


-- Query 25: Identify repeat customers (placed more than 1 order)
WITH OrderCounts AS (
    SELECT
        CustomerID,
        COUNT(OrderID) AS OrderCount
    FROM Orders
    GROUP BY CustomerID
)
SELECT
    c.CustomerID,
    c.FirstName + ' ' + c.LastName AS CustomerName,
    c.Email,
    oc.OrderCount
FROM OrderCounts oc
JOIN Customers   c  ON oc.CustomerID = c.CustomerID
WHERE oc.OrderCount > 1
ORDER BY oc.OrderCount DESC;