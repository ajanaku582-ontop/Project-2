from fastapi import FastAPI
import psycopg2
import os

app = FastAPI()

DB_HOST = os.getenv("DB_HOST")

@app.get("/")
def read_root():
    return {"message": "FastAPI running securely"}

@app.get("/db")
def db_check():
    conn = psycopg2.connect(
        host=DB_HOST,
        database="appdb",
        user="dbadmin",
        password=os.getenv("DB_PASSWORD")
    )
    cur = conn.cursor()
    cur.execute("SELECT version();")
    result = cur.fetchone()
    return {"db_version": result}
