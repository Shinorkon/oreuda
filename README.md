# Oreuda — Solo Leveling Life System

> Flutter × FastAPI · Android Only

## Overview

Oreuda is a mobile life-gamification application that transforms daily self-improvement into a Solo Leveling RPG experience. Users begin as E-Rank Hunters with a holographic System interface that assigns daily quests, tracks five core stats (STR, AGI, VIT, INT, SEN), and progresses through a rank hierarchy from E to S.

## Architecture

```
oreuda/
├── backend/          # FastAPI + SQLAlchemy + PostgreSQL
│   ├── app/          # API routes, models, auth, business logic
│   ├── alembic/      # Database migrations
│   ├── Dockerfile
│   └── requirements.txt
├── frontend/         # Flutter app (Android)
│   └── lib/          # Screens, widgets, services, models
├── docker-compose.yml
└── deploy-contabo.sh # One-command Contabo deployment
```

## Quick Start (Local Development)

### Backend

```bash
cd backend
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload
# API docs at http://localhost:8000/docs
```

### Frontend

```bash
cd frontend
flutter pub get
flutter run
```

## Contabo VPS Deployment

1. SSH into your Contabo server
2. Clone this repo to `/root/oreuda`
3. Run the deploy script:

```bash
cd /root/oreuda
chmod +x deploy-contabo.sh
./deploy-contabo.sh
```

This will:
- Install Docker & Docker Compose if missing
- Generate random DB password and JWT secret
- Build and start PostgreSQL + FastAPI containers
- Run database migrations automatically
- Expose API on port **8004**

### Post-Deploy

```bash
# Check status
docker compose ps

# View logs
docker compose logs -f backend

# Restart
docker compose restart
```

## API Endpoints

| Route | Description |
|-------|-------------|
| `POST /api/v1/users/register` | Create account |
| `POST /api/v1/users/login` | Get JWT token |
| `GET /api/v1/users/me` | Full profile |
| `GET /api/v1/quests/` | List quests |
| `GET /api/v1/quests/daily` | Get today's quests |
| `POST /api/v1/quests/{id}/complete` | Complete quest |
| `GET /api/v1/stats/leaderboard` | Global rankings |
| `GET /api/v1/store/items` | Store catalog |
| `POST /api/v1/store/buy/{id}` | Purchase item |
| `GET /api/v1/guilds/` | List guilds |

## Design System

- **Background:** `#030712` (Void Navy)
- **Primary Accent:** `#00E5FF` (Holographic Cyan)
- **Gold:** `#FFD700` (Arise Gold)
- **Red:** `#FF1744` (HP Crimson)
- **Fonts:** Orbitron, JetBrains Mono, Inter, Share Tech Mono

## License

MIT
# trigger ci
# ci trigger 1780239280
# ci trigger 1780240518
