{{config(materialized = 'view')}}

WITH carga_calendario AS (
    SELECT * FROM {{source('intermediate','int_carga_calendario')}}
),


lags_columns AS (
    SELECT
        cc.*,
        (LAG(carga_mensal_mwmed,1) OVER (PARTITION BY id_regiao ORDER BY ano_mes)) AS lag_carga_mensal_1,
        (LAG(carga_mensal_mwmed,3) OVER (PARTITION BY id_regiao ORDER BY ano_mes)) AS lag_carga_mensal_3,
        (LAG(carga_mensal_mwmed,12) OVER (PARTITION BY id_regiao ORDER BY ano_mes)) AS lag_carga_mensal_12,
        (AVG(carga_mensal_mwmed) OVER (PARTITION BY id_regiao ORDER BY ano_mes ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)) AS media_movel_carga_mensal_3,
        (AVG(carga_mensal_mwmed) OVER (PARTITION BY id_regiao ORDER BY ano_mes ROWS BETWEEN 11 PRECEDING AND CURRENT ROW)) AS media_movel_carga_mensal_12
    FROM carga_calendario cc
),

variacao_columns AS (
    SELECT
        lc.*,
        (carga_mensal_mwmed-lag_carga_mensal_1) AS variacao_mensal,
        (carga_mensal_mwmed-lag_carga_mensal_12) AS variacao_anual,
        ((carga_mensal_mwmed-lag_carga_mensal_1)/lag_carga_mensal_1) AS variacao_percentual_mensal,
        ((carga_mensal_mwmed-lag_carga_mensal_12)/lag_carga_mensal_12) AS variacao_percentual_anual
    FROM lags_columns lc
),

lags AS (
    SELECT
        vc.*,
        (LAG(variacao_mensal,1) OVER (PARTITION BY id_regiao ORDER BY ano_mes)) AS lag_variacao_mensal_1
    FROM variacao_columns vc
)

SELECT
    *
FROM lags