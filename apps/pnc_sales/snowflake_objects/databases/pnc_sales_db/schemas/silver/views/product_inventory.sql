USE SCHEMA pnc_sales_db.silver;
CREATE OR REPLACE VIEW product_inventory AS
SELECT
    p.product_id,
    p.name AS product_name,
    SUM(o.quantity) AS total_quantity
FROM
    product p
LEFT JOIN
    orders o ON p.product_id = o.product_id
GROUP BY
    p.product_id,
    p.name;