{{config(materialized = 'table')}}

WITH features_completas AS (
    SELECT
        *
    FROM {{source('intermediate','int_features_completas')}}
),

tempo AS (
    SELECT
        *
    FROM {{source('marts', 'dim_tempo')}}
),

join_tables AS (
    SELECT
        fc.id_regiao,
        fc.sigla_regiao,
        fc.nome_regiao,
        t.*,
        fc.carga_mensal_mwmed,
        fc.regime_metodologico,
        fc.carga_por_dia_util,
        fc.lag_carga_mensal_1,
        fc.lag_carga_mensal_3,
        fc.lag_carga_mensal_12,
        fc.media_movel_carga_mensal_3,
        fc.media_movel_carga_mensal_12,
        fc.variacao_mensal,
        fc.variacao_anual,
        fc.variacao_percentual_mensal,
        fc.variacao_percentual_anual,
        fc.temperatura_media_mensal,
        fc.temperatura_max_media,
        fc.temperatura_min_media,
        fc.prec_acum_mensal
    FROM features_completas fc
    LEFT JOIN tempo t
    ON fc.ano_mes = t.ano_mes
)

SELECT
    *
FROM join_tables