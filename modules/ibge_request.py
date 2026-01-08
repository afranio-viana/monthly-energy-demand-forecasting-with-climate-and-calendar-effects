import requests
import pandas as pd
from io import StringIO
import json


def regioes_request(url,arquivo):
    try:
        response = requests.get(f'{url}').json()
        data = pd.DataFrame(response)
        data.to_parquet(f'data/raw/ibge/{arquivo}',index=False)
        print(f'\n\nArquivo {arquivo} criado.\n\n')
    except requests.exceptions.RequestException as e:
        print(f'Ocorreu um erro: {e}')