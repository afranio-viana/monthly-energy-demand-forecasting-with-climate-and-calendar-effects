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
        tm.nome_regiao AS nome_regiao,
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
),

name_regioes AS (
    SELECT
        CASE
            WHEN nome_regiao = 'CENTRO-OESTE' THEN 'SUDESTE'
            WHEN nome_regiao <> 'CENTRO-OESTE' THEN nome_regiao
        END AS nome_duplicado,
        jt.*
    FROM join_tables jt
),

gpb_regioes AS (
    SELECT
        nome_duplicado AS nome_regiao,
        ano_mes,
        ano,
        mes,
        AVG(temperatura_media_mensal) AS temperatura_media_mensal,
        AVG(temperatura_max_media) AS temperatura_max_media,
        AVG(temperatura_min_media) AS temperatura_min_media,
        AVG(prec_acum_mensal) AS prec_acum_mensal
    FROM name_regioes
    GROUP BY nome_duplicado, ano_mes, ano, mes
)

SELECT
    *
FROM gpb_regioes
ORDER BY nome_regiao,ano_mes