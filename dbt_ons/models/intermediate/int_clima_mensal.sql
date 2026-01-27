{{config(materialized = 'view')}}

WITH temperatura_media AS (
    SELECT * FROM {{source('staging','stg_temperatura_media')}}
),

avg_temp_max AS (
    SELECT * FROM {{source('staging','stg_media_temperatura_maxima_diaria')}}
),

avg_temp_min AS (
    SELECT * FROM {{source('staging','stg_media_temperatura_minima_diaria')}}
),

prec_men_acum AS (
    SELECT * FROM {{source('staging','stg_precipitacao_mensal_acumulada')}}
),

join_tables AS (
    SELECT
    tm.nome_regiao,
    tm.ano,
    tm.mes,
    CONCAT(tm.ano,'-',tm.mes) AS ano_mes,
    tm.temperatura_media_mensal,
    atm.media_temperatura_max_diaria AS temperatura_max_media,
    atmin.media_temperatura_min_diaria AS temperatura_min_media,
    pma.prec_acum_mensal
    FROM temperatura_media tm
    INNER JOIN avg_temp_max atm
    ON tm.nome_regiao = atm.nome_regiao AND tm.ano = atm.ano AND tm.mes = atm.mes
    INNER JOIN avg_temp_min atmin
    ON tm.nome_regiao = atmin.nome_regiao AND tm.ano = atmin.ano AND tm.mes = atmin.mes
    INNER JOIN prec_men_acum pma
    ON tm.nome_regiao = pma.nome_regiao AND tm.ano = pma.ano AND tm.mes = pma.mes
)

SELECT
    *
FROM join_tables
ORDER BY nome_regiao,ano_mes