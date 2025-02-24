-- データベース作成
CREATE SCHEMA IF NOT EXISTS slack_clone;

USE slack_clone;

-- ユーザーテーブル
CREATE TABLE
    users (
        id INT NOT NULL AUTO_INCREMENT,
        name VARCHAR(255) NOT NULL,
        email VARCHAR(255) NOT NULL UNIQUE,
        created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        deleted_at DATETIME NOT NULL DEFAULT '9999-12-31 23:59:59',
        PRIMARY KEY (id),
    );

-- ワークスペーステーブル
CREATE TABLE
    workspaces (
        id INT NOT NULL AUTO_INCREMENT,
        name VARCHAR(255) NOT NULL,
        created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        PRIMARY KEY (id)
    );

-- ワークスペースとユーザの多対多関係を表す中間テーブル
CREATE TABLE
    workspace_users (
        id INT NOT NULL AUTO_INCREMENT,
        workspace_id INT NOT NULL,
        user_id INT NOT NULL,
        created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        PRIMARY KEY (id),
        CONSTRAINT fk_workspace_users_workspace FOREIGN KEY (workspace_id) REFERENCES workspaces (id),
        CONSTRAINT fk_workspace_users_user FOREIGN KEY (user_id) REFERENCES users (id),
        CONSTRAINT uniq_workspace_user UNIQUE (workspace_id, user_id)
    );

-- チャンネルテーブル
CREATE TABLE
    channels (
        id INT NOT NULL AUTO_INCREMENT,
        workspace_id INT NOT NULL,
        name VARCHAR(255) NOT NULL,
        created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        PRIMARY KEY (id),
        CONSTRAINT fk_channels_workspace FOREIGN KEY (workspace_id) REFERENCES workspaces (id)
    );

-- チャンネルとユーザの多対多関係を表す中間テーブル
CREATE TABLE
    channel_users (
        id INT NOT NULL AUTO_INCREMENT,
        channel_id INT NOT NULL,
        user_id INT NOT NULL,
        created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        PRIMARY KEY (id),
        CONSTRAINT fk_channel_users_channel FOREIGN KEY (channel_id) REFERENCES channels (id),
        CONSTRAINT fk_channel_users_user FOREIGN KEY (user_id) REFERENCES users (id),
        CONSTRAINT uniq_channel_user UNIQUE (channel_id, user_id)
    );

-- メッセージテーブル
CREATE TABLE
    messages (
        id INT NOT NULL AUTO_INCREMENT,
        channel_id INT NOT NULL,
        user_id INT NOT NULL,
        content TEXT NOT NULL,
        created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        deleted_at DATETIME NOT NULL DEFAULT '9999-12-31 23:59:59',
        PRIMARY KEY (id),
        CONSTRAINT fk_messages_channel FOREIGN KEY (channel_id) REFERENCES channels (id),
        CONSTRAINT fk_messages_user FOREIGN KEY (user_id) REFERENCES users (id)
    );

-- スレッドメッセージテーブル
CREATE TABLE
    thread_messages (
        id INT NOT NULL AUTO_INCREMENT,
        message_id INT NOT NULL,
        user_id INT NOT NULL,
        content TEXT NOT NULL,
        created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        PRIMARY KEY (id),
        CONSTRAINT fk_thread_messages_message FOREIGN KEY (message_id) REFERENCES messages (id),
        CONSTRAINT fk_thread_messages_user FOREIGN KEY (user_id) REFERENCES users (id)
    );