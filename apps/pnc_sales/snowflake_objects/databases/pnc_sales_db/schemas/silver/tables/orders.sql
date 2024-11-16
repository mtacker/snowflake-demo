USE SCHEMA pnc_sales_db.silver;
CREATE OR ALTER TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    quantity INT
);