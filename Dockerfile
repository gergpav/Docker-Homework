FROM python:3.9-slim

WORKDIR /app

# Копируем файлы приложения
COPY app/main.py .
COPY text.txt .

# Команда для запуска приложения
CMD ["python", "main.py"]