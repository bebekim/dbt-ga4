-- models/dim_freshness.sql
WITH dim_freshness AS (
    -- Check freshness of dim_devices
    SELECT 
        'dim_devices' AS table_name,
        MAX(event_timestamp) AS last_update_time,
        CURRENT_TIMESTAMP() AS current_time
    FROM {{ ref('dim_devices') }}
    UNION ALL
    -- Check freshness of dim_locations
    SELECT 
        'dim_locations' AS table_name,
        MAX(event_timestamp) AS last_update_time,
        CURRENT_TIMESTAMP() AS current_time
    FROM {{ ref('dim_locations') }}
    UNION ALL
    -- Check freshness of dim_traffic_sources
    SELECT 
        'dim_traffic_sources' AS table_name,
        MAX(event_timestamp) AS last_update_time,
        CURRENT_TIMESTAMP() AS current_time
    FROM {{ ref('dim_traffic_sources') }}
)

SELECT
    table_name,
    last_update_time,
    current_time,
    CASE 
        WHEN TIMESTAMP_DIFF(current_time, last_update_time, HOUR) > 24 THEN 'Stale' 
        ELSE 'Fresh' 
    END AS freshness_status,
    TIMESTAMP_DIFF(current_time, last_update_time, HOUR) AS hours_since_last_update
FROM dim_freshness
