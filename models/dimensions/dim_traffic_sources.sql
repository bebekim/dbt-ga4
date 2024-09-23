{{ config(
    materialized='view',
    tags=['daily']
) }}

with events as (
    select * from {{ ref('stg_ga4__events') }}
),

final as (
    select distinct
        event_id,
        traffic_source.medium as traffic_source_medium,
        traffic_source.name as traffic_source_name,
        traffic_source.source as traffic_source,
    from events
)

select * from final