select*from customers;
select*from orders;
select*from products;
select*from orderdetails;

alter table customers
change column ï»¿customer_id customer_id int;

alter table orders
change column ï»¿order_id order_id int;

alter table products
change column ï»¿product_id product_id int; 

alter table orderdetails
change column ï»¿order_id order_id int; 


/*  
E-Commerce Dataset Overview

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

Generate actionable business insights using SQL queries across multiple related tables.*/




/*Problem statement 
Identify the top 3 cities with the highest number of customers to determine key markets for targeted marketing and logistic optimization.*/

select location,  count(*) as number_of_customers from Customers
group by location 
order by number_of_customers desc 
limit 3;  

/*Determine the distribution of customers by the number of orders placed. 
This insight will help in segmenting customers into one-time buyers, occasional shoppers, 
and regular customers for tailored marketing strategies.*/

select*from orders; 
with Customers_orders as ( select customer_id, count(order_id) as number_of_orders 
from orders
group by customer_id ) 

select number_of_orders, count(*) as customercount 
from Customers_orders
group by number_of_orders
order by number_of_orders asc; 


# the trend of the number of customers v/s number of orders 
# number of order increases the customercount decreases 
# the company has most of the occasional buyers

/*Problem statement
Identify products where the average purchase quantity per order is 2 but with a high total revenue, suggesting premium product trends.*/

select*from orderdetails;
select product_id, avg(quantity) as AvgQuantity, sum(quantity*price_per_unit) as TotalRevenue
from orderdetails
group by product_id
having avg(quantity)=2
order by TotalRevenue desc; 

/* Used orderdetails table 
showing product_id 1 and 8 both lies in premium products with product_id 1 is more premium
as it has highest total revenue */

/*Problem statement
For each product category, calculate the unique number of customers purchasing from it. 
This will help understand which categories have wider appeal across the customer base.*/
#using customers, orders and products table
select*from products;
select*from orders; 
select*from orderdetails; 

select p.category, count(distinct customer_id) as unique_customers 
from products p 
join orderdetails od on  p.product_id=od.product_id
join orders o on od.order_id=o.order_id
group by p.category
order by unique_customers desc; 

#Electroncs has the highest number of unique customers 
# As it is in high demand so it needs more focus

/*Problem statement
Analyze the month-on-month percentage change in total sales to identify growth trends.

Using the “Orders” table.
Returning the result table which will get the month (YYYY-MM),
 Total Sales and Percent Change of the total amount (Present month value- Previous month value/ Previous month value)*100.
The resulting change in percentage should be rounded to 2 decimal places. */

with Monthly_Sales as (select DATE_FORMAT(order_date,'%m-%Y') as Month, 
sum(total_amount) as TotalSales from orders 
group by DATE_FORMAT(order_date,'%m-%Y') 
)
select Month, TotalSales, round((TotalSales-lag(TotalSales)over(order by Month))/lag(TotalSales)over(order by Month)*100,2)
as PercentChange from Monthly_Sales order by Month asc; 

#In the Output we can see that february has the largest descline in Sales by -74.53

/*Problem statement
Examine how the average order value changes month-on-month. 
Insights can guide pricing and promotional strategies to enhance order value.

Using the “Orders” Table.
Returning  table which will get the month (YYYY-MM), 
Average order value and Change in the average order value (Present month value- Previous month value)*/

with AvgMonthlySales as ( select  date_format(order_date,'%m-%Y') as Month,round(avg(total_amount),2) as AvgOrderValue
from orders 
group by date_format(order_date,'%m-%Y')
)
select Month, AvgOrderValue, round((AvgOrderValue- lag(AvgOrderValue)over(order by month)),2) as ChangeInValue 
from AvgMonthlySales ;

#December is the month which has the highest change in Avg Order Value

/*Problem statement
Based on sales data, 
identify products with the fastest turnover rates, suggesting high demand and the need for frequent restocking. 
table limited to top 5 product according to the SalesFrequency column in descending order. */

select product_id, count(quantity) as SalesFrequency 
from orderdetails
group by product_id
order by SalesFrequency desc
limit 5; 

#Product_id 7 has highest turnover rate needs to be restored more frequently

/*Problem statement
List products purchased by less than 40% of the customer base, 
indicating potential mismatches between inventory and customer interest.
Using the “Products”, “Orders”, “OrderDetails” and “Customers” table.
Returning the result table which will get the product names along with the count of unique customers 
who belong to the lower 40% of the customer pool.*/


select*from products; 
select*from orders; 
select*from orderdetails;
select*from customers; 

select p.product_id , p.name, count(distinct c.customer_id) as unique_customers 
from products p 
join orderdetails od on p.product_id=od.product_id
join orders o on od.order_id=o.order_id 
join customers c on o.customer_id=c.customer_id
group by p.product_id,p.name 
having count(distinct c.customer_id)<0.4*(select count(distinct c.customer_id) from customers c); 

#The products purchased by less than 40% might have poor visibilty on platoform
#Can run targeted marketing campaign to raise more awarness and intrest. 


/*Evaluate the month-on-month growth rate in the customer base to understand the effectiveness of marketing campaigns and market expansion efforts.

Use the “Orders” table.
 the result table will get the count of the number of customers who made the first purchase on monthly basis.
The resulting table should be ascendingly ordered according to the month.*/ 

select*from orders; 

with first_purchase as (select customer_id, min(order_date) as FirstPurchaseDate
from orders
group by customer_id), 

new_customers as (select  DATE_FORMAT(FirstPurchaseDate,'%m-%Y') as FirstPurchaseMonth, 
count(customer_id) as TotalNewCustomers 
from first_purchase
group by  DATE_FORMAT(FirstPurchaseDate,'%m-%Y') )

select FirstPurchaseMonth, TotalNewCUstomers from new_customers 
order by FirstPurchaseMonth; 

# From the resulting table it can be seen that growth trend is going downward

/*Problem statement
Identify the months with the highest sales volume, aiding in planning for stock levels, 
marketing efforts, and staffing in anticipation of peak demand periods.
Using the “Orders” table.
Returning  the result table which will help you get the month (YYYY-MM) and the Total sales made by the company limiting to top 3 months.
The resulting table is in descending order suggesting the highest sales month.*/

select DATE_FORMAT(order_date,'%m-%Y') as Month, sum(total_amount) as TotalSales
from orders 
group by DATE_FORMAT(order_date,'%m-%Y')
order by TotalSales desc
limit 3; 

#September, December and July months will require mmore staff and restocking of inventory



 

