import pandas as pd
import requests
from io import StringIO
import json

def feriados_request(lista_dados,ano_inicio,ano_fim):
    iterador = 0
    arquivo = f'feriados_{ano_inicio}_{ano_fim}.parquet'
    for ano in lista_dados:
        response = requests.get(f'https://brasilapi.com.br/api/feriados/v1/{ano}').json()
        data_param = pd.DataFrame(response)
        if iterador ==0:
            print(f"Arquivo {arquivo} Criado")
        else:
            data_antigo = pd.read_parquet(f'data/raw/feriados/{arquivo}',index=False)
            data_param = pd.concat([data_antigo, data_param], ignore_index=True)
            print(f"Dados de {ano} adicionados ao arquivo {arquivo}")
        data_param.to_parquet(f'data/raw/feriados/{arquivo}',index=False)
        iterador +=1    



def fim_de_semana(ano_inicio,data_hoje):
    calendario = pd.date_range(
        start=f"{ano_inicio}-01-01",
        end=data_hoje,
        freq="D"
    )

    calendario = pd.DataFrame({"data": calendario})

    calendario["dia_semana"] = calendario["data"].dt.weekday
    calendario["ano"] = calendario["data"].dt.year
    calendario["fim_de_semana"] = calendario["dia_semana"].isin([5, 6])
    return calendario



def dias_uteis(calendario,ano_inicio,ano_fim):
    arquivo = f'dias_uteis_{ano_inicio}_{ano_fim}.parquet'
    feriados = pd.read_parquet(f'data/raw/feriados/feriados_{ano_inicio}_{ano_fim}.parquet')
    feriados_list = pd.to_datetime(feriados['date']).unique().tolist()

    calendario["feriado"] = calendario["data"].isin(feriados_list)

    calendario["dia_util"] = ~((calendario["feriado"]) | (calendario["fim_de_semana"]))
    calendario.to_parquet(f'data/raw/dias_uteis/{arquivo}')
    print(f'Arquivo {arquivo} criado')