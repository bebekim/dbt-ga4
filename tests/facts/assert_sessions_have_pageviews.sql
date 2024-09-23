-- tests/facts/assert_sessions_have_pageviews.sql
SELECT 
    session_id,
    page_views
FROM {{  ref('fct_sessions') }}
WHERE page_views = 0