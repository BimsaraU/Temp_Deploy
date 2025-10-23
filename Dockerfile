# Multi-stage Dockerfile for HRGSMS Full Stack Application
# This Dockerfile builds both backend and frontend services

# ============================================
# Stage 1: Backend Build
# ============================================
FROM python:3.11-slim AS backend

WORKDIR /hrgsms-backend

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends gcc && \
    rm -rf /var/lib/apt/lists/*

# Copy backend files
COPY hrgsms-backend/requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

COPY hrgsms-backend/ .

# Backend will run on port specified by $PORT (Railway) or 8000
EXPOSE ${PORT:-8000}

# ============================================
# Stage 2: Frontend Build
# ============================================
FROM node:18-alpine AS frontend

WORKDIR /hrgsms-frontend

# Copy package files
COPY hrgsms-frontend/package*.json ./

# Use npm install (package-lock.json might not exist)
RUN npm install --legacy-peer-deps

COPY hrgsms-frontend/ .

# Build Next.js application
RUN npm run build

# ============================================
# Stage 3: Production - Backend Runtime
# ============================================
FROM python:3.11-slim AS backend-runtime

WORKDIR /app/backend

# Install runtime dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends gcc && \
    rm -rf /var/lib/apt/lists/*

# Copy backend from build stage
COPY --from=backend /hrgsms-backend /app/backend

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

EXPOSE 8000

# ============================================
# Stage 4: Production - Frontend Runtime
# ============================================
FROM node:18-alpine AS frontend-runtime

WORKDIR /app/frontend

ENV NODE_ENV=production

# Create non-root user
RUN addgroup --system --gid 1001 nodejs && \
    adduser --system --uid 1001 nextjs

# Copy frontend build
COPY --from=frontend /hrgsms-frontend/public ./public
COPY --from=frontend /hrgsms-frontend/.next/standalone ./
COPY --from=frontend /hrgsms-frontend/.next/static ./.next/static

USER nextjs

EXPOSE 3000

# Start Next.js server
CMD ["node", "server.js"]
