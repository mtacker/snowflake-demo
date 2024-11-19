CREATE OR REPLACE PROCEDURE pnc_sales_db.bronze.LOAD_BRONZE_CUSTOMER_ORDERS()
RETURNS STRING
LANGUAGE JAVASCRIPT
AS
$$
try {
    var sql_command = `CREATE TABLE pnc_sales_db.bronze.bronze_customer_orders AS
                       SELECT c.C_CUSTKEY,
                              c.C_NAME AS customer_name,
                              o.O_ORDERKEY,
                              o.O_ORDERSTATUS,
                              C_PHONE
                       FROM customer c
                       JOIN orders o ON c.C_CUSTKEY = o.O_CUSTKEY`;

    var stmt = snowflake.createStatement({sqlText: sql_command});
    stmt.execute();
    
    return 'bronze_customer_orders table created successfully.';
} catch (err) {
    return err.message;
}
$$;