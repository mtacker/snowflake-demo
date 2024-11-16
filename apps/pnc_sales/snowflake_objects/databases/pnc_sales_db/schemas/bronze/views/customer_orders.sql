USE SCHEMA pnc_sales_db.bronze;
CREATE OR REPLACE VIEW customer_orders AS
SELECT
	C_CUSTKEY,
	C_NAME,
	C_ADDRESS,
	C_NATIONKEY,
	C_PHONE
	-- C_ACCTBAL,
	-- C_MKTSEGMENT,
	-- C_COMMENT
FROM
    customer c
    JOIN orders o ON c.C_CUSTKEY = o.O_CUSTKEY;

-- select count(*) from pnc_sales_db.bronze.customer_orders;