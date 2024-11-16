CREATE OR ALTER TABLE pnc_sales_db.silver.orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    quantity INT
);