SELECT 
    session_id,
    session_start_time,
    session_end_time
FROM {{ ref('fct_sessions') }}
WHERE session_start_time >= session_end_time
LIMIT 10