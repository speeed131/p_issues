-- データベース作成
CREATE SCHEMA IF NOT EXISTS penpen;

USE penpen;

CREATE TABLE
    workspaces (
        id INT AUTO_INCREMENT PRIMARY KEY,
        team_id VARCHAR(255) NOT NULL,
        team_name VARCHAR(255) NOT NULL,
        access_token VARCHAR(255) NOT NULL,
        bot_user_id VARCHAR(255) NOT NULL,
        app_id VARCHAR(255) NOT NULL,
        scope VARCHAR(255),
        created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        UNIQUE KEY (team_id)
    );

CREATE TABLE
    users (
        id INT AUTO_INCREMENT PRIMARY KEY,
        workspace_id INT NOT NULL,
        user_id VARCHAR(255) NOT NULL,
        user_name VARCHAR(255) NOT NULL,
        created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (workspace_id) REFERENCES workspaces (id),
        UNIQUE KEY (workspace_id, user_id)
    );

CREATE TABLE
    reminders (
        id INT AUTO_INCREMENT PRIMARY KEY,
        workspace_id INT NOT NULL,
        created_by INT NOT NULL,
        receiver INT NOT NULL,
        message TEXT NOT NULL,
        reminder_schedule_cron VARCHAR(255) NOT NULL,
        channel_id VARCHAR(255),
        created_at DATETIME NOT NULL,
        FOREIGN KEY (workspace_id) REFERENCES workspaces (id),
        FOREIGN KEY (created_by) REFERENCES users (id),
        FOREIGN KEY (receiver) REFERENCES users (id)
    );

CREATE TABLE
    reminder_tasks (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reminder_id INT NOT NULL,
        next_schedule_at DATETIME NOT NULL,
        created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (reminder_id) REFERENCES reminders (id),
        INDEX idx_next_schedule_at (next_schedule_at)
    );

CREATE TABLE
    reminder_tasks_logs (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reminder_id INT NOT NULL,
        status VARCHAR(255) NOT NULL, -- 'completed' or 'failed'
        executed_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (reminder_id) REFERENCES reminders (id),
        INDEX idx_executed_at (executed_at)
    );