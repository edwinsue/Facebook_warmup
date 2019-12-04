## This seems way too easy...

WITH comment_count_by_user AS 
    (SELECT 
    COUNT(*) AS comment_count
    FROM users u
    INNER JOIN user_comments uc ON u.id = uc.user_id
    WHERE uc.created_at > '2019-01-01' AND uc.created_at < '2019-12-31'
    GROUP BY u.id)

SELECT 
comment_count || ' comments' AS bin_val
COUNT(*) OVER (PARTITION BY comment_count) AS frequency
FROM comment_count_by_user
--

## What the answer should have looked like...
 
WITH comments AS (
    SELECT 
    MAX(comment_count) AS max,
    MIN(comment_count) AS min,
    COUNT(*) AS frequency
    FROM
        (SELECT 
        COUNT(*) AS comment_count
        FROM users u
        INNER JOIN user_comments uc ON u.id = uc.user_id
        WHERE uc.created_at > '2019-01-01' AND uc.created_at < '2019-12-31'
        GROUP BY u.id) AS comment_count_by_user
    ),

    histogram AS (
        SELECT 
        width_bucket(comment_count, min, max, frequency) as bucket,
        COUNT(*) AS freq
        FROM comments
        GROUP BY bucket
        ORDER BY bucket
    )

SELECT 
bucket,
freq,
REPEAT ('o', freq/MAX(freq) OVER () * 30)::int) AS Bar
FROM histogram














