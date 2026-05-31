from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.database import engine, Base
from app import models
from app.routers import users, quests, stats, inventory, store, guilds, health

# Create tables
Base.metadata.create_all(bind=engine)

app = FastAPI(
    title="Oreuda API",
    description="Solo Leveling Life Gamification System",
    version="1.0.0",
)

# CORS for Flutter frontend
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
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


@app.get("/")
def root():
    return {"message": "Oreuda API — The System is online."}


@app.get("/health")
def health():
    return {"status": "operational", "system": "Oreuda"}
