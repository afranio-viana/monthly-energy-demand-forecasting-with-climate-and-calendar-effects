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
    (LAG(temperatura_media_mensal,3) OVER (PARTITION BY ft.id_regiao ORDER BY ft.ano_mes)) AS lag_temperatura_media_mensal_3,
    (LAG(temperatura_media_mensal,12) OVER (PARTITION BY ft.id_regiao ORDER BY ft.ano_mes)) AS lag_temperatura_media_mensal_12,
    (AVG(temperatura_media_mensal) OVER (PARTITION BY ft.id_regiao ORDER BY ft.ano_mes ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)) AS media_movel_temperatura_media_mensal_3,
    (AVG(temperatura_media_mensal) OVER (PARTITION BY ft.id_regiao ORDER BY ft.ano_mes ROWS BETWEEN 11 PRECEDING AND CURRENT ROW)) AS media_movel_temperatura_media_mensal_12,
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
        (jc.temperatura_media_mensal-jc.lag_temperatura_media_mensal_1) AS diff_temperatura_media_1,
        (jc.temperatura_media_mensal-jc.lag_temperatura_media_mensal_3) AS diff_temperatura_media_3,
        (jc.temperatura_media_mensal-jc.lag_temperatura_media_mensal_12) AS diff_temperatura_media_12

    FROM join_columns jc
),

lags AS (
    SELECT
        vc.*,
        (LAG(vc.diff_temperatura_media_1,1) OVER (PARTITION BY vc.id_regiao ORDER BY vc.ano_mes)) AS lag_diff_variacao_mensal_temperatura_media_mensal_1
    FROM variacao vc
)


    
SELECT
    *
FROM lags