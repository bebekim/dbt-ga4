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
        event_timestamp,
        geo.continent as continent,
        geo.sub_continent as sub_continent,
        geo.country as country,
        geo.region as region,
        geo.city as city,
        geo.metro as metro
    from events
)

select * from final