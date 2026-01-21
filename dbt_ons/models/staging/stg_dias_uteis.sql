{{config(materialized='view')}}

WITH raw_table AS (
    SELECT * FROM {{source('raw','dias_uteis_2000_2025')}}
),

clean AS (
    SELECT
        TO_CHAR(data,'YYYY-MM-DD') AS data,
        ano::text AS ano,
        TO_CHAR(data,'MM') AS mes,
        TO_CHAR(data,'DD') AS dia,
        CASE
            WHEN fim_de_semana = 't' THEN 1
            ELSE 0
        END AS fim_semana,
        CASE
            WHEN feriado = 't' THEN 1
            ELSE 0
        END AS dia_feriado,
        CASE
            WHEN dia_util = 't' THEN 1
            ELSE 0
        END AS dia_util,
        dia_semana
    FROM raw_table
)

SELECT
    *
FROM clean
