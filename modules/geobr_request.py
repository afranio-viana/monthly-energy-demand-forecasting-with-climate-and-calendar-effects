import geobr
import geopandas as gpd
import pandas as pd

def geobr_request(arquivo):
    try:
        regioes = geobr.read_region()
        regioes = regioes.to_crs(epsg=5880)
        regioes['centroid'] = regioes.geometry.centroid
        regioes_br_centroid = regioes.set_geometry("centroid").to_crs(epsg=4326)
        regioes_br_centroid['latitude'] = regioes_br_centroid.geometry.y
        regioes_br_centroid['longitude'] = regioes_br_centroid.geometry.x

        regioes_br_coordenadas = regioes_br_centroid[['code_region','name_region','latitude','longitude']]

        regioes_br_coordenadas.to_parquet(f'data/raw/geobr/{arquivo}',index=False)
        print(f'\n\nArquivo {arquivo} criado.\n\n')
    except:
        print("Deu erro")
