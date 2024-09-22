with events as (
    select * from {{  ref('stg_ga4__events')  }}
),

event_params_unnested as (
    select * from {{  ref('stg_ga4__event_params_unnested') }}
),

final as (
    select 
        e.event_id,
        e.event_date,
        e.event_timestamp,
        e.event_name,
        epn.param_key,
        COALESCE(
            CAST(epn.param_value_int AS STRING),
            epn.param_value_string,
            CAST(epn.param_value_float AS STRING),
            CAST(epn.param_value_double AS STRING)
        ) as param_value
    from {{  ref('stg_ga4__events')  }} e
    left join {{  ref('stg_ga4__event_params_unnested')  }} epn
    on e.event_id = epn.event_id
)

select * from final