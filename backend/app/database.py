import os
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

SQLALCHEMY_DATABASE_URL = os.getenv(
    "DATABASE_URL",
    "sqlite:///./oreuda.db"
)

# Handle asyncpg prefix if present
if SQLALCHEMY_DATABASE_URL.startswith("postgresql://"):
    pass  # psycopg handles postgresql:// directly

engine = create_engine(
    SQLALCHEMY_DATABASE_URL,
    connect_args={} if "postgresql" in SQLALCHEMY_DATABASE_URL else {"check_same_thread": False}
)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
