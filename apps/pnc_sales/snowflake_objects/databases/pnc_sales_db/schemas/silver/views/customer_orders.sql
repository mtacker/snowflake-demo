USE SCHEMA USE SCHEMA pnc_sales_db.silver;
create 
or replace view customer_orders as 
(
   select
      c_name,
      c_address,
      c_phone,
      O_ORDERSTATUS,
      O_TOTALPRICE,
      O_ORDERDATE 
   from
      pnc_sales_db.bronze.customer 
      left outer join
         pnc_sales_db.bronze.orders 
         on C_CUSTKEY = O_CUSTKEY 
)
limit 100;














-- CREATE OR REPLACE VIEW pnc_sales_db.silver.customer_orders AS
-- SELECT
--     c.customer_id,
--     c.name AS customer_name,
--     o.order_id,
--     o.product_id,
--     o.quantity
-- FROM
--     customer c
-- JOIN
--     orders o ON c.customer_id = o.customer_id;