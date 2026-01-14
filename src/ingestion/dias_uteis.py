import pandas as pd
from datetime import date,timedelta
from modules.calendario_request import fim_de_semana,dias_uteis

data_hoje = date.today().replace(day=1)-timedelta(days=1)
ano_fim = str(data_hoje.year)
ano_inicio = '2000'

calendario = fim_de_semana(ano_inicio,data_hoje)

dias_uteis(calendario,ano_inicio,ano_fim)



