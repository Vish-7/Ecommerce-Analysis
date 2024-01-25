create database Ecommerce;
use ecommerce;

-- Calculation of Total Customers
select count(customer_unique_id) as 'Total Customers'
from olist_customers_dataset;

-- Calculation of Total Sellers
select count(seller_id) as 'Total Seller'
from olist_sellers_dataset;

-- Calculation of Total Products
select count(product_id) as 'Total Product'
from olist_products_dataset;

-- Calculation of Total order delivered
select count(order_status) as 'Order Delivered'
from olist_orders_dataset
where order_status = 'delivered';

-- Calculation of Weekday Vs Weekend (order_purchase_timestamp) Payment Statistics   #KPI-1

SELECT
  CASE
  when DAYOFWEEK(o.order_purchase_timestamp) in (1, 7) THEN 'Weekend' ELSE 'Weekday'
  END As Weekday_Weekend,
  COUNT(*) AS total_orders,
  concat(round(SUM(p.payment_value)/1000000,0)," M") AS Total_Payment
FROM olist_orders_dataset o join olist_order_payments_dataset p on o.order_id = p.order_id
GROUP BY Weekday_Weekend
ORDER BY Weekday_Weekend;

-- Number of Orders with review score 5 and payment type as credit card.        #KPI-2

SELECT
count(o.order_id) as Total_Order, r.review_score, p.payment_type
from olist_orders_dataset o 
join olist_order_payments_dataset p ON o.order_id = p.order_id
join olist_order_reviews_dataset r ON o.order_id = r.order_id 
where r.review_score = 5 and p.payment_type = 'credit_card';

-- Average number of days taken for order_delivered_customer_date for pet_shop		#KPI-3

select
round(avg(datediff(o.order_delivered_customer_date, o.order_purchase_timestamp)),0) as AVG_Days_Taken, p.product_category_name
from olist_orders_dataset o
join olist_order_items_dataset i ON i.order_id = o.order_id
join olist_products_dataset p ON p.product_id = i.product_id
where p.product_category_name = 'pet_shop';

-- Average price and payment values from customers of sao paulo city			#KPI-4

select
	c.customer_city,
	round(avg(i.price),2) AS Avg_price,
	round(avg(p.payment_value),2) AS Avg_payment_value
from olist_orders_dataset o
join olist_order_items_dataset i ON i.order_id = o.order_id
join olist_order_payments_dataset p ON p.order_id = o.order_id
join olist_customers_dataset c ON c.customer_id = o.customer_id
where c.customer_city = 'sao paulo';

-- Relationship between shipping days (order_delivered_customer_date - order_purchase_timestamp) Vs review scores.			#KPI-5
select 
rew.review_score,
round(avg(datediff(ord.order_delivered_customer_date , order_purchase_timestamp)), 0) as "Avg shipping days"
from olist_orders_dataset as ord
join olist_order_reviews_dataset as rew on rew.order_id = ord.order_id 
group by rew.review_score
order by rew.review_score;






-- kpi 5 with differnt result format
SELECT
c.customer_city,
p.product_category_name,
datediff(o.order_delivered_customer_date, o.order_purchase_timestamp) AS 'Shipping_Days', 
r.review_score
from olist_orders_dataset o
join olist_order_reviews_dataset r ON r.order_id = o.order_id
join olist_customers_dataset c ON c.customer_id = o.customer_id
join olist_order_items_dataset i ON i.order_id = o.order_id
join olist_products_dataset p ON p.product_id = i.product_id
order by c.customer_city, Shipping_Days desc;


