{{config(materialized = 'table')}}

WITH features_completas AS (
    SELECT
        *
    FROM {{source('intermediate','int_features_completas')}}
)

SELECT
    *
FROM features_completas