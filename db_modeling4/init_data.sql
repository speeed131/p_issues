-- workspaces（Slack ワークスペース情報）
INSERT INTO
    workspaces (
        team_id,
        team_name,
        access_token,
        bot_user_id,
        app_id,
        scope,
        created_at
    )
VALUES
    (
        'T12345678',
        'Slack開発チーム',
        'ENCRYPTED_ACCESS_TOKEN_123',
        'U99999999',
        'A11111111',
        'chat:write,commands',
        '2025-04-05 10:00:00'
    );

-- users（ワークスペース内のユーザー）
INSERT INTO
    users (workspace_id, user_id, user_name, created_at)
VALUES
    (1, 'U1001', 'taro', '2025-04-05 10:01:00'),
    (1, 'U1002', 'hanako', '2025-04-05 10:01:30'),
    (1, 'U1003', 'john', '2025-04-05 10:02:00');

-- reminders（リマインダー定義）
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
        1,
        1,
        2,
        '毎週の定例ミーティングをお忘れなく！',
        '0 9 * * 1',
        'C111CHANNEL',
        '2025-04-05 10:10:00'
    ),
    (
        1,
        2,
        3,
        '今月のレポートを提出してください。',
        '30 10 28 * *',
        'C222CHANNEL',
        '2025-04-05 10:11:00'
    );

-- reminder_tasks（次回送信予定）
INSERT INTO
    reminder_tasks (reminder_id, next_schedule_at, created_at)
VALUES
    (1, '2025-04-07 09:00:00', '2025-04-05 10:20:00'), -- 次の月曜
    (2, '2025-04-28 10:30:00', '2025-04-05 10:21:00');

-- 次の28日
-- reminder_tasks_logs（過去の送信ログ）
INSERT INTO
    reminder_tasks_logs (reminder_id, status, executed_at)
VALUES
    (1, 'completed', '2025-03-31 09:00:00'),
    (2, 'completed', '2025-03-28 10:30:00');