#E-Commerce Dataset Overview

This dataset represents transactional data for an e-commerce platform and is designed to support analysis across customer behavior,
product performance, and sales trends. It consists of four interconnected tables that capture customer information,
product catalog details, order transactions, and item-level purchase data.

The dataset enables end-to-end sales analysis, including revenue tracking, customer segmentation, product demand analysis,
and time-based trend evaluation. Relationships between tables are established using primary and foreign keys,
allowing multi-table joins for comprehensive business insights.

BUSINESS PROBLEM
The e-commerce business aims to better understand its sales performance, customer purchasing behavior,
and product demand to support data-driven decision-making. Key challenges include identifying revenue drivers, monitoring sales trends over time,
understanding customer contribution to sales, and optimizing product and inventory strategies.

Project Objectives

The objectives of this SQL project are to:

Analyze customer purchasing patterns to identify high-value and repeat customers.

Evaluate product and category performance to determine top-selling and revenue-generating categories.

Track sales and revenue trends over time to identify growth patterns and seasonality.

Support inventory and marketing decisions by identifying demand trends and customer segments.

Generate actionable business insights using SQL queries across multiple related tables.


## Dataset Schema

The dataset consists of the following tables:

- Customers
  - customer_id (Primary Key)
  - name
  - location

- Products
  - product_id (Primary Key)
  - name
  - category
  - price

- Orders
  - order_id (Primary Key)
  - order_date
  - customer_id (Foreign Key)
  - total_amount

- OrderDetails
  - order_id (Foreign Key)
  - product_id (Foreign Key)
  - quantity
  - price_per_unit



## Key KPIs

- Monthly Total Revenue
- Month-on-Month Revenue Growth %
- Average Order Value (AOV)
- Monthly Change in AOV
- Customer Purchase Frequency
- Monthly New Customers
- Top Products by Sales Frequency
- Revenue by Product Category
- Low-Adoption Products (<40% customer reach)

## Key Insights

- The customer base is dominated by occasional buyers, indicating an opportunity to improve repeat purchase rates.
- Revenue shows significant month-on-month fluctuations, with February experiencing the steepest decline.
- Average Order Value peaks in December, suggesting effective seasonal promotions.
- Electronics category has the widest customer reach and highest demand.
- A small set of products shows high turnover rates, requiring frequent inventory restocking.
- Several products are purchased by less than 40% of customers, indicating low visibility or mismatched inventory.
- New customer acquisition shows a downward trend over time, signaling the need for stronger marketing efforts.
