# Kpi 1
# Weekday Vs Weekend (order_purchase_timestamp) Payment Statistics

select day_end,
concat (round(Total_payment/(select sum(payment_value) from order_payments)*100,0), '%')
as payment_percent_value
from
(select day_end, sum(payment_value) as Total_payment
from order_payments
join
(select distinct order_id, case
when weekday(order_purchase_timestamp) in (5,6) then "weekend" else "weekday"
end as Day_end
from orders)
on orders.order_id = order_payments.order_id
group by day_end) as Day_end;



# Kpi 2
# Total Number of Orders with review score 5 and payment type as credit card.

select count(order_payments.order_id) as Total_orders
from order_payments
join 
order_reviews on order_payments.order_id = order_reviews.order_id
where
order_reviews.review_score = 5
and order_payments.payment_type = 'credit_card';  



# Kpi 3
# Average number of days taken for order_delivered_customer_date for pet_shop

Select 
round(avg(datediff(order_delivered_customer_date, order_purchase_timestamp)),0) 
as Avg_delivery_days from orders
join 
order_items ON orders.order_id = order_items.order_id
Join 
Products ON  order_items.product_id = Products.product_id
Where product_category_name = "pet_shop" 
group by product_category_name;



# Kpi 4
# Average price and payment values from customers of sao paulo city

select 
round (avg(order_items.price),0) as Average_Price,
round (avg(order_payments.payment_value),0) 
as Average_Payment_Value from orders 
join 
order_items on orders.order_id = order_items.order_id
join
order_payments on orders.order_id = order_payments.order_id
join 
customers on orders.customer_id = customers.customer_id
where
customers.customer_city = 'sao paulo';



# Kpi 5
# Relationship between shipping days Vs review scores.

select review_score,
round(avg(datediff(order_delivered_customer_date, order_purchase_timestamp)),0)
as "Average_shipping_days"
from order_reviews
Join 
orders ON order_reviews.order_id =  orders.order_id 
group by review_score
order by review_score;



# kpi 6
# Total number of orders with order status

select 
order_status, count(order_id) as Total_orders
from orders_s
where order_status = ('Delivered' and 'canceled')
group by order_status;



# Kpi 7
# Best selling products by sales percentage

select 
product_category_name as product_category,
round((sum(order_items.price + order_items.freight_value) / (select sum(price + freight_value) from order_items)) * 100, 2) 
    as sales_percentage
from order_items 
join 
products on order_items. product_id = products.product_id
group by product_category_name
order by sales_percentage desc
limit 10;
