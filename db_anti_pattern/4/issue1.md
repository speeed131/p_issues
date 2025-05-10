
# 課題名

データベース設計のアンチパターン4
課題1

# 課題

```
ツリー構造をリレーショナルデータベースで表現する際（例えばslackのようなスレッドを表現する時など）に、以下のように親の ID だけを持つツリー構造を見かけることがあります。

```sql
TABLE Message {
  id: varchar
  parent_message_id: varchar
  text: varchar
  FOREIGN KEY (parent_message_id) REFERENCES Message(id)
}
```

上記の設計では`parent_message_id`にMessage自身のidを持つ、自己参照を用いています。

この設計だとどのような問題が生じるか、説明してください。
```

# 結論

- ツリーを跨いだ取得には再帰的 CTE（WITH RECURSIVE）やアプリ側ループが必要になる
- 削除時が大変
    - 子が残って親だけ消すことをなくすよう考慮をしないといけない
        - ON DELETE CASCADE 付けると削除可能だが、深い階層で大量 DELETE が発生しロックが長期化しそう

