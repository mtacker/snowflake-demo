USE SCHEMA pnc_sales_db.gold;
CREATE OR ALTER TABLE shipping (
    shipping_id INT PRIMARY KEY,
    order_id INT,
    status VARCHAR(50)
);