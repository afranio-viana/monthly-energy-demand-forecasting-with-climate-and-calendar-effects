from modules.connection import get_engine,save_dt
import pandas as pd

engine = get_engine()
schema = 'marts'
tables = ['mart_eda','mart_features_ml']
path = 'data/marts'

for table in tables:
    save_dt(engine,schema,table,path)

