WITH freshness_check AS (
    SELECT 
        table_name,
        last_update_timestamp,
        CURRENT_TIMESTAMP() AS current_timestamp,
        DATETIME_DIFF(CAST(CURRENT_TIMESTAMP() AS DATETIME), CAST(last_update_timestamp AS DATETIME), HOUR) AS hours_since_last_update
    FROM {{ ref('dim_freshness') }}
)

SELECT *
FROM freshness_check
WHERE hours_since_last_update > 24
