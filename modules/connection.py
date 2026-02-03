from dotenv import load_dotenv
from sqlalchemy import create_engine, text
import pandas as pd
import os


def get_engine():
    load_dotenv()
    database_password = os.getenv("DB_PASSWORD")
    database_name = os.getenv("DB_NAME")
    database_port = os.getenv("DB_PORT")
    database_host = os.getenv("DB_HOST")
    database_user = os.getenv("DB_USER")
    engine = db_connection(database_password,database_name,database_port,database_host,database_user)
    return engine


def db_connection(key,name,port,host,user):
    engine = create_engine(f'postgresql://postgres:{key}@{host}:{port}/{name}')
    try:
        with engine.connect() as connection:
            result = connection.execute(text("SELECT 1"))
            print(f'Conectado ao DB {name}')
            return engine
    except Exception as e:
        print(f'Erro {e}')

def create_schema(engine,schema):
    try:
        with engine.connect() as conn:
            conn.execute(text(f'CREATE SCHEMA IF NOT EXISTS {schema};'))
            conn.commit()
            print(f'O esquema {schema} foi criado')
    except Exception as e:
        print(f'Erro: {e}')

def save_dt(engine,schema,table,path):
    try:
        with engine.connect() as conn:
            query = f'SELECT * FROM {schema}.{table};'
            df = pd.read_sql(query,engine)
            df.to_parquet(f'{path}/{table}.parquet',index=False)
            print(f'O arquivo {table}.parquet foi criado.')
    except Exception as e:
        print(f'Erro: {e}')