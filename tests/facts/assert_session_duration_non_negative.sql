-- tests/facts/assert_session_duration_non_negative.sql
SELECT 
    session_id,
    session_duration_seconds
FROM {{  ref('fct_sessions')  }}
WHERE session_duration_seconds < 0