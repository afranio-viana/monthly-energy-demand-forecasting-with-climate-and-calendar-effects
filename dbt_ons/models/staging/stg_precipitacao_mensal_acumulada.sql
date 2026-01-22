{{config(materialized='view')}}

WITH raw_table AS (
    SELECT * FROM {{source('raw','prectotcorr_sum_2000_2025')}}
),

unpivot AS (
    SELECT
        REGEXP_REPLACE(TRIM(UPPER("REGIAO")),'\s+',' ','g') AS nome_regiao,
        key AS mes,
        value AS prec_acum,
        t.*
    FROM (
        SELECT
            *,
            TO_JSONB(raw_table) AS jb
        FROM raw_table
    ) t
    CROSS JOIN LATERAL (
        SELECT * FROM JSONB_EACH_TEXT(t.jb - 'REGIAO' - 'YEAR' - 'ANN' - 'PARAMETER')
    ) AS j (key, value)
),

clean AS (
    SELECT
        REGEXP_REPLACE(TRIM(UPPER("REGIAO")),'\s+','-','g') AS nome_regiao,
        "YEAR"::text AS ano,
        CASE UPPER(mes)
            WHEN 'JAN' THEN '01'
            WHEN 'FEB' THEN '02'
            WHEN 'MAR' THEN '03'
            WHEN 'APR' THEN '04'
            WHEN 'MAY' THEN '05'
            WHEN 'JUN' THEN '06'
            WHEN 'JUL' THEN '07'
            WHEN 'AUG' THEN '08'
            WHEN 'SEP' THEN '09'
            WHEN 'OCT' THEN '10'
            WHEN 'NOV' THEN '11'
            WHEN 'DEC' THEN '12'
        END AS mes,
        COALESCE(prec_acum,'0.0')::float AS prec_acum_mensal
    FROM unpivot
    ORDER BY nome_regiao,ano,mes
)

SELECT
    *
FROM clean