# 課題名

データベースモデリング3 課題２

# PRの目的

データベースモデリング3の課題2の仕様に基づき修正しました。

# 課題

もし上記のシステムに以下のような仕様が追加された場合、どのようなテーブル設計にしますか？

- ディレクトリ内のドキュメントの順番を変更できる
- 順番はユーザー間で共有される（例えばAさんがディレクトリ内で`hoge.txt`の前に`fuga.txt`が表示されるように並べ替えたら、Bさんがディレクトリを開いた時に`fuga.txt`が先に表示される）

# 結論

- ドキュメントの順番を記録する `document_orders` テーブルを追加

## ER図

```mermaid
erDiagram
    users {
        int id PK "id"
        string username "ユーザ名"
        string email "メールアドレス"
        datetime created_at "作成日時"
    }

    directories {
        int id PK "id"
        int created_by FK "作成者"
        datetime created_at "作成日時"
    }

    directory_changes {
        int id PK "id"
        int directory_id FK "ディレクトリID"
        int changed_by FK "変更者"
        string name "ディレクトリ名"
        datetime changed_at "変更日時"
    }

    directory_deletes {
      int id PK "id"
      int directory_id FK "ディレクトリID"
      int deleted_by FK "ユーザID"
      datetime deleted_at "削除日時"
    }

    documents {
        int id PK "id"
        int created_by FK "作成者"
        datetime created_at "作成日時"
    }

    document_changes {
        int id PK "id"
        int document_id FK "ドキュメントID"
        int parent_directory_id FK "親ディレクトリのID"
        int changed_by FK "変更者"
        string title "ドキュメントのタイトル"
        text content "ドキュメントの本文"
        datetime changed_at "変更日時"
    }

    document_deletes {
      int id PK "id"
      int document_id FK "ドキュメントID"
      int deleted_by FK "ユーザID"
      datetime deleted_at "削除日時"
    }


    directory_closures {
        int ancestor_directory_id "先祖ディレクトリ"
        int descendant_directory_id "子孫ディレクトリ"
        int depth "階層の深さ"
        datetime created_at "作成日時"
    }

    document_orders {
        int id PK "id"
        int document_id FK "ドキュメントID"
        int order_index "表示順序インデックス"
        datetime updated_at "更新日時"
    }


    documents ||--|{ document_changes : "作成、更新記録"
    documents ||--|| document_orders : "順序の管理"
    documents ||--o| document_deletes : "削除記録"
    users ||--o{ documents : "作成する"
    users ||--o{ directories : "作成する"
    users ||--o{ document_changes : "作成、更新の操作記録"
    users ||--o{ document_deletes: "削除の操作記録"
    users ||--o{ directory_changes : "作成、更新の操作記録"
    users ||--o| directory_deletes : "削除の操作記録"
    directories ||--o{ document_changes : "内包する"
    directories ||--o{ directory_closures : "階層構造の管理をする"
    directories ||--o{ directory_changes : "作成、更新記録"
    directories ||--o| directory_deletes : "削除記録"
    directories ||--|| document_orders : "順序の管理"

```

## 考えたこと

- ディレクトリ内のドキュメントの順番を記録する `document_orders` テーブルを追加しました
  - 順序に関して特に記録を持つ必要ないと思うため、更新はOKとしています（`updated_at` を持っています）
  - テーブルを分けた理由
    - `document_changes`に並び順を保持するパターンも考えたのですが、変更履歴と並び順という関心ごとの違いや、ユーザ操作が独立して違う（ドキュメント内容変更すること、並び順を変更すること）ことで更新と頻度も違うと思うためテーブルを分けました
      - 以前のMTGから参考にさせて頂いた記事の 5番目の方法と同じだと思います。
        - <https://zenn.dev/itte/articles/e97002637cd3a6#%E6%96%B9%E6%B3%955-%E3%83%AC%E3%82%B3%E3%83%BC%E3%83%89%E3%81%AE%E9%A0%86%E7%95%AA%E3%82%92%E6%8C%81%E3%81%A4%E3%83%86%E3%83%BC%E3%83%96%E3%83%AB%E3%82%92%E4%BD%9C%E3%82%8B>
- `order_index` にはそのまま並び順の数値が入る想定です
  - 以前MTGでお話頂いた通り、アプリケーション実装可能であれば、値を浮動小数点で計算する方法がDBの負荷は少なく良さそうです
