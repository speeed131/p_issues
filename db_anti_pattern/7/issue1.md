
# 課題

データベース設計のアンチパターン7
課題1

# 結論

- 全てのSELECT／JOIN文で必ずWHERE taikaiFlag = FALSE（退会済みを除外）を入れないと、退会済みユーザーが混ざってしまうリスクがある
  - 考慮漏れの可能性が高まる
- 退会フラグを立てても、nameやメールアドレスなどのユニーク制約はそのまま残る。退会ユーザーのデータが残り続けると、同じ名前やメールを再登録したいケースで面倒になる
- 退会ユーザーのレコードも同じテーブル内に残り続けるため、データ肥大化によるパフォーマンス懸念
- 「仮登録」「休会」「学籍停止」など状態が増えてきたとき、boolean フラグが乱立して「どの組み合わせが有効か」を都度考える必要が生じる
-
