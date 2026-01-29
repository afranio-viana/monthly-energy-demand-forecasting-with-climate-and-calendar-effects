{{config(materialized = 'table')}}

WITH calendario_mensal AS (
    SELECT * FROM {{source('intermediate','int_calendario_mensal')}}
),

data_plus AS (
    SELECT
        ano_mes,
        ano::int AS ano,
        mes::int AS mes,
        CASE mes::int
            WHEN 1 THEN 'Janeiro'
            WHEN 2 THEN 'Fevereiro'
            WHEN 3 THEN 'Março'
            WHEN 4 THEN 'Abril'
            WHEN 5 THEN 'Maio'
            WHEN 6 THEN 'Junho'
            WHEN 7 THEN 'Julho'
            WHEN 8 THEN 'Agosto'
            WHEN 9 THEN 'Setembro'
            WHEN 10 THEN 'Outubro'
            WHEN 11 THEN 'Novembro'
            WHEN 12 THEN 'Dezembro'
        END AS nome_mes,
        CEIL(mes::int/3.0) AS trimestre,
        dias_no_mes,
        dias_uteis,
        (dias_uteis::float / dias_no_mes) as percentual_dias_uteis,
        fins_de_semana,
        feriado,
        CASE WHEN ano::int = 2020 THEN 1 ELSE 0 END AS flag_pandemia,
        CASE WHEN ano::int <= 2023 THEN 1 ELSE 0 END AS flag_treino,
        CASE WHEN ano::int >= 2024 THEN 1 ELSE 0 END AS flag_teste,
        sin(2 * pi() * mes::int / 12.0)::float AS int_sin,
        cos(2 * pi() * mes::int / 12.0) AS mes_cos

    FROM calendario_mensal
)

SELECT
    *
FROM data_plus