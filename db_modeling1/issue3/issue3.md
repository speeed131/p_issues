# 3
## 課題名
データベースモデリング１の課題3
以下を作成
- 設計したテーブルのDDL
- サンプルデータを投入するDML
- ユースケースを想定したクエリ

## PRの目的
課題3のレビューを頂ければと思います。

## 結論
設計は課題2-3の時と変わっておりません。
- 設計したテーブルのDDL
    - ./init.sql
- サンプルデータを投入するDML
    - ./init_data.sql
- ユースケースを想定したクエリ
    - ./sample.sql


### 参考 ER図
```mermaid

---
title: お持ち帰りメニュー ご注文表
---


erDiagram
    customers ||--o{ orders : ""
    orders ||--|{ order_details : ""
    order_details ||--|| products : ""
    order_details  ||--||  order_options: ""
    products ||--||  categories : ""
    products ||--o| product_sale_conditions : ""

    customers {
        int id PK "顧客ID"
        string name "名前"
        string phone_number "電話番号"
        datetime created_at "作成日時"
        datetime updated_at "更新日時"

    }

    orders {
        int id PK "注文ID"
        int customer_id FK "顧客ID"
        boolean is_paid "支払い済みかどうか"
        string additional_request "その他要望"
        datetime created_at "作成日時"
        datetime updated_at "更新日時"
    }

    order_details {
        int id PK "注文詳細ID"
        int order_id FK "注文ID"
        int product_id FK "商品ID"
        int order_option_id FK "注文詳細オプションID"
        int quantity "数量"
        datetime created_at "作成日時"
        datetime updated_at "更新日時"
    }

    order_options {
        int id PK "注文オプションID"
        boolean has_wasabi "ワサビ有りかどうか"
        string rice_size "シャリの大きさ"
        datetime created_at "作成日時"
        datetime updated_at "更新日時"
    }

    products {
        int id PK "商品ID"
        int category_id FK "カテゴリーID"
        string product_name "商品名"
        int price "価格"
        boolean is_set_menu "セットメニューかどうか"
        datetime created_at "作成日時"
        datetime updated_at "更新日時"
    }

    product_sale_conditions {
        int id PK "販売条件ID"
        int product_id FK "商品ID"
        boolean is_weekday_only "平日限定かどうか"
        time available_time_from "開始時間"
        time available_time_until "終了時間"
        int discount_percentage "割引率"
        datetime created_at "作成日時"
        datetime updated_at "更新日時"
        datetime closed_at  "販売条件終了日時"
    }

    categories {
        int id PK "カテゴリーID"
        string name "カテゴリー名"
        datetime created_at "作成日時"
        datetime updated_at "更新日時"
    }
```


## 考えたこと
- docker コンテナ立ち上げ時にテーブル作成、初期データ投入をできるようにしました
- サンプルクエリは実際に課題2-3のユースケースでの想定される以下のクエリを書きました
    - 各月の寿司ネタごとの販売数を確認する
    - 全メニューを表示する
    - 顧客の新しい注文を登録する
