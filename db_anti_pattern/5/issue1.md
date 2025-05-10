
# 課題名

データベース設計のアンチパターン5
課題1

# 課題

Salesforceのようなサービスを想像してみてください。
以下のようなテーブルで新規顧客の営業進捗を管理しているとします。

```sql
TABLE NewCustomer {
  id: varchar
  called: boolean -- 電話をかけたらTRUEになる。FALSEの人には電話をかけなければいけない
  callNote: varchar -- 電話をかけた時に交わした内容のメモ
  metOnce: boolean -- アポで面談したらTRUEになる
  metAt: date -- 面談をした日付が入る
  closed: boolean -- 成約した
  closedAt: date -- 成約した日付が入る
}
```


# 結論

- 複数の商談回数を保存できない
- called = FALSE なのに callNote が入っているなど、データ整合性が取れない可能性がある
- 解約→再契約のようなケースで上書きが発生すると、管理できない
- 使わない列が常にnull値となり、制約が曖昧である