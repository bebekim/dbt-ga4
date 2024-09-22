-- tests/facts/assert_unique_session_ids.sql
SELECT 
    session_id,
    COUNT(*) as cnt_sessions
FROM {{  ref('fct_sessions')  }}
GROUP BY session_id
HAVING cnt_sessions > 1