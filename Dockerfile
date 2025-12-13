FROM python:3.9-slim

WORKDIR /app

# Копируем файлы приложения
COPY app/main.py .

# Команда для запуска приложения
CMD ["python", "main.py"]