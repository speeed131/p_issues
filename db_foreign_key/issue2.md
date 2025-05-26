
# 課題

外部キー制約
課題2

# 結論

## 2-1

- RESTRICT（親テーブルに対する削除または更新操作を拒否）
  - サブスクなどで `plans`と `subscriptions` があり、 `subscriptions.plan_id` のようにサブスクがプランに紐づく場合、プランを消すと不整合が起きるケース
- CASCADE（親行の削除・更新を子行にも自動伝播する）
  - ブログの `posts` と `comments` などの親が存在しないなら子に意味がないケース
- SET NULL
  - イシューリストなどの `issues.assignee_id NULL → users.id` で未担当という状態を保持したい場合など

## 2-2

部署削除で従業員も削除されてしまう問題

## 2-3

担当者のユーザが削除された場合に、その担当者のイシューがnullになってしまう問題

## 2-4

- Prisma
  - reuqired(not null)の場合、削除時は `Restrict`, 更新時は `Cascade`
    - 削除時では親データの保存を最優先にし、意図しないデータ損失を防いでいる
    - 更新時は、CascadeでPK更新等も考慮している
  - optional(null許可)の場合、削除時は`set null`、更新時は`Cascade`
    - 削除時は null でリレーションをなくすことを許可し、履歴も残せる
    - 更新時は、CascadeでPK更新等も考慮している
  <https://www.prisma.io/docs/orm/prisma-schema/data-model/relations/referential-actions#referential-action-defaults>

- TypeORM
  - 削除、更新ともにRestrict
    - 意図しないデータ損失を最優先に防いでいる
      - MySQL等のRDBの既定値をそのまま使っている。変更したい場合は明示的に書くように求めている思想
<https://orkhan.gitbook.io/typeorm/docs/relations>

- MySQLとPostgreSQLのRESTRICT と NO ACTION の違い
  - MySQL
    - 上記のRestrictとNO ACTIONが同義で、制約はすぐににチェックされ、違反するとエラーが出る
  - PostgreSQL
    - NO ACTION
      - デフォルト値
      - 遅延チェック可能で、トランザクション終端までまたは文の終端まで制約判定を先送りできる
    - RESTRICT
      - 即時チェックになる
  