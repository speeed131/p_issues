## エンティティの抽出
- 注文票
    - 顧客
        - 名前
        - 電話番号
    - 注文（複数）
        - 商品
            - 商品名
            - 価格
            - カテゴリー
                - カテゴリー名 （セットメニューの名前、もしくは「お好みすし」）
            - わさび抜きかどうか
        - 数量
    - 支払い済みかどうか
    - その他要望



## ER図
論理モデルの設計
- 顧客 1-多 注文票
- 注文票 1 - 多 注文詳細
- 注文詳細 1 - 1 商品
- 商品 1 - 1 カテゴリー




```mermaid

---
title: お持ち帰りメニュー ご注文表
---


erDiagram
    customers ||--o{ orders : ""
    orders ||--|{ order_details : ""
    order_details ||--|| product : ""
    product ||--||  category : ""

    customers {
        int id PK "顧客ID"
        string name "名前"
        string phone_number "電話番号"
    }

    orders {
        int id PK "注文ID"
        int customer_id FK "顧客ID"
        int order_detail_id FK "注文詳細ID"
        int is_paid "支払い済みかどうか"
        string additional_request "その他要望"
    }

    order_details {
        int id PK "注文詳細ID"
        int product_id FK "商品ID"
        int quantity "数量"
    }

    product {
        int id PK "商品ID"
        string product_name "商品名"
        string price "価格"
        string category_id "カテゴリーID"
        int has_wasabi "ワサビ有りかどうか"
    }

    category {
        int id PK "カテゴリー"
        string name "カテゴリー名"
    }
```

