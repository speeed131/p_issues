--------
-- /penpen 実行時のクエリ
--------
-- 1 ユーザー登録（存在しなければ）
INSERT INTO
    users (workspace_id, user_id, user_name, created_at)
VALUES
    (1, 'U2001', 'suzuki', '2025-04-05 11:00:00') ON DUPLICATE KEY
UPDATE user_name =
VALUES
    (user_name);

-- 2 リマインダーの登録
INSERT INTO
    reminders (
        workspace_id,
        created_by,
        receiver,
        message,
        reminder_schedule_cron,
        channel_id,
        created_at
    )
VALUES
    (
        1, -- workspace_id
        1, -- created_by (users.id)
        2, -- receiver (users.id)
        '水を飲むのを忘れずに！',
        '0 10 * * *', -- 毎日10:00
        'C12345678',
        '2025-04-05 11:00:00'
    );

-- 3 初回送信スケジュールを reminder_tasks に登録
INSERT INTO
    reminder_tasks (reminder_id, next_schedule_at, created_at)
VALUES
    (
        LAST_INSERT_ID (), -- 上のremindersのID
        '2025-04-06 10:00:00', -- cron式からアプリで計算した日時
        '2025-04-05 11:00:10'
    );

--------
-- /penpen 実行時のクエリ
--------
-- 1 実行対象のリマインダー取得
SELECT
    rt.id AS task_id,
    r.id AS reminder_id,
    r.workspace_id,
    r.created_by,
    r.message,
    r.receiver,
    r.channel_id
FROM
    reminder_tasks rt
    JOIN reminders r ON rt.reminder_id = r.id
WHERE
    rt.next_schedule_at <= '2025-04-06 10:00:00';

-- 2 実行ログを reminder_tasks_logs に挿入
INSERT INTO
    reminder_tasks_logs (reminder_id, status, executed_at)
VALUES
    (
        3, -- reminder_id
        'completed', -- または 'failed'
        '2025-04-06 10:00:00'
    );

-- 3 実行済みのタスクを削除
DELETE FROM reminder_tasks
WHERE
    id = 3;

-- 4 次回実行タスクを登録
INSERT INTO
    reminder_tasks (reminder_id, next_schedule_at, created_at)
VALUES
    (
        1,
        '2025-04-07 10:00:00', -- cron式から算出した次回の送信時間
        '2025-04-06 10:00:00'
    );

--------
-- その他
--------
-- ログの履歴を時系列で検索・分析する
SELECT
    *
FROM
    reminder_tasks_logs
WHERE
    executed_at >= '2025-04-01'
    AND executed_at < '2025-04-08';