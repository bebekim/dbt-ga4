-- Investigate geo structure in stg_ga4__events
WITH sample_events AS (
  SELECT *
  FROM {{ ref('stg_ga4__events') }}
  LIMIT 1000  -- Adjust this number as needed
)

SELECT
  -- Check if geo is a STRUCT
  IF(geo IS NOT NULL, 'STRUCT', 'NOT_STRUCT') AS geo_type,
  
  -- Try to access potential geo fields
  geo.country AS geo_country,
  geo.region AS geo_region,
  geo.city AS geo_city,
  geo.sub_continent AS geo_sub_continent,
  geo.metro AS geo_metro,
  
  -- In case geo is not a STRUCT, check for flat column names
  country,
  region,
  city,
  sub_continent,
  metro,
  
  -- Count of non-null values for each potential geo field
  COUNT(geo.country) AS geo_country_count,
  COUNT(geo.region) AS geo_region_count,
  COUNT(geo.city) AS geo_city_count,
  COUNT(geo.sub_continent) AS geo_sub_continent_count,
  COUNT(geo.metro) AS geo_metro_count,
  
  COUNT(country) AS flat_country_count,
  COUNT(region) AS flat_region_count,
  COUNT(city) AS flat_city_count,
  COUNT(sub_continent) AS flat_sub_continent_count,
  COUNT(metro) AS flat_metro_count

FROM sample_events
GROUP BY 1,2,3,4,5,6,7,8,9,10,11