
# 課題

データベース設計のアンチパターン8
課題1

# 結論

１．「mailAddress」カラムには、特定のドメインを持ったメールアドレスしか登録できない（<a@example.com>, <b@example.com>など）。Checkを使うべきでしょうか？

- 使うべき状況
  - ドメイン一覧がほぼ固定で、頻繁に変更しない
  - 複数のアプリケーション（バッチ、管理画面、外部システム）から同じ DB を参照していて、必ず同じルールを適用したい
  - 不正データ流入を絶対防ぎたい
- 使うべきではない状況
  - ドメインリストが頻繁に変わる
- 上記から、ドメインリストの変更が少しでも発生しそうならアプリケーション側で担保が良さそう

２．ユーザーが退会した時、当該ユーザーのレコードを「User」テーブルから削除し、同じ情報を「WithdrawnUser」テーブルに挿入しなければいけない。Triggerを使うべきでしょうか？

- 使うべき状況
  - 漏れを必ずなくしたい
    - アプリケーション経由以外（バッチ処理や別クライアント）から DELETE が行われても、必ず withdrawn_users に残したいなど
- 使うべきではない状況
  - 複数の業務ロジックをまとめて実行する必要がある
    - 退会通知メールの送信、キャッシュクリア、外部 API 呼び出しなどが伴う
  - 柔軟な制御が必要
    - 特定の条件下では別のフローを使うなど、削除ごとに処理を変えたい場合、トリガーだと複雑化する

- 上記から、削除フローにロジックを絡ませる場合が多そうなため、基本アプリケーション層で実装するケースが多そう

３．「gender」カラムには「male」「female」「no response」いずれかの値しか入れてはいけない。Enumを使うべきでしょうか？

- 使うべき状況
  - 選択肢が完全に固定的で、ほとんど変わらない場合
    - DDL を見ただけでカラムの取りうる値が明示されるのはメリット
- 使うべきではない状況
  - 変更する可能性がある場合
  - DB側でラベルを持って、柔軟に変更したい場合
- 上記から、性別のように変わらないと考えられる設計であればデータベース側でENUMを使用しても良さそう

４，「postCode」カラムには特定形式の文字列しか入れてはいけない。Domainを使うべきでしょうか？

- 使うべき状況
  - 書式チェックを DB 層で必ず保証したい
    - プリケーション経由・バッチ経由・直接 SQL からの挿入まで、全て同一のチェックがなされるメリット

- 使うべきではない状況
  - 書式ルールが頻繁に変わる場合
- 上記から、書式ルール変更が頻繁になければDB側でドメインの書式チェックを使っても良いと思うが、post_codeはユーザ入力値でフォーマット処理なども含まれそうなのでアプリケーション側のバリデーションも組み合わせると良さそう
