-- ワークスペース参加
INSERT INTO
  workspace_users (workspace_id, user_id)
VALUES
  (1, 3);

-- ワークスペース脱退
DELETE FROM workspace_users
WHERE
  workspace_id = 1
  AND user_id = 3;

-- チャネル参加
INSERT INTO
  channel_users (channel_id, user_id)
VALUES
  (1, 3);

-- チャネル脱退
DELETE FROM channel_users
WHERE
  channel_id = 1
  AND user_id = 3;

-- メッセージの投稿
INSERT INTO
  messages (channel_id, user_id, content)
VALUES
  (1, 1, 'みなさん、こんにちは！ hoge');

-- スレッドメッセージの投稿
INSERT INTO
  thread_messages (message_id, user_id, content)
VALUES
  (1, 2, '返信ありがとうございます。');

-- チャネル内のメッセージ取得
SELECT
  m.id,
  m.channel_id,
  m.user_id,
  m.content,
  m.created_at,
  m.updated_at,
  m.deleted_at,
  u.name AS poster_name
FROM
  messages m
  JOIN users u ON m.user_id = u.id
WHERE
  m.channel_id = 1
ORDER BY
  m.created_at ASC;

-- チャネル内のスレッドメッセージ取得
SELECT
  tm.id,
  tm.message_id,
  tm.user_id,
  tm.content,
  tm.created_at,
  tm.updated_at,
  u.name AS poster_name
FROM
  thread_messages tm
  JOIN users u ON tm.user_id = u.id
  JOIN messages m ON tm.message_id = m.id
WHERE
  m.channel_id = 1
ORDER BY
  tm.created_at ASC;

-- 横断的検索（ワークスペース指定、参加しているチャネルのメッセージ 例: workspace_id=1、ユーザID=1、contentに「hoge」を含む）
SELECT
  m.id,
  m.channel_id,
  m.user_id,
  m.content,
  m.created_at,
  'message' AS type
FROM
  messages m
  JOIN channels ch ON m.channel_id = ch.id
  JOIN channel_users cu ON m.channel_id = cu.channel_id
WHERE
  cu.user_id = 1
  AND m.content LIKE '%hoge%'
  AND ch.workspace_id = 1
UNION ALL
SELECT
  tm.id,
  m.channel_id,
  tm.user_id,
  tm.content,
  tm.created_at,
  'thread_message' AS type
FROM
  thread_messages tm
  JOIN messages m ON tm.message_id = m.id
  JOIN channels ch ON m.channel_id = ch.id
  JOIN channel_users cu ON m.channel_id = cu.channel_id
WHERE
  cu.user_id = 1
  AND tm.content LIKE '%hoge%'
  AND ch.workspace_id = 1
ORDER BY
  created_at ASC;