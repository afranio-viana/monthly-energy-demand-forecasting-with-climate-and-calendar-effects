{{config(materialized = "view")}}

WITH dias_uteis AS (
    SELECT * FROM {{source('staging','stg_dias_uteis')}}
),

clean AS (
    SELECT
        ano,
        mes,
        CONCAT(ano,'-',mes) AS ano_mes,
        COUNT(*) AS dias_no_mes,
        SUM(dia_util) AS dias_uteis,
        SUM(fim_semana) AS fins_de_semana,
        SUM(dia_feriado) AS feriado
    FROM dias_uteis
    GROUP BY ano_mes, ano,mes
)

SELECT
    *
FROM clean
ORDER BY ano_mes