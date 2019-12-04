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