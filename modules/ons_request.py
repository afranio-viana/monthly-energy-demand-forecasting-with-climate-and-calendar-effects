import requests
import pandas as pd
from io import BytesIO

def ons_request(url,arquivo):
    try:
        response = requests.get(f'{url}')
        data = pd.read_parquet(BytesIO(response.content))
        data.to_parquet(f'data/raw/ons/{arquivo}',index=False)
        print(f'\n\nArquivo {arquivo} criado.\n\n')
    except requests.exceptions.RequestException as e:
        print(f"Ocorreu ume erro: {e}")