USE document_management;

-- ユーザテーブルにサンプルデータを挿入
INSERT INTO
    users (username, email, created_at)
VALUES
    (
        '山田太郎',
        'taro.yamada@example.com',
        '2023-01-01 09:00:00'
    ),
    (
        '佐藤花子',
        'hanako.sato@example.com',
        '2023-01-02 10:00:00'
    ),
    (
        '鈴木一郎',
        'ichiro.suzuki@example.com',
        '2023-01-03 11:00:00'
    );

-- ディレクトリテーブルにサンプルデータを挿入
INSERT INTO
    directories (created_by, created_at)
VALUES
    (1, '2023-02-01 10:00:00'),
    (2, '2023-02-05 14:30:00'),
    (1, '2023-02-10 15:45:00');

-- ディレクトリ変更イベントテーブルにサンプルデータを挿入
INSERT INTO
    directory_changes (directory_id, changed_by, name, changed_at)
VALUES
    (1, 1, 'プロジェクトA', '2023-02-01 10:00:00'),
    (2, 2, 'マーケティング部門', '2023-02-05 14:30:00'),
    (3, 1, '開発部', '2023-02-10 15:45:00'),
    (1, 1, 'プロジェクトA（改訂）', '2023-03-01 09:30:00');

-- ディレクトリ削除イベントテーブルにサンプルデータを挿入
INSERT INTO
    directory_deletes (directory_id, deleted_by, deleted_at)
VALUES
    (2, 2, '2023-04-01 12:00:00');

-- ドキュメントテーブルにサンプルデータを挿入
INSERT INTO
    documents (created_by, created_at)
VALUES
    (1, '2023-03-05 10:00:00'),
    (2, '2023-03-06 11:15:00');

-- ドキュメント変更イベントテーブルにサンプルデータを挿入
INSERT INTO
    document_changes (
        document_id,
        parent_directory_id,
        changed_by,
        title,
        content,
        changed_at
    )
VALUES
    (
        1,
        1,
        1,
        '仕様書',
        'これはプロジェクトAの初版仕様書です。',
        '2023-03-05 10:00:00'
    ),
    (
        1,
        1,
        1,
        '仕様書 更新',
        '仕様書にいくつかの変更が加えられました。',
        '2023-03-07 14:00:00'
    ),
    (
        2,
        3,
        2,
        '会議議事録',
        '開発部で行われた会議の議事録です。',
        '2023-03-06 11:15:00'
    );

-- ドキュメント削除イベントテーブルにサンプルデータを挿入
INSERT INTO
    document_deletes (document_id, deleted_by, deleted_at)
VALUES
    (2, 2, '2023-04-05 16:00:00');

-- ディレクトリ階層管理（クロージャテーブル）にサンプルデータを挿入
INSERT INTO
    directory_closures (
        ancestor_directory_id,
        descendant_directory_id,
        depth,
        created_at
    )
VALUES
    (1, 1, 0, '2023-02-01 10:00:00'),
    (2, 2, 0, '2023-02-05 14:30:00'),
    (3, 3, 0, '2023-02-10 15:45:00'),
    (1, 3, 1, '2023-02-10 15:45:00');