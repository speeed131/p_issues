-- 拡張モジュールの有効化（UUID 生成用）
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ユーザーテーブル
CREATE TABLE
    users (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
        name VARCHAR(255) NOT NULL,
        email VARCHAR(255) NOT NULL UNIQUE
    );

-- 記事テーブル
CREATE TABLE
    articles (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
        author_id UUID NOT NULL REFERENCES users (id) ON DELETE RESTRICT,
        created_at TIMESTAMPTZ NOT NULL DEFAULT now (),
        current_version_id UUID
    );

-- 記事バージョンテーブル
CREATE TABLE
    article_versions (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
        article_id UUID NOT NULL REFERENCES articles (id) ON DELETE CASCADE,
        editor_id UUID NOT NULL REFERENCES users (id) ON DELETE RESTRICT,
        version_number INTEGER NOT NULL,
        title VARCHAR(255) NOT NULL,
        content TEXT NOT NULL,
        created_at TIMESTAMPTZ NOT NULL DEFAULT now (),
        CONSTRAINT uq_article_version UNIQUE (article_id, version_number)
    );

-- articles.current_version_id に FK 制約を追加
ALTER TABLE articles ADD CONSTRAINT fk_articles_current_version FOREIGN KEY (current_version_id) REFERENCES article_versions (id) ON DELETE SET NULL;

-- 記事の履歴一覧取得用のインデックス作成
CREATE INDEX idx_article_versions_article_id ON article_versions (article_id);