# DDD 特大課題1

## ユースケース図

```mermaid
flowchart LR
    Participant[参加者]
    Admin[管理者（運営/通知先）]

    subgraph System["<<システム>> プラハチャレンジ運営システム"]
        UC_ChangeStatus(("在籍ステータスを変更する"))
        UC_UpdateProgress(("課題進捗を更新する <br/>（所有者のみ）"))
        UC_ViewProgress(("課題進捗を参照する"))
        UC_Rebalance(("チーム再編を実行する"))
        UC_Notify(("管理者へ通知する"))
    end

    Participant --- UC_ChangeStatus
    Admin --- UC_ChangeStatus
    Participant --- UC_UpdateProgress
    Participant --- UC_ViewProgress

    Admin --- UC_Notify

    UC_ChangeStatus -. "在籍変更時に必ず実行" .-> UC_Rebalance
    UC_Rebalance -. "2名以下または<br/>合流先なしのとき通知" .-> UC_Notify
```

## チーム再編のフローチャート

```mermaid
flowchart TD
    A[在籍ステータス変更] --> B{変更種別}
    B -->|休会/退会| C[所属チームから離脱]
    B -->|復帰| D[最少人数チームへ自動配属]

    C --> E{離脱後のチーム人数}
    E -->|3名| Z[終了]
    E -->|2名| N1[管理者へ通知]
    E -->|1名| N2[管理者へ通知]

    N1 --> Z
    N2 --> F[残り1名の合流先を選定<br/>最少人数優先/同数ランダム]
    F --> G{合流先ありか}
    G -->|No| N3[管理者へ通知]
    G -->|Yes| H[1名を自動合流]
    N3 --> Z
    H --> H2{合流先が5名になったか}
    H2 -->|No| Z
    H2 -->|Yes| J[チームを自動分割]

    D --> I{配属先が5名になったか}
    I -->|No| Z
    I -->|Yes| J[チームを自動分割]
    J --> Z
```

## 課題進捗の状態遷移図

```mermaid
stateDiagram-v2
    [*] --> 未着手
    未着手 --> 取組中
    取組中 --> レビュー待ち
    レビュー待ち --> 取組中
    レビュー待ち --> 完了
    完了 --> [*]
```

## ドメインモデル図（集約境界つき）

```mermaid
classDiagram
    direction LR

    namespace 参加者集約 {
        class Participant["参加者（エンティティ / 集約ルート）"] {
            +参加者ID id
            +参加者名 name
            +メールアドレス email
            +在籍ステータス status
        }

        class ParticipantId["参加者ID（値オブジェクト）"] {
            +string value
        }

        class EmailAddress["メールアドレス（値オブジェクト）"] {
            +string value
        }

        class ParticipantStatus["在籍ステータス（列挙）"] {
            在籍中
            休会中
            退会済
        }
    }

    namespace チーム集約 {
        class Team["チーム（エンティティ / 集約ルート）"] {
            +チームID id
            +チーム名 name
            +所属一覧 members
            +メンバーを追加する(participantId)
            +メンバーを外す(participantId)
            +重複所属かを判定する(participantId)
            +上限超過かを判定する()
        }

        class TeamMember["チーム所属（値オブジェクト）"] {
            +参加者ID participantId
        }

        class TeamId["チームID（値オブジェクト）"] {
            +string value
        }

        class TeamName["チーム名（値オブジェクト）"] {
            +string value
        }
    }

    namespace 参加者課題集約 {
        class ParticipantTask["参加者課題（エンティティ / 集約ルート）"] {
            +参加者課題ID id
            +参加者ID participantId
            +課題ID taskId
            +進捗ステータス status
            +進捗を更新する(actorId, nextStatus)
            +所有者かを判定する(actorId)
            +遷移可能かを判定する(nextStatus)
        }

        class TaskProgressStatus["課題進捗ステータス（列挙）"] {
            未着手
            取組中
            レビュー待ち
            完了
        }
    }

    namespace 課題集約 {
        class Task["課題（エンティティ）"] {
            +課題ID id
            +課題名 title
        }

        class TaskId["課題ID（値オブジェクト）"] {
            +string value
        }
    }

    namespace ドメインサービス {
        class TeamRebalanceService["チーム再編サービス（ドメインサービス）"] {
            +在籍変更に伴う再編を実行
        }

        class TeamSelectionPolicy["チーム選択ポリシー（ポリシー）"] {
            +最少人数優先
            +同数はランダム
        }

        class AdminNotificationService["管理者通知サービス（ドメインサービス）"] {
            +2名以下/合流先なしを通知
        }
    }

    Participant --> ParticipantId
    Participant --> EmailAddress
    Participant --> ParticipantStatus

    Team --> TeamId
    Team --> TeamName
    Team "1" o-- "0..5" TeamMember : members（通常2..4）
    TeamMember --> ParticipantId : 参加者をID参照

    Task --> TaskId
    ParticipantTask --> ParticipantId : 所有者をID参照
    ParticipantTask --> TaskId : 課題をID参照
    ParticipantTask --> TaskProgressStatus

    TeamRebalanceService ..> Team
    TeamRebalanceService ..> Participant
    TeamRebalanceService ..> TeamSelectionPolicy
    TeamRebalanceService ..> AdminNotificationService
```

## ドメインルール

| ルール | どこで守るか | 補足 |
|---|---|---|
| メールアドレス重複不可 | 登録/更新ユースケース + 参加者リポジトリ照会 | 最終防衛（一意制約など）は実装設計で決める |
| チーム名重複不可 | 登録/更新ユースケース + チームリポジトリ照会 | 最終防衛（一意制約など）は実装設計で決める |
| 在籍中以外はチーム所属不可 | 在籍ステータス変更処理 + チーム再編サービス | 集約横断ルール |
| チーム名形式、重複所属禁止、追加/削除 | `Team` のメソッド | 集約内ルール |
| 所有者のみ更新可、進捗ステータス遷移 | `ParticipantTask` のメソッド | 集約内ルール |
| 1名/5名チームの解消 | `TeamRebalanceService` | 2~4名の状態へ収束させる |
| 2名以下/合流先なしの通知 | `AdminNotificationService` | 管理者へ通知する |
