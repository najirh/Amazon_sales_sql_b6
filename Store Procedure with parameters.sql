-- Store Procedure with paramter


DROP TABLE IF EXISTS products;
CREATE TABLE products
                    (product_id INT, 
                    product_name VARCHAR(25),
                    price INT,
                    qty_remaining INT, 
                    qty_sold INT);

INSERT INTO products
VALUES
(101, 'iPhone 14', 1299, 10, 95),
(102, 'iPhone 15', 1399, 5, 95),
(103, 'AirPods', 499, 4, 95),
(104, 'MacBook Air', 1399, 2, 95),
(105, 'Charger', 299, 20, 95),    
(106, 'Watch S9', 499, 3, 95),    
(107, 'iMac', 1499, 10, 95);

DROP TABLE IF EXISTS sales;
CREATE TABLE sales(
                        id SERIAL, 
                        sale_date DATE, 
                        product_id INT, 
                        qty INT, 
                        price INT
                   );


INSERT INTO sales(sale_date, product_id, qty, price)
VALUES
('2024-04-29', 101, 3, 2999),
('2024-04-29', 102, 5, 8999),
('2024-04-29', 103, 4, 1999),
('2024-04-29', 102, 4, 5999);


SELECT * FROM products;
SELECT * FROM sales;


/*
- Create a stored procedure to purchase a specific product-- 
-- The procedure should:-- 
-- 1. Accept input from the user for the product_id and quantity.
-- 2. Check if the product_id has sufficient quantity in stock.
-- - If sufficient stock is available, add a sales record and update the product table accordingly.
-- - If stock is insufficient, print a message indicating that there is insufficient stock.
*/

    

    -- SELECT
    --     COUNT(*)
    --     -- INTO v_qty_cnt
    -- FROM products
    -- WHERE product_id = 101
    -- AND
    -- qty_remaining >= 9



CREATE OR REPLACE PROCEDURE buy_product(p_product_id INT, p_qty INT) -- with parameters
LANGUAGE plpgsql
AS
$$
    
DECLARE -- declare all variable
    v_product_id INT;
    v_price INT;
    v_qty_cnt INT;
    v_qty_left INT;
    
BEGIN
    SELECT
        COUNT(*)
        INTO v_qty_cnt -- 1 if we have stock or 0 if we do not have stock
    FROM products
    WHERE product_id = p_product_id
    AND
    qty_remaining >= p_qty;

    -- getting qty left stock from products   
    SELECT
        SUM(qty_remaining)
        INTO v_qty_left
    FROM products
    WHERE product_id = p_product_id;
    
    IF v_qty_cnt > 0 THEN
    
        --- write your code
        -- getting information required from products table
        SELECT 
            product_id, price
            INTO v_product_id, v_price
        FROM products
        WHERE product_id = p_product_id;
    
    
        -- adding sales records
        INSERT INTO sales(sale_date, product_id, qty, price)
        VALUES(CURRENT_DATE, v_product_id, p_qty, v_price*p_qty);     
    
    
        -- updating stock after sale
        UPDATE products
        SET qty_remaining =  (qty_remaining - p_qty),
            qty_sold = (qty_sold + p_qty)
        WHERE product_id = v_product_id;
    
        RAISE NOTICE 'Thank you purchasing % and qty %', v_product_id,  p_qty;

    ELSE RAISE NOTICE 'Sorry Insufficient stock current we have qty only %!', v_qty_left;  
    END IF;


END;
$$

-- Ma 104 
102 I15 5 


    
SELECT * FROM products;
SELECT * FROM sales;


CAll buy_product(102, 4);


-- End of Procedure!
