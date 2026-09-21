# Sunrise Supermarket - PL/SQL Assignment One

**Student Name:** KAYITESI Annet 
**Student ID:** 29077 
**Group:** B  
**DBMS Used:** Oracle Database  

## 1. Business Scenario

Sunrise Supermarket sells products to customers. Customers place orders, and each order can contain one or more products.

Management wants to understand:
- Who the customers are.
- What products customers buy.
- How much customers spend.
- How customer orders change over time.
- How sales revenue is trending.

This project creates the required database tables, inserts sample data, and uses JOINs, a CTE, and window functions to answer business questions.

## 2. What I Did

I created four tables:

- `customers` - stores customer information.
- `products` - stores product, category, and price information.
- `orders` - stores customer orders and order dates.
- `order_items` - stores the products and quantities in each order.

The database contains:

- 5 customers
- 8 products
- 4 product categories
- 15 orders
- 30 order items
- Orders across August and September 2026

The SQL script is in `sunrise_supermarket.sql`.

## 3. How to Run the Project

1. Open Oracle SQL Developer or another Oracle SQL tool.
2. Connect to an Oracle database.
3. Open `sunrise_supermarket.sql`.
4. Run the table creation statements.
5. Run the INSERT statements.
6. Run `COMMIT`.
7. Run each JOIN, CTE, and window-function query.
8. Take screenshots of the query results and add them to the repository if required by the lecturer.

If the tables already exist, drop the old tables first or use a new Oracle schema.

## 4. JOIN Queries and Explanations

### JOIN 1 - Orders and Customers

The first query uses an **INNER JOIN** between `orders` and `customers`.

It shows:
- Order ID
- Customer name
- Customer city
- Order date

The INNER JOIN is useful because we only want orders that have a matching customer.

**Business interpretation:**  
Management can see which customer made each order, where the customer is located, and when the order was placed.

### JOIN 2 - Order Items and Products

The second query joins `order_items` with `products`.

It shows:
- Order item ID
- Order ID
- Product name
- Category
- Price
- Quantity

**Business interpretation:**  
Management can identify the products sold in each order and see the quantity purchased.

### JOIN 3 - Customers and Orders

The third query uses a **LEFT JOIN** from `customers` to `orders`.

A LEFT JOIN is important because it keeps every customer, even when a customer has no order.

**Business interpretation:**  
This helps management identify both active customers and customers who have not placed an order.

## 5. CTE Query

The CTE is called `customer_totals`.

First, it calculates each customer's total spending using:

`quantity × price`

Then the main query calculates the average customer spending and returns customers whose spending is above that average.

**Why use a CTE?**

The CTE makes the query easier to understand because customer totals are calculated first and then reused in the main query.

**Business interpretation:**  
Customers above the average spend are high-value customers. Sunrise Supermarket can use this information when planning customer loyalty programs and promotions.

## 6. Window Functions

### Window 1 - Customer Spending Rank

`RANK()` ranks customers from the highest total spending to the lowest.

**Business interpretation:**  
Management can identify customers who generate the most sales revenue.

### Window 2 - Customer Order Number

`ROW_NUMBER()` numbers each customer's orders according to the order date.

The numbering starts again for each customer because of:

`PARTITION BY customer_id`

**Business interpretation:**  
Management can see whether an order was a customer's first, second, third, or later purchase.

### Window 3 - Running Revenue

The query first calculates revenue for each order. It then uses:

`SUM(...) OVER (...)`

to calculate a running total from the earliest order to the latest order.

**Business interpretation:**  
The running total helps management understand how sales revenue accumulates over time.

### Window 4 - Days Between Orders

The query uses `LAG()` to find the previous order date for each customer.

The difference between the current date and previous date gives the number of days between purchases.

Customers with only one order are excluded because they do not have a previous order.

**Business interpretation:**  
Management can understand customer purchase frequency and identify customers who may need reminders or promotions.

## 7. Results

The SQL script produces result sets for all required JOIN, CTE, and window-function questions.

Before submission, screenshots can be added here showing:
- JOIN 1 results
- JOIN 2 results
- JOIN 3 results
- CTE results
- Customer spending ranking
- Customer order numbering
- Running revenue
- Days between customer orders

## 8. Business Interpretation

The analysis provides useful information for Sunrise Supermarket:

1. Customer information can be connected to sales orders.
2. Product sales can be viewed by product and category.
3. High-spending customers can be identified.
4. Customer orders can be tracked in sequence.
5. Revenue can be monitored over time.
6. The time between customer purchases can be measured.
7. These results can support promotions, customer retention, and sales planning.

## 9. Challenges and Resolutions

### Challenge 1: Connecting several tables

The sales information is stored in different tables.

**Resolution:**  
I used JOINs to connect customers, orders, order items, and products using their primary and foreign keys.

### Challenge 2: Finding customers above average spending

It is difficult to calculate customer totals and compare them with the average in one simple step.

**Resolution:**  
I used a CTE to calculate customer totals first and then compared each total with the average.

### Challenge 3: Comparing customer orders

A normal GROUP BY cannot easily show the previous order for each customer.

**Resolution:**  
I used the `LAG()` window function with `PARTITION BY customer_id`.

### Challenge 4: Creating a running revenue total

A normal SUM gives a total, but it does not show how revenue grows after each order.

**Resolution:**  
I used a windowed `SUM()` ordered by the order date.

## 10. Files

- `sunrise_supermarket.sql` - table creation, sample data, JOIN queries, CTE query, and window-function queries.
- `README.md` - project explanation and business interpretation.

## 11. Conclusion

This project demonstrates how SQL can be used to analyze supermarket sales data. JOINs connect related information, the CTE calculates customer spending, and window functions provide ranking, order sequencing, running revenue, and purchase-gap analysis. These techniques help Sunrise Supermarket make better data-based business decisions.
