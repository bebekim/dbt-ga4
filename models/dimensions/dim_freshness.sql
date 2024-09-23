WITH dim_freshness AS (
    -- Check freshness of dim_devices
    SELECT 
        'dim_devices' AS table_name,
        MAX(event_timestamp) AS last_update_timestamp,
        CURRENT_TIMESTAMP() AS current_timestamp
    FROM {{ ref('dim_devices') }}
    UNION ALL
    -- Check freshness of dim_locations
    SELECT 
        'dim_locations' AS table_name,
        MAX(event_timestamp) AS last_update_timestamp,
        CURRENT_TIMESTAMP() AS current_timestamp
    FROM {{ ref('dim_locations') }}
    UNION ALL
    -- Check freshness of dim_traffic_sources
    SELECT 
        'dim_traffic_sources' AS table_name,
        MAX(event_timestamp) AS last_update_timestamp,
        CURRENT_TIMESTAMP() AS current_timestamp
    FROM {{ ref('dim_traffic_sources') }}
)

SELECT
    table_name,
    CAST(last_update_timestamp AS DATETIME) AS last_update_timestamp,  -- Cast as DATETIME, keep original name
    CAST(current_timestamp AS DATETIME) AS current_timestamp,          -- Cast as DATETIME, keep original name
    CASE 
        WHEN DATETIME_DIFF(CAST(current_timestamp AS DATETIME), CAST(last_update_timestamp AS DATETIME), HOUR) > 24 THEN 'Stale' 
        ELSE 'Fresh' 
    END AS freshness_status,
    DATETIME_DIFF(CAST(current_timestamp AS DATETIME), CAST(last_update_timestamp AS DATETIME), HOUR) AS hours_since_last_update  -- Adjusted to use correct column name
FROM dim_freshness
