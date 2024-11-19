CREATE OR ALTER TABLE pnc_sales_db.silver.shipping (
    shipping_id INT PRIMARY KEY,
    order_id INT,
    status VARCHAR(50)
);