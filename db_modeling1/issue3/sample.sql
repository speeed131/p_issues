-- 各月の寿司ネタごとの販売数を確認
SELECT
    DATE_FORMAT(o.created_at, '%Y-%m') AS order_month,
    p.product_name,
    SUM(od.quantity) AS total_quantity
FROM
    orders o
JOIN
    order_details od ON o.id = od.order_id
JOIN
    products p ON od.product_id = p.id
GROUP BY
    order_month, p.product_name
ORDER BY
    order_month, total_quantity DESC;

-- 全メニューを表示
SELECT
    p.product_name,
    c.name AS category_name,
    p.price,
    p.is_set_menu,
    psc.available_time_from AS sale_start_time,
    psc.available_time_until AS sale_end_time,
    psc.discount_percentage AS discount
FROM
    products p
LEFT JOIN
    categories c ON p.category_id = c.id
LEFT JOIN
    product_sale_conditions psc ON p.id = psc.product_id
ORDER BY
    c.name, p.product_name;

-- 顧客の新しい注文を登録
INSERT INTO orders (customer_id, is_paid, additional_request)
VALUES (1, FALSE, '醤油を多めに');


-- 注文オプションを登録
INSERT INTO order_options (has_wasabi, rice_size)
VALUES
(TRUE, 'small'),
(FALSE, 'medium');


-- 注文詳細を登録
INSERT INTO order_details (order_id, product_id, order_option_id, quantity)
VALUES
(4, 3, 5, 3),
(4, 4, 6, 1);