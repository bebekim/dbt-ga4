with events as (
    select * from {{ source('ga4', 'events') }}
),

final as (
    select 
        TO_HEX(MD5(CONCAT(CAST(event_timestamp AS STRING), event_name, user_pseudo_id))) AS event_id,
        ep.key AS param_key,
        ep.value.string_value,
        ep.value.int_value,
        ep.value.float_value,
        ep.value.double_value
    from events,
    UNNEST(event_params) AS ep
)

select * from final