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
    (LAG(temperatura_media_mensal,1) OVER (PARTITION BY ft.id_regiao ORDER BY ft.ano_mes)) AS lag_temperatura_media_mensal_1,
    cm.temperatura_media_mensal,
    cm.temperatura_max_media,
    cm.temperatura_min_media,
    cm.prec_acum_mensal
    FROM features_temporais ft
    LEFT JOIN clima_mensal cm
    ON ft.nome_regiao = cm.nome_regiao AND ft.ano_mes = cm.ano_mes AND ft.ano = cm.ano AND ft.mes = cm.mes
),

variacao AS (
    SELECT
        jc.*,
        (jc.temperatura_media_mensal-jc.lag_temperatura_media_mensal_1) AS variacao_mensal_temperatura_media_mensal
    FROM join_columns jc
),

lags AS (
    SELECT
        vc.*,
        (LAG(vc.variacao_mensal_temperatura_media_mensal,1) OVER (PARTITION BY vc.id_regiao ORDER BY vc.ano_mes)) AS lag_diff_variacao_mensal_temperatura_media_mensal_1
    FROM variacao vc
)


    
SELECT
    *
FROM lags