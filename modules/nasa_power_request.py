import requests
import pandas as pd
from io import StringIO

def nasa_power_mensal(regioes_pd,inicio,fim):
    iterador = 0
    try:
        for _,regiao in regioes_pd.iterrows():
            response = requests.get(f'https://power.larc.nasa.gov/api/temporal/monthly/point?start={inicio}&end={fim}&latitude={regiao['latitude']}&longitude={regiao['longitude']}&community=sb&parameters=T2M_MAX_AVG%2CT2M_MIN_AVG%2CT2M%2CPRECTOTCORR_SUM&format=csv&units=metric&header=false')
            data = pd.read_csv(StringIO(response.text))
            data['REGIAO'] = regiao['name_region']
            lista_dados = data['PARAMETER'].unique().tolist()
            for parametro in lista_dados:
                arquivo = f'{parametro}_{inicio}_{fim}.parquet'
                data_param = data[data['PARAMETER']==parametro]
                if iterador == 0:
                    print(f"Arquivo {arquivo} Criado")
                else:
                    data_antigo = pd.read_parquet(f'data/raw/nasa_power/{arquivo}',index=False)
                    data_param = pd.concat([data_antigo, data_param], ignore_index=True)
                print(f"Dados da região {regiao["name_region"]} adicionados ao arquivo {arquivo}")
                data_param.to_parquet(f'data/raw/nasa_power/{arquivo}',index=False)
            iterador +=1
    except requests.exceptions.RequestException as e:
        print(f'Ocorreu um erro: {e}')