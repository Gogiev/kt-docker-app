from fastapi import FastAPI
from .database import engine, Base
import asyncio

app = FastAPI(title="KT Docker App")

@app.on_event("startup")
async def startup():
    # Создаем таблицы при старте (для простоты)
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)

@app.get("/")
def read_root():
    return {"message": "Hello, World! App is working."}

@app.get("/health")
async def health_check():
    # Проверка, что приложение живо
    return {"status": "ok"}