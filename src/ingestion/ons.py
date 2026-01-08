from modules.ons_request import ons_request
import pandas as pd


url= "https://ons-aws-prod-opendata.s3.amazonaws.com/dataset/carga_energia_me/CARGA_MENSAL.parquet"
arquivo = 'granularidade_mensal.parquet'

ons_request(url,arquivo)
