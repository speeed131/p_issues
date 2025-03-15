SET
  cte_max_recursion_depth = 1000000;

INSERT INTO
  messages (channel_id, user_id, content, created_at)
WITH RECURSIVE
  numbers AS (
    SELECT
      1 AS n
    UNION ALL
    SELECT
      n + 1
    FROM
      numbers
    WHERE
      n < 1000000
  )
SELECT
  FLOOR(RAND () * 3) + 1,
  FLOOR(RAND () * 5) + 1,
  CONCAT (SUBSTRING(MD5 (RAND ()), 1, 10)),
  DATE_ADD ('2024-01-01', INTERVAL FLOOR(RAND () * 365) DAY)
FROM
  numbers;

INSERT INTO
  thread_messages (message_id, user_id, content, created_at)
WITH RECURSIVE
  numbers AS (
    SELECT
      1 AS n
    UNION ALL
    SELECT
      n + 1
    FROM
      numbers
    WHERE
      n < 10000
  )
SELECT
  FLOOR(RAND () * 100000) + 1 AS message_id,
  FLOOR(RAND () * 5) + 1 AS user_id,
  CONCAT (SUBSTRING(MD5 (RAND ()), 1, 10)) AS content,
  DATE_ADD ('2024-01-01', INTERVAL FLOOR(RAND () * 365) DAY) AS created_at
FROM
  numbers;