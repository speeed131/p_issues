--  ドキュメントの最新の変更（タイトル・内容）を取得するクエリ
SELECT
    dc.document_id,
    dc.title,
    dc.content,
    dc.changed_at
FROM
    document_changes dc
WHERE
    NOT EXISTS (
        SELECT
            1
        FROM
            document_changes sub
        WHERE
            sub.document_id = dc.document_id
            AND sub.changed_at > dc.changed_at
    );

-- 特定のドキュメントの変更履歴を取得するクエリ
WITH
    latest_changes AS (
        SELECT
            '変更' AS event_type,
            dc.changed_at AS event_time,
            dc.changed_by AS user_id,
            u.username AS user_name,
            dc.document_id,
            dc.title,
            dc.content
        FROM
            document_changes dc
            JOIN users u ON dc.changed_by = u.id
        WHERE
            dc.document_id = 1
    )
SELECT
    *
FROM
    latest_changes
ORDER BY
    event_time;

-- ユーザがドキュメントを作成するクエリ
INSERT INTO
    documents (created_by, created_at)
VALUES
    (1, CURRENT_TIMESTAMP);

-- 初回の変更イベントを記録（作成時）
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
    (3, 3, 1, '新しい仕様書', 'ドキュメント投入', CURRENT_TIMESTAMP);

-- すぐに修正（変更イベントを追加）
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
        3,
        3,
        3,
        'プロジェクト計画書（修正）',
        '詳細を追記しました。',
        CURRENT_TIMESTAMP
    );

-- ドキュメントの表示順序を更新するクエリ
START TRANSACTION;

UPDATE document_orders
SET
    order_index = 2,
    updated_at = NOW ()
WHERE
    document_id = 1;

UPDATE document_orders
SET
    order_index = 1,
    updated_at = NOW ()
WHERE
    document_id = 2;

COMMIT;