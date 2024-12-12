create or replace view pnc_sales_db.silver.customer_orders as 
(
   select
      c_name,
      c_address,
      c_phone,
      O_ORDERSTATUS,
      O_TOTALPRICE,
      O_ORDERDATE 
   from
      pnc_sales_db.silver.customer 
      left outer join
         pnc_sales_db.silver.orders 
         on C_CUSTKEY = O_CUSTKEY 
);
