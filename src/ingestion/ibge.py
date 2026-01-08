from modules.ibge_request import regioes_request
import pandas as pd

url = f'https://servicodados.ibge.gov.br/api/v1/localidades/regioes'
arquivo = 'regioes.parquet'

regioes_request(url,arquivo)