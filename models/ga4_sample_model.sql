{{ config(materialized='table') }}

SELECT 
  event_date, 
  event_name,
  COUNT(*) as event_count
FROM {{ var('ga4_dataset') }}.events_20210131
GROUP BY 1, 2
LIMIT 1000