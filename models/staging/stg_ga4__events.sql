with events as (
    select * from {{ source('ga4', 'events') }}
),

final as (
    select 
        PARSE_DATE('%Y%m%d', event_date) AS event_date,
        TIMESTAMP_MICROS(event_timestamp) AS event_timestamp,
        event_name,
        TIMESTAMP_MICROS(event_previous_timestamp) AS event_previous_timestamp,
        event_value_in_usd,
        event_bundle_sequence_id,
        event_server_timestamp_offset,
        user_id,
        user_pseudo_id,
        privacy_info.analytics_storage,
        privacy_info.ads_storage,
        privacy_info.uses_transient_token,
        TIMESTAMP_MICROS(user_first_touch_timestamp) AS user_first_touch_timestamp,
        user_ltv.revenue AS user_ltv_revenue,
        user_ltv.currency AS user_ltv_currency,
        device.category AS device_category,
        device.mobile_brand_name AS device_mobile_brand_name,
        device.mobile_model_name AS device_mobile_model_name,
        device.mobile_marketing_name AS device_mobile_marketing_name,
        device.mobile_os_hardware_model AS device_mobile_os_hardware_model,
        device.operating_system AS device_operating_system,
        device.operating_system_version AS device_operating_system_version,
        geo,
        app_info,
        traffic_source,
        stream_id,
        platform,
        event_dimensions,
        ecommerce,
        items,
        TO_HEX(MD5(CONCAT(CAST(event_timestamp AS STRING), event_name, user_pseudo_id))) AS event_id
    from events
)

select * from final