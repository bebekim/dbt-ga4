with events as (
    select * from {{ ref('stg_ga4__events') }}
),

event_params_unnested as (
    select * from {{ ref('stg_ga4__event_params_unnested') }}
),

session_ids as (
    select distinct 
        event_id, 
        param_value_int as session_id
    from event_params_unnested
    where param_key = 'ga_session_id'
),

event_data as (
    select 
        e.event_id,
        e.event_date,
        e.event_timestamp,
        e.event_name,
        s.session_id
    from events e
    inner join session_ids s 
        on e.event_id = s.event_id
),

session_level_data as (
    select 
        session_id,
        min(event_date) as session_date,
        max(case when event_name = 'session_start' then 1 else 0 end) as session_start,
        max(case when event_name = 'first_visit' then 1 else 0 end) as first_visit,
        sum(case when event_name = 'page_view' then 1 else 0 end) as page_views,
        sum(case when event_name = 'view_search_results' then 1 else 0 end) as searches,
        min(event_timestamp) as session_start_time,
        max(event_timestamp) as session_end_time
    from event_data
    group by session_id
),

final as (
    select 
        session_id,
        session_date,
        session_start,
        first_visit,
        page_views,
        searches,
        session_start_time,
        session_end_time,
        timestamp_diff(session_end_time, session_start_time, second) as session_duration_seconds
    from session_level_data
)

select * from final