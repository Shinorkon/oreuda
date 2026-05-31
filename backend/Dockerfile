FROM python:3.11-slim

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

COPY requirements.txt /app/requirements.txt
RUN apt-get update && apt-get install -y --no-install-recommends postgresql-client && rm -rf /var/lib/apt/lists/*
RUN pip install --no-cache-dir -r /app/requirements.txt

COPY app /app/app
COPY alembic /app/alembic
COPY alembic.ini /app/alembic.ini

EXPOSE 8000

# Use create_all for initial schema, then run migrations
CMD ["sh", "-c", "python -c 'from app.database import engine; from app import models; models.Base.metadata.create_all(bind=engine)' && alembic stamp head || true && python -m uvicorn app.main:app --host 0.0.0.0 --port 8000"]
