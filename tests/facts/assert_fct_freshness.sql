-- tests/facts/assert_fct_freshness.sql

with freshness_check as (
    select
        table_name
        last_update_time,  -- Reference session_end_time
        now_time,
        freshness_status,
        hours_since_last_update
    from {{ ref('fct_freshness') }}
)

select *
from freshness_check
where hours_since_last_update > 24
