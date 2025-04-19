-- 1) サンプルユーザ登録
INSERT INTO
    users (name, email)
VALUES
    ('山田太郎', 'taro.yamada@example.com'),
    ('鈴木花子', 'hanako.suzuki@example.com');

-- 2) サンプル記事登録
INSERT INTO
    articles (author_id)
SELECT
    id
FROM
    users
WHERE
    email = 'taro.yamada@example.com';

INSERT INTO
    articles (author_id)
SELECT
    id
FROM
    users
WHERE
    email = 'hanako.suzuki@example.com';

-- 3) 記事バージョン登録
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
    u.id,
    1,
    'はじめての記事',
    'これは山田太郎による最初の記事です。'
FROM
    articles a
    JOIN users u ON a.author_id = u.id
WHERE
    u.email = 'taro.yamada@example.com';

-- 4) 記事バージョン登録
UPDATE articles
SET
    current_version_id = (
        SELECT
            id
        FROM
            article_versions v
        WHERE
            v.article_id = articles.id
        ORDER BY
            version_number DESC
        LIMIT
            1
    );