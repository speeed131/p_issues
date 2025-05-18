
# 課題

アンチパターンを踏まえてDBモデリングを見直そう

# 結論

## DBモデリング１

- <https://github.com/speeed131/p_issues/blob/a292cf86e86760f4d0a4fb2ae0aff523cf898ac8/db_modeling1/issue3/init.sql#L67>
  - CHECK制約があるが、シャリの大きさが今後も変わる可能性を考え、アプリケーション側のバリデーションにする
