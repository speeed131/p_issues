USE slack_clone;

INSERT INTO
  users (name, email)
VALUES
  ('山田 太郎', 'taro.yamada@example.com'),
  ('鈴木 花子', 'hanako.suzuki@example.com'),
  ('佐藤 次郎', 'jiro.sato@example.com'),
  ('田中 一郎', 'ichiro.tanaka@example.com'),
  ('高橋 美咲', 'misaki.takahashi@example.com');

INSERT INTO
  workspaces (name)
VALUES
  ('株式会社アクメ'),
  ('ベータテスターズ'),
  ('チャット倶楽部');

INSERT INTO
  workspace_users (workspace_id, user_id)
VALUES
  (1, 1),
  (1, 2),
  (2, 2),
  (2, 3),
  (3, 4),
  (3, 5);

INSERT INTO
  channels (workspace_id, name)
VALUES
  (1, 'general'),
  (1, 'random'),
  (1, 'announcement'),
  (1, 'development'),
  (1, 'design'),
  (1, 'marketing'),
  (2, 'general'),
  (2, 'development'),
  (2, 'design'),
  (3, 'general'),
  (3, 'announcement'),
  (3, 'development'),
  (1, 'design'),
  (1, 'marketing');

INSERT INTO
  channel_users (channel_id, user_id)
VALUES
  (1, 1),
  (1, 2),
  (2, 1),
  (3, 2),
  (3, 3);

INSERT INTO
  messages (channel_id, user_id, content)
VALUES
  (1, 1, 'みなさん、こんにちは！'),
  (1, 2, '太郎さん、こんにちは！'),
  (3, 5, '更新された方針をお読みください。');

INSERT INTO
  thread_messages (message_id, user_id, content)
VALUES
  (1, 2, 'アップデートありがとう！');