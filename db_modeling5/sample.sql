-- 1. 新規記事投稿（記事 + 初回バージョン1 を同時に登録）
BEGIN;

-- 1-1. articles に投稿者を登録し、生成された article_id を取得
WITH
    ins_article AS (
        INSERT INTO
            articles (author_id)
        VALUES
            ('<author_uuid>') RETURNING id AS article_id
    ),
    -- 1-2. article_versions に version_number = 1 で登録
    ins_version AS (
        INSERT INTO
            article_versions (
                article_id,
                editor_id,
                version_number,
                title,
                content
            )
        SELECT
            article_id,
            '<author_uuid>',
            1,
            '<記事のタイトル>',
            '<本文（最大1000文字程度）>'
        FROM
            ins_article RETURNING id AS version_id,
            article_id
    )
    -- 1-3. articles.current_version_id を新規バージョンに設定
UPDATE articles
SET
    current_version_id = ins_version.version_id
FROM
    ins_version
WHERE
    articles.id = ins_version.article_id;

COMMIT;

-- 2. 記事の更新
BEGIN;

-- 2-1. 新しいバージョン番号を計算して登録
WITH
    new_ver AS (
        INSERT INTO
            article_versions (
                article_id,
                editor_id,
                version_number,
                title,
                content
            )
        SELECT
            a.id,
            '<editor_uuid>',
            COALESCE(MAX(v.version_number), 0) + 1, -- 新しいバージョン番号
            '<更新後のタイトル>',
            '<更新後の本文>'
        FROM
            articles a
            LEFT JOIN article_versions v ON v.article_id = a.id
        WHERE
            a.id = '<target_article_id>'
        GROUP BY
            a.id RETURNING id AS version_id,
            article_id
    )
    -- 2-2. articles.current_version_id を最新バージョンに更新
UPDATE articles
SET
    current_version_id = new_ver.version_id
FROM
    new_ver
WHERE
    articles.id = new_ver.article_id;

COMMIT;

-- 3. 特定記事の履歴一覧を取得
SELECT
    v.version_number,
    u.name AS editor_name,
    v.title,
    v.created_at AS edited_at
FROM
    article_versions v
    JOIN users u ON u.id = v.editor_id
WHERE
    v.article_id = '<target_article_id>'
ORDER BY
    v.version_number DESC;

-- 4. 最新状態の記事を一覧表示
SELECT
    a.id AS article_id,
    u.name AS author_name,
    v.title,
    SUBSTRING(
        v.content
        FROM
            1 FOR 200
    ) AS snippet,
    v.created_at AS updated_at
FROM
    articles a
    JOIN users u ON u.id = a.author_id
    JOIN article_versions v ON v.id = a.current_version_id
ORDER BY
    v.created_at DESC;