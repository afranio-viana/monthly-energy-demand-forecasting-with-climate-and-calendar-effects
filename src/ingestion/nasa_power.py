import pandas as pd
from datetime import date
from modules.nasa_power_request import nasa_power_mensal
from dateutil.relativedelta import relativedelta

regioes_pd = pd.read_parquet('data/raw/geobr/lat_long_regioes_br.parquet')

data_hoje = date.today()-relativedelta(months=1)
ano_fim = str(data_hoje.year)

nasa_power_mensal(regioes_pd,'2000',ano_fim)