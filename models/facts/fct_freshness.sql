with fact_freshness as (
    -- check freshness of fct_sessions
    select 
        'fct_sessions' as table_name,
        session_end_time as last_update_time,  -- cast last_update_time to timestamp explicitly
        current_timestamp() as now_time                            -- use current_timestamp() as timestamp
    from {{ ref('fct_sessions') }}                                     -- reference the fct_sessions model
),

final as (
    select
        table_name,
        last_update_time,
        now_time,
        case 
            when timestamp_diff(now_time, last_update_time, hour) > 24 then 'Stale'  -- if more than 24 hours
            else 'Fresh'                                                           -- otherwise, fresh
        end as freshness_status,
        timestamp_diff(now_time, last_update_time, hour) as hours_since_last_update
    from fact_freshness
)

select * from final
