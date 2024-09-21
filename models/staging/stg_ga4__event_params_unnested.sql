with events as (
    select * from {{ source('ga4', 'events') }}
),

final as (
    select 
        TO_HEX(MD5(CONCAT(CAST(event_timestamp AS STRING), event_name, user_pseudo_id))) AS event_id,
        ep.key AS param_key,
        ep.value.string_value AS param_value_string,
        ep.value.int_value AS param_value_int,
        ep.value.float_value AS param_value_float,
        ep.value.double_value AS param_value_double
    from events,
    UNNEST(event_params) AS ep
)

select * from final