# 🛒 OnlineRetailDB — SQL Portfolio Project

A production-style relational database built for a fictional e-commerce company, designed to simulate real-world retail analytics. This project covers full database design, realistic data population, and 25+ analytical SQL queries spanning aggregations, subqueries, CTEs, and window functions.

---

## 🗂️ Project Structure

```
OnlineRetailDB/
│
├── OnlineRetailDB.sql       # Full script: schema + data + queries
└── README.md
```

---

## 🧱 Database Schema

| Table        | Description                                              |
|--------------|----------------------------------------------------------|
| `Customers`  | Registered users with location and contact details       |
| `Categories` | Product classification (Electronics, Clothing, etc.)     |
| `Products`   | Catalog with pricing, stock levels, and category linkage |
| `Orders`     | Order header — one row per transaction per customer      |
| `OrderItems` | Line items — each product purchased within an order      |

### Relationships
- `Customers` → `Orders` (1 customer : many orders)
- `Orders` → `OrderItems` (1 order : many line items)
- `Products` → `OrderItems` (1 product : many line items)
- `Categories` → `Products` (1 category : many products)

---

## 📊 Queries Covered

### 🔍 Basic Retrieval
- Customer order history lookup
- Out-of-stock product identification
- Customers who never placed an order
- Orders placed in the last 30 days
- Most recent order on the platform

### 📈 Aggregations
- Total revenue per product and per category
- Average order value
- Monthly order volume and revenue trends
- Top 5 customers by total spending
- Customer distribution by country
- Average, min, and max product price per category

### 🔗 Subqueries
- Highest-priced product in each category
- Products that have never been ordered
- Customers spending above the platform average

### 🧮 CTEs (Common Table Expressions)
- Customer Lifetime Value (CLV) with segmentation (High / Mid / Low)
- Monthly revenue with a running cumulative total

### 🪟 Window Functions
- Customer ranking by spend within each country (`RANK`, `PARTITION BY`)
- Each order's % contribution to a customer's total spend
- Running spend total per customer over time (`SUM OVER`)
- Product revenue ranking within each category (`DENSE_RANK`)
- Repeat customer identification

---

## 🛠️ Tech Stack

- **Database:** Microsoft SQL Server
- **Language:** T-SQL
- **Concepts:** DDL, DML, Joins, Aggregations, Subqueries, CTEs, Window Functions

---



## 👤 Author

**Manav Gulati**  
Aspiring Data Analyst | SQL • Excel • PowerBI
📧 gulatimanav00@gmail.com
🔗 https://www.linkedin.com/in/manavgulati12/ | https://github.com/ManavGulati123

