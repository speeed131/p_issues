# 2-2
## 課題名
データベースモデリング１の課題2-2
> 人気の寿司ネタを特定したいので、「はな」「わだつみ」などのセット商品の売り上げとは別に、寿司ネタが毎月何個売れているのか知る必要が生じました。どのようにテーブル設計をするべきでしょうか？

## PRの目的
課題2-2の論理設計した内容に対してレビューして頂きたいです。

## 結論
基本、課題2-1と同じ論理設計だが、`created_at`, `updated_at` を追加。
課題1で既に、productsテーブルにセットメニューかどうかの `is_set_menu` のBoolean値を入れているため、`created_at` と `is_set_menu` で絞り込む想定。




### ER図

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
        string price "価格"
        boolean is_set_menu "セットメニューかどうか"
        datetime created_at "作成日時"
        datetime updated_at "更新日時"
    }

    categories {
        int id PK "カテゴリーID"
        string name "カテゴリー名"
        datetime created_at "作成日時"
        datetime updated_at "更新日時"
    }
```