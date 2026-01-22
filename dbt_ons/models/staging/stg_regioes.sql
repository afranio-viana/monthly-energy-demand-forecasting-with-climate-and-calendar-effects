{{config(materialized='view')}}

WITH raw_table AS(
    SELECT * FROM {{source('raw','regioes')}}
),

clean AS (
    SELECT
        id::text AS id_regiao,
        REGEXP_REPLACE(TRIM(UPPER(sigla)),'\s+',' ','g') AS sigla_regiao,
        REGEXP_REPLACE(TRIM(UPPER(nome)),'\s+',' ','g') AS nome_regiao
    FROM raw_table

)

SELECT
    *
FROM clean