{{ config(
    materialized='view',
    tags=['daily']
) }}

with events as (
    select * from {{ ref('stg_ga4__events') }}
),

categorized_sources as (
    select
        event_id,
        case
            when traffic_source.medium = '(none)' and traffic_source.name = '(direct)' then 'direct'
            when traffic_source.medium = 'organic' and traffic_source.name = '(organic)' then 'organic_search'
            when traffic_source.medium = 'referral' then 'referral'
            when traffic_source.medium = 'cpc' then 'paid_search'
            when traffic_source.medium in ('(data deleted)', '<Other>') or traffic_source.name in ('(data deleted)', '<Other>') then 'uncategorized'
            else 'other'
        end as traffic_category,
        coalesce(
            case
                when traffic_source.medium in ('(data deleted)', '<Other>') then 'unknown_medium'
                else traffic_source.medium
            end,
            'unknown_medium'
        ) as cleaned_medium,
        coalesce(
            case
                when traffic_source.name in ('(data deleted)', '<Other>') then 'unknown_source'
                else traffic_source.name
            end,
            'unknown_source'
        ) as cleaned_name,
        coalesce(
            case
                when traffic_source.source in ('(data deleted)', '<Other>') then 'unknown_source'
                else traffic_source.source
            end,
            'unknown_source'
        ) as cleaned_source
    from events
)

select
    event_id,
    traffic_category,
    cleaned_medium as traffic_source_medium,
    cleaned_name as traffic_source_name,
    cleaned_source as traffic_source
from categorized_sources