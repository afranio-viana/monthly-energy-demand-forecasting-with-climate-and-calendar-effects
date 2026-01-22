{{config(materialized='view')}}

WITH raw_table AS (
    SELECT * FROM {{source('raw','granularidade_mensal')}}
),

clean AS (
    SELECT
        REGEXP_REPLACE(TRIM(UPPER(id_subsistema)),'\s+',' ','g') AS sigla_regiao,
        REGEXP_REPLACE(TRIM(UPPER(nom_subsistema)),'\s+',' ','g') AS nome_subsistema,
        TO_CHAR(din_instante,'YYYY-MM-DD') AS data_referencia,
        val_cargaenergiamwmed AS carga_referencia
    FROM raw_table
)


SELECT
    *
FROM clean