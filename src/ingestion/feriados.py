import pandas as pd
from datetime import date,timedelta
from modules.calendario_request import feriados_request

data_hoje = date.today().replace(day=1)-timedelta(days=1)
ano_fim = str(data_hoje.year)
ano_inicio = '2000'

calendario = pd.date_range(
    start=f"{ano_inicio}-01-01",
    end=data_hoje,
    freq="D"
)

calendario = pd.DataFrame({"data": calendario})

calendario["ano"] = calendario["data"].dt.year


lista_dados = calendario['ano'].unique().tolist()

feriados_request(lista_dados,ano_inicio,ano_fim)

