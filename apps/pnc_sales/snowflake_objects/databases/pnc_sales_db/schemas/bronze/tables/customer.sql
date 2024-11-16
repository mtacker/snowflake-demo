-- Joining customer and orders in a View at:
-- apps/pnc_sales/snowflake_objects/databases/pnc_sales_db/schemas/silver/views/customer_orders.sql
-- https://app.snowflake.com/iqiqvjq/qeb39663/#/data/databases/PNC_SALES_DB/schemas/SILVER/view/CUSTOMER_ORDERS/data-preview

-----------------------------------------------------------------------
-- Source Table:
-- SNOWFLAKE_SAMPLE_DATA.TPCH_SF10.CUSTOMER contains 1,500,000 records

USE SCHEMA pnc_sales_db.bronze;
DROP TABLE IF EXISTS customer;

CREATE OR ALTER TABLE customer (
	C_CUSTKEY NUMBER(38,0),
	C_NAME VARCHAR(25),
	C_ADDRESS VARCHAR(40),
	C_NATIONKEY NUMBER(38,0),
	C_PHONE VARCHAR(15)
);

INSERT INTO CUSTOMER (
    C_CUSTKEY, 
    C_NAME, 
    C_ADDRESS, 
    C_NATIONKEY, 
    C_PHONE)
  SELECT 
    C_CUSTKEY, 
    C_NAME, 
    C_ADDRESS, 
    C_NATIONKEY, 
    C_PHONE 
  FROM 
    SNOWFLAKE_SAMPLE_DATA.TPCH_SF10.CUSTOMER;

-- select count(*) from SNOWFLAKE_SAMPLE_DATA.TPCH_SF10.CUSTOMER;