import pandas as pd

def load_parquet_postgres(file_path,name_table,engine,schema):
    try:
        parquet_df = pd.read_parquet(file_path)
        parquet_df.to_sql(name_table,engine,schema=schema,if_exists="replace",index=False)
        print(f"\nA tabela {name_table} foi criada e {len(parquet_df)} linhas foram inseridas")
    except Exception as e:
        print(f"Erro: {e}")
