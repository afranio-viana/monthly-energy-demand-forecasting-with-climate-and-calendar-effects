{{config(materialized = 'view')}}

WITH features_temporais AS (
    SELECT * FROM {{source('intermediate','int_features_temporais')}}
),

clima_mensal AS (
    SELECT * FROM {{source('intermediate','int_clima_mensal')}}
),

join_columns AS (
    SELECT
    ft.*,
    cm.temperatura_media_mensal,
    cm.temperatura_max_media,
    cm.temperatura_min_media,
    cm.prec_acum_mensal
    FROM features_temporais ft
    LEFT JOIN clima_mensal cm
    ON ft.nome_regiao = cm.nome_regiao AND ft.ano_mes = cm.ano_mes AND ft.ano = cm.ano AND ft.mes = cm.mes
)

SELECT
    *
FROM join_columns