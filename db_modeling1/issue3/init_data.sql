INSERT INTO categories (name) VALUES
('未分類'),
('盛り込み'),
('にぎり'),
('海鮮ちらし'),
('白身'),
('赤身');

INSERT INTO customers (name, phone_number) VALUES
('山田太郎', '090-1234-5678'),
('佐藤花子', '080-8765-4321');

INSERT INTO products (category_id, product_name, price, is_set_menu) VALUES
(2, 'はな', 500, TRUE),
(3, 'みさき', 400, TRUE),
(1, '玉子', 200, FALSE),
(5, 'まぐろ赤身', 150, FALSE),
(4, 'えんがわ', 150, FALSE);

INSERT INTO product_sale_conditions (product_id, is_weekday_only, available_time_from, available_time_until, discount_percentage) VALUES
(1, TRUE, '0:00:00', '16:00:00', 0),
(4, FALSE, '18:00:00', '23:00:00', 15),
(5, FALSE, '18:00:00', '23:00:00', 15);

INSERT INTO orders (customer_id, is_paid, additional_request) VALUES
(1, TRUE, ''),
(2, FALSE, '急ぎでお願いします'),
(2, FALSE, '');

INSERT INTO order_options (has_wasabi, rice_size) VALUES
(TRUE, 'small'),
(FALSE, 'medium'),
(TRUE, 'large'),
(FALSE, 'large');

INSERT INTO order_details (order_id, product_id, order_option_id, quantity) VALUES
(1, 1, 1, 2),
(1, 2, 2, 1),
(2, 4, 3, 3),
(2, 5, 4, 2);