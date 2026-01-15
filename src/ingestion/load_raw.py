from modules.connection import get_engine, create_schema
from modules.load_file import load_parquet_postgres
import os
import pandas as pd

schema = 'raw'
dir_raw = 'data/raw'
engine = get_engine()

create_schema(engine,schema)

for source_dir in os.listdir(dir_raw):
    dir_path = os.path.join(dir_raw,source_dir)
    for files in os.listdir(dir_path):
        if files.endswith(".parquet"):
            name_table = files.split(".")[0]
            name_table = name_table.lower()
            file_path = os.path.join(dir_path,files)
            load_parquet_postgres(file_path,name_table,engine,schema)