USE SCHEMA pnc_sales_db.silver;
CREATE OR ALTER TABLE customer (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);