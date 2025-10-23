# Docker Usage Guide - HRGSMS

## 📦 Docker Files in This Project

This project has **multiple Dockerfiles** for different purposes:

### 1. **Root Dockerfile** (`./Dockerfile`)
- **Purpose:** Multi-stage build (both backend + frontend)
- **Use Case:** Advanced users, custom builds
- **Not recommended for Railway**

### 2. **Backend Dockerfile** (`./hrgsms-backend/Dockerfile`)
- **Purpose:** Backend FastAPI service only
- **Use Case:** Railway deployment, backend-only builds
- **✅ Recommended for Railway backend service**

### 3. **Frontend Dockerfile** (`./hrgsms-frontend/Dockerfile`)
- **Purpose:** Frontend Next.js service only
- **Use Case:** Railway deployment, frontend-only builds
- **✅ Recommended for Railway frontend service**

---

## 🚀 How to Build & Run

### Option 1: Using Docker Compose (Recommended for Local Development)

Build and start all services (database, backend, frontend):

```bash
# From project root
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

This uses the individual Dockerfiles in each service folder.

### Option 2: Build Individual Services

#### Backend Only:
```bash
cd hrgsms-backend
docker build -t hrgsms-backend:latest .
docker run -p 8000:8000 \
  -e DB_HOST=host.docker.internal \
  -e DB_PORT=3306 \
  -e DB_USER=root \
  -e DB_PASSWORD=password \
  -e DB_NAME=hrgsms_db \
  -e JWT_SECRET=your-secret-key \
  hrgsms-backend:latest
```

#### Frontend Only:
```bash
cd hrgsms-frontend
docker build -t hrgsms-frontend:latest .
docker run -p 3000:3000 \
  -e NEXT_PUBLIC_API_URL=http://localhost:8000 \
  hrgsms-frontend:latest
```

### Option 3: Root Dockerfile (Advanced)

```bash
# From project root
docker build -t hrgsms-fullstack:latest .

# This builds both services but runs backend by default
# Not practical for production - use docker-compose instead
```

---

## 🎯 For Railway Deployment

**Do NOT use the root Dockerfile for Railway!**

Railway deployment uses the **service-specific Dockerfiles**:

1. **Backend Service:**
   - Root Directory: `hrgsms-backend`
   - Uses: `hrgsms-backend/Dockerfile`

2. **Frontend Service:**
   - Root Directory: `hrgsms-frontend`
   - Uses: `hrgsms-frontend/Dockerfile`

See `RAILWAY_ENV_SETUP.md` for complete Railway deployment instructions.

---

## 🔧 Troubleshooting

### ❌ "docker build failed" in root directory

**Problem:** Trying to build from project root without specifying context.

**Solution:**
```bash
# Option A: Use docker-compose (recommended)
docker-compose build

# Option B: Build specific service
cd hrgsms-backend && docker build -t backend .
cd hrgsms-frontend && docker build -t frontend .

# Option C: Build from root with context
docker build -f hrgsms-backend/Dockerfile -t backend ./hrgsms-backend
docker build -f hrgsms-frontend/Dockerfile -t frontend ./hrgsms-frontend
```

### ❌ "Cannot find package.json" or "Cannot find requirements.txt"

**Problem:** Building from wrong directory.

**Solution:**
- For backend: `cd hrgsms-backend` then build
- For frontend: `cd hrgsms-frontend` then build
- Or use docker-compose from root

### ❌ Frontend build fails with "standalone output not found"

**Problem:** `next.config.js` doesn't have `output: 'standalone'`

**Solution:** Already configured in `hrgsms-frontend/next.config.js`

---

## 📊 Docker Architecture

```
Project Root
│
├── Dockerfile                       # Multi-stage (optional)
├── docker-compose.yml              # Orchestrates all services ✅
│
├── hrgsms-backend/
│   ├── Dockerfile                   # Backend service ✅
│   └── ...
│
└── hrgsms-frontend/
    ├── Dockerfile                   # Frontend service ✅
    └── ...
```

---

## ✅ Best Practices

### Local Development:
```bash
docker-compose up -d
```

### Production (Railway):
- Use service-specific Dockerfiles
- Set Root Directory in Railway
- Backend: `hrgsms-backend`
- Frontend: `hrgsms-frontend`

### Testing Individual Services:
```bash
# Backend
cd hrgsms-backend && docker build -t test-backend .

# Frontend
cd hrgsms-frontend && docker build -t test-frontend .
```

---

## 🔍 Quick Commands

```bash
# Build all services
docker-compose build

# Start all services
docker-compose up -d

# View logs
docker-compose logs -f [service-name]

# Stop all services
docker-compose down

# Rebuild and restart
docker-compose up -d --build

# Remove volumes (⚠️ deletes database data)
docker-compose down -v

# Check running containers
docker ps

# Access backend shell
docker exec -it hrgsms-backend bash

# Access frontend shell
docker exec -it hrgsms-frontend sh
```

---

## 📖 Related Documentation

- **Local Development:** Use `docker-compose.yml`
- **Railway Deployment:** See `RAILWAY_ENV_SETUP.md`
- **Troubleshooting:** See `TROUBLESHOOTING.md`

---

**Recommended:** Use `docker-compose` for local development and service-specific Dockerfiles for Railway deployment.
