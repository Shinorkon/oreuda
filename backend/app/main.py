import os
from contextlib import asynccontextmanager

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from slowapi import Limiter, _rate_limit_exceeded_handler
from slowapi.util import get_remote_address
from slowapi.errors import RateLimitExceeded

from app.database import engine, Base
from app import models, crud
from app.routers import users, quests, stats, inventory, store, guilds, health, lyfta, titles


@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup: create tables (dev convenience) and seed store items
    Base.metadata.create_all(bind=engine)
    from app.database import SessionLocal
    db = SessionLocal()
    try:
        crud.seed_store_items(db)
    finally:
        db.close()
    yield
    # Shutdown: nothing needed


limiter = Limiter(key_func=get_remote_address)

app = FastAPI(
    title="Oreuda API",
    description="Solo Leveling Life Gamification System",
    version="1.0.0",
    lifespan=lifespan,
)
app.state.limiter = limiter
app.add_exception_handler(RateLimitExceeded, _rate_limit_exceeded_handler)

# CORS: restrict to actual frontend origins
_cors_origins = os.getenv("CORS_ORIGINS", "http://localhost:8004,http://10.0.2.2:8004").split(",")
app.add_middleware(
    CORSMiddleware,
    allow_origins=[o.strip() for o in _cors_origins if o.strip()],
    allow_credentials=True,
    allow_methods=["GET", "POST", "PUT", "DELETE", "PATCH"],
    allow_headers=["*"],
)

# Include routers
app.include_router(users.router, prefix="/api/v1")
app.include_router(quests.router, prefix="/api/v1")
app.include_router(stats.router, prefix="/api/v1")
app.include_router(inventory.router, prefix="/api/v1")
app.include_router(store.router, prefix="/api/v1")
app.include_router(guilds.router, prefix="/api/v1")
app.include_router(health.router, prefix="/api/v1")
app.include_router(lyfta.router, prefix="/api/v1")
app.include_router(titles.router, prefix="/api/v1")


@app.get("/")
def root():
    return {"message": "Oreuda API — The System is online."}


@app.get("/health")
def health():
    return {"status": "operational", "system": "Oreuda"}
