{{config(materialized = 'view')}}

WITH granularidade_mensal AS (
    SELECT * FROM {{source('staging','stg_granularidade_mensal')}}
),

regioes AS (
    SELECT * FROM {{source('staging','stg_regioes')}}
),

join_tables AS (
    SELECT
    re.id_regiao,
    re.sigla_regiao,
    re.nome_regiao,
    CONCAT(gm.ano,'-',gm.mes) AS ano_mes,
    gm.ano,
    gm.mes,
    gm.carga_referencia AS carga_mensal_mwmed,
    CASE
        WHEN gm.data_referencia::date < date '2015-01-01' THEN 'ONS_DESPACHADA'
        WHEN gm.data_referencia::date >= date '2015-01-01' AND
        gm.data_referencia::date < date '2023-04-29' THEN 'ONS_DESPACHADA_E_NAO_DESPACHADA'
        WHEN gm.data_referencia::date >= date '2023-04-29' THEN 'ONS_COM_MMGD'
    END AS regime_metodologico
    FROM granularidade_mensal gm
    INNER JOIN regioes re
    ON gm.sigla_regiao = re.sigla_regiao
)

SELECT
    *
FROM join_tables
ORDER BY id_regiao,ano_mes