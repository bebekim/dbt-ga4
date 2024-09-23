{{ config(
    materialized='view',
    tags=['daily']
) }}

with events as (
    select * from {{ ref('stg_ga4__events') }}
),

final as (
    select
        event_id,
        CAST(event_timestamp AS TIMESTAMP) as event_timestamp,
        device_category,
        device_mobile_brand_name,
        device_mobile_model_name,
        device_mobile_marketing_name,
        CAST(device_mobile_os_hardware_model AS INT64) as device_mobile_os_hardware_model,
        device_operating_system,
        device_operating_system_version
    from events
)

select * from final