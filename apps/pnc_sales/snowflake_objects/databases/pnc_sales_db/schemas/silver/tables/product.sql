USE SCHEMA pnc_sales_db.silver;
CREATE OR ALTER TABLE product (
    product_id INT PRIMARY KEY,
    name VARCHAR(100),
    price DECIMAL(10, 2)
);