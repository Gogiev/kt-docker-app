# ---- Этап сборки ----
FROM python:3.12-slim AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

# ---- Финальный этап ----
FROM python:3.12-slim
WORKDIR /app

# Копируем установленные зависимости из этапа сборки
COPY --from=builder /root/.local /root/.local
ENV PATH=/root/.local/bin:$PATH

# Копируем код приложения
COPY . .

# Создаем непривилегированного пользователя
RUN useradd -m -u 1000 appuser && chown -R appuser:appuser /app
USER appuser

# Открываем порт
EXPOSE 8000

# Команда запуска с CMD из задания
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]