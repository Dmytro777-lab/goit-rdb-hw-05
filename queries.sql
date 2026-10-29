USE mydb;

-- 1. Вкладений запит в SELECT.
SELECT od.*,
       (SELECT o.customer_id
        FROM orders AS o
        WHERE o.id = od.order_id) AS customer_id
FROM order_details AS od
ORDER BY od.id;

-- 2. Вкладений запит в WHERE.
SELECT od.*
FROM order_details AS od
WHERE od.order_id IN (
    SELECT o.id
    FROM orders AS o
    WHERE o.shipper_id = 3
)
ORDER BY od.id;

-- 3. Вкладений запит в FROM.
SELECT filtered.order_id,
       AVG(filtered.quantity) AS average_quantity
FROM (
    SELECT order_id, quantity
    FROM order_details
    WHERE quantity > 10
) AS filtered
GROUP BY filtered.order_id
ORDER BY filtered.order_id;

-- 4. Повторення завдання 3 через WITH (CTE temp).
WITH temp AS (
    SELECT order_id, quantity
    FROM order_details
    WHERE quantity > 10
)
SELECT temp.order_id,
       AVG(temp.quantity) AS average_quantity
FROM temp
GROUP BY temp.order_id
ORDER BY temp.order_id;

-- 5. Функція ділення: два параметри FLOAT і результат FLOAT.
DROP FUNCTION IF EXISTS hw05_divide_float;

CREATE FUNCTION hw05_divide_float(p_numerator FLOAT, p_denominator FLOAT)
RETURNS FLOAT
DETERMINISTIC
NO SQL
RETURN p_numerator / NULLIF(p_denominator, 0);

SELECT od.*,
       hw05_divide_float(od.quantity, 2.0) AS divided_quantity
FROM order_details AS od
ORDER BY od.id;
