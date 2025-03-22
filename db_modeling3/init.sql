-- データベース作成
CREATE SCHEMA IF NOT EXISTS document_management;

USE document_management;

-- ユーザテーブル
CREATE TABLE
    users (
        id INT AUTO_INCREMENT PRIMARY KEY,
        username VARCHAR(255) NOT NULL,
        email VARCHAR(255) NOT NULL UNIQUE,
        created_at DATETIME NOT NULL
    );

-- ディレクトリテーブル
CREATE TABLE
    directories (
        id INT AUTO_INCREMENT PRIMARY KEY,
        created_by INT NOT NULL,
        created_at DATETIME NOT NULL,
        FOREIGN KEY (created_by) REFERENCES users (id)
    );

-- ディレクトリ変更イベントテーブル
CREATE TABLE
    directory_changes (
        id INT AUTO_INCREMENT PRIMARY KEY,
        directory_id INT NOT NULL,
        changed_by INT NOT NULL,
        name VARCHAR(255) NOT NULL,
        changed_at DATETIME NOT NULL,
        FOREIGN KEY (directory_id) REFERENCES directories (id),
        FOREIGN KEY (changed_by) REFERENCES users (id)
    );

-- ディレクトリ削除イベントテーブル
CREATE TABLE
    directory_deletes (
        id INT AUTO_INCREMENT PRIMARY KEY,
        directory_id INT NOT NULL UNIQUE, -- ディレクトリIDは一意のためUNIQUE制約を付与
        deleted_by INT NOT NULL,
        deleted_at DATETIME NOT NULL,
        FOREIGN KEY (directory_id) REFERENCES directories (id),
        FOREIGN KEY (deleted_by) REFERENCES users (id)
    );

-- ドキュメントテーブル
CREATE TABLE
    documents (
        id INT AUTO_INCREMENT PRIMARY KEY,
        created_by INT NOT NULL,
        created_at DATETIME NOT NULL,
        FOREIGN KEY (created_by) REFERENCES users (id)
    );

-- ドキュメント変更イベントテーブル
CREATE TABLE
    document_changes (
        id INT AUTO_INCREMENT PRIMARY KEY,
        document_id INT NOT NULL,
        parent_directory_id INT NOT NULL,
        changed_by INT NOT NULL,
        title VARCHAR(255) NOT NULL,
        content TEXT NOT NULL,
        changed_at DATETIME NOT NULL,
        FOREIGN KEY (document_id) REFERENCES documents (id),
        FOREIGN KEY (parent_directory_id) REFERENCES directories (id),
        FOREIGN KEY (changed_by) REFERENCES users (id)
    );

-- ドキュメント削除イベントテーブル
CREATE TABLE
    document_deletes (
        id INT AUTO_INCREMENT PRIMARY KEY,
        document_id INT NOT NULL UNIQUE, -- ドキュメントIDは一意のためUNIQUE制約を付与
        deleted_by INT NOT NULL,
        deleted_at DATETIME NOT NULL,
        FOREIGN KEY (document_id) REFERENCES documents (id),
        FOREIGN KEY (deleted_by) REFERENCES users (id)
    );

-- ディレクトリ階層管理（クロージャテーブル）
CREATE TABLE
    directory_closures (
        ancestor_directory_id INT NOT NULL,
        descendant_directory_id INT NOT NULL,
        depth INT NOT NULL,
        created_at DATETIME NOT NULL,
        PRIMARY KEY (ancestor_directory_id, descendant_directory_id),
        FOREIGN KEY (ancestor_directory_id) REFERENCES directories (id),
        FOREIGN KEY (descendant_directory_id) REFERENCES directories (id)
    );

-- 複合インデックスの追加で最新のドキュメント変更イベント取得を高速化
CREATE INDEX idx_document_changes_docid_changedat ON document_changes (document_id, changed_at);