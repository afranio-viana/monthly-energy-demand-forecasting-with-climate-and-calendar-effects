{{config(materialized = 'view')}}

WITH carga_mensal AS (
    SELECT * FROM {{source('intermediate','int_carga_mensal')}}
),

calendario_mensal AS (
    SELECT * FROM {{source('intermediate','int_calendario_mensal')}}
),

join_tables AS (
    SELECT
    car_m.id_regiao,
    car_m.sigla_regiao,
    car_m.nome_regiao,
    car_m.ano_mes,
    car_m.ano,
    car_m.mes,
    car_m.carga_mensal_mwmed,
    car_m.regime_metodologico,
    cal_m.dias_no_mes,
    cal_m.dias_uteis,
    cal_m.fins_de_semana,
    cal_m.feriado,
    (car_m.carga_mensal_mwmed/cal_m.dias_uteis) AS carga_por_dia_util,
    (cal_m.dias_uteis::float/cal_m.dias_no_mes) AS percentual_dias_uteis
    FROM carga_mensal car_m
    INNER JOIN calendario_mensal cal_m
    ON car_m.ano_mes = cal_m.ano_mes
)

SELECT
    *
FROM join_tables