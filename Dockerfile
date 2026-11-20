# ---- Этап сборки ----
FROM python:3.12-slim AS builder
WORKDIR /app
COPY requirements.txt .
# Устанавливаем зависимости глобально, без --user
RUN pip install --no-cache-dir -r requirements.txt

# ---- Финальный этап ----
FROM python:3.12-slim
WORKDIR /app

# Копируем установленные пакеты из системной директории первого этапа
COPY --from=builder /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin

# Копируем код приложения
COPY . .

# Создаем пользователя и даем ему права на рабочую директорию
RUN useradd -m -u 1000 appuser && chown -R appuser:appuser /app
USER appuser

# Открываем порт
EXPOSE 8000

# Команда запуска
CMD ["sh", "-c", "uvicorn app.main:app --host 0.0.0.0 --port ${PORT:-8000}"]