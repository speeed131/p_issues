-- データベース作成
CREATE SCHEMA IF NOT EXISTS sushi;
USE sushi;


-- カテゴリーテーブル
CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'カテゴリーID',
    name VARCHAR(255) NOT NULL DEFAULT "未分類" COMMENT 'カテゴリー名',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日時'
);

-- 顧客テーブル
CREATE TABLE customers (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '顧客ID',
    name VARCHAR(255) NOT NULL COMMENT '名前',
    phone_number VARCHAR(20) NOT NULL COMMENT '電話番号',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日時'
);

-- 商品テーブル
CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '商品ID',
    category_id INT NOT NULL COMMENT 'カテゴリーID',
    product_name VARCHAR(255) NOT NULL COMMENT '商品名',
    price INT NOT NULL COMMENT '価格',
    is_set_menu BOOLEAN NOT NULL DEFAULT FALSE COMMENT 'セットメニューかどうか',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日時',
    FOREIGN KEY (category_id) REFERENCES categories(id)
);

-- 販売条件テーブル
CREATE TABLE product_sale_conditions (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '販売条件ID',
    product_id INT NOT NULL COMMENT '商品ID',
    is_weekday_only BOOLEAN NOT NULL DEFAULT FALSE COMMENT '平日限定かどうか',
    available_time_from TIME COMMENT '開始時間',
    available_time_until TIME COMMENT '終了時間',
    discount_percentage INT COMMENT '割引率',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日時',
    closed_at DATETIME COMMENT '販売条件終了日時',
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- 注文テーブル
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '注文ID',
    customer_id INT NOT NULL COMMENT '顧客ID',
    is_paid BOOLEAN NOT NULL DEFAULT FALSE COMMENT '支払い済みかどうか',
    additional_request TEXT COMMENT 'その他要望',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日時',
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

-- 注文オプションテーブル
CREATE TABLE order_options (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '注文オプションID',
    has_wasabi BOOLEAN NOT NULL DEFAULT TRUE COMMENT 'ワサビ有りかどうか',
    rice_size VARCHAR(50) NOT NULL DEFAULT 'medium' COMMENT 'シャリの大きさ',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日時',
    CHECK (rice_size IN ('small', 'medium', 'large'))
);

-- 注文詳細テーブル
CREATE TABLE order_details (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '注文詳細ID',
    order_id INT NOT NULL COMMENT '注文ID',
    product_id INT NOT NULL COMMENT '商品ID',
    order_option_id INT COMMENT '注文詳細オプションID',
    quantity INT NOT NULL COMMENT '数量',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日時',
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id),
    FOREIGN KEY (order_option_id) REFERENCES order_options(id)
);
