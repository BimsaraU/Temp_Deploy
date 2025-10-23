# HRGSMS Railway Architecture

## 🏗️ Application Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                         USERS / CLIENTS                              │
└─────────────────────────────────────────────────────────────────────┘
                                  │
                                  │ HTTPS
                                  ▼
┌─────────────────────────────────────────────────────────────────────┐
│                    RAILWAY FRONTEND SERVICE                          │
│  ┌───────────────────────────────────────────────────────────────┐  │
│  │  Next.js Application                                          │  │
│  │  - React Components                                           │  │
│  │  - Client-side Routing                                        │  │
│  │  - API Client (axios)                                         │  │
│  │                                                               │  │
│  │  Root Directory: hrgsms-frontend/                            │  │
│  │  Domain: https://your-frontend.up.railway.app                │  │
│  └───────────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────────┘
                                  │
                                  │ REST API Calls
                                  │ CORS: Configured
                                  ▼
┌─────────────────────────────────────────────────────────────────────┐
│                     RAILWAY BACKEND SERVICE                          │
│  ┌───────────────────────────────────────────────────────────────┐  │
│  │  FastAPI Application                                          │  │
│  │  - REST API Endpoints                                         │  │
│  │  - JWT Authentication                                         │  │
│  │  - Business Logic                                             │  │
│  │  - Database Connection Pool                                   │  │
│  │                                                               │  │
│  │  Root Directory: hrgsms-backend/                             │  │
│  │  Domain: https://your-backend.up.railway.app                 │  │
│  │  Port: Dynamic ($PORT from Railway)                          │  │
│  └───────────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────────┘
                                  │
                                  │ MySQL Protocol
                                  │ TCP Connection
                                  ▼
┌─────────────────────────────────────────────────────────────────────┐
│                      RAILWAY MYSQL SERVICE                           │
│  ┌───────────────────────────────────────────────────────────────┐  │
│  │  MySQL 8.0 Database                                           │  │
│  │  - Tables & Schema                                            │  │
│  │  - Stored Procedures                                          │  │
│  │  - Functions & Triggers                                       │  │
│  │  - Seed Data                                                  │  │
│  │                                                               │  │
│  │  Host: nozomi.proxy.rlwy.net                                 │  │
│  │  Port: 33570                                                 │  │
│  │  Database: railway                                           │  │
│  └───────────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────────┘
```

## 📊 Data Flow

```
User Action (Frontend)
        │
        ▼
API Request (axios)
        │
        ▼
Backend Route Handler
        │
        ▼
Service Layer (Business Logic)
        │
        ▼
Database Query (mysql-connector)
        │
        ▼
MySQL Database
        │
        ▼
Query Result
        │
        ▼
Response Processing
        │
        ▼
JSON Response
        │
        ▼
Frontend UI Update
```

## 🔐 Authentication Flow

```
1. User Login Request
   └─> POST /api/auth/login
       └─> Validate credentials
           └─> Query user_account table
               └─> Compare hashed password
                   ├─> Success: Generate JWT token
                   │   └─> Return token to frontend
                   │       └─> Store in localStorage
                   │           └─> Include in subsequent requests
                   │
                   └─> Failure: Return 401 Unauthorized

2. Protected API Request
   └─> Include JWT in Authorization header
       └─> Backend validates token
           ├─> Valid: Process request
           └─> Invalid: Return 401
```

## 🌐 Environment Configuration

### Frontend Service
```
Environment Variables:
├─ NEXT_PUBLIC_API_URL → Points to Backend Service
└─ NODE_ENV → production

Connects to:
└─ Backend Service (via HTTPS)
```

### Backend Service
```
Environment Variables:
├─ DB_HOST → Railway MySQL host
├─ DB_PORT → Railway MySQL port
├─ DB_USER → Railway MySQL user
├─ DB_PASSWORD → Railway MySQL password
├─ DB_NAME → railway
├─ JWT_SECRET → Secure random string
├─ APP_ENV → production
└─ FRONTEND_URL → Railway Frontend URL (for CORS)

Connects to:
└─ MySQL Service (via TCP)
```

### MySQL Service
```
Railway Managed:
├─ Automatic backups
├─ High availability
├─ Private networking
└─ Monitoring

Initialized with:
├─ schema.sql (tables)
├─ procedures.sql
├─ functions.sql
├─ triggers.sql
└─ seed_data.sql
```

## 📦 Services Overview

| Service  | Technology | Port | Root Directory | Purpose |
|----------|-----------|------|----------------|---------|
| Frontend | Next.js 14 | Dynamic | `hrgsms-frontend/` | User Interface |
| Backend  | FastAPI | Dynamic | `hrgsms-backend/` | REST API |
| Database | MySQL 8.0 | 33570 | - | Data Storage |

## 🔄 Deployment Flow

```
Code Push to GitHub
        │
        ▼
Railway Detects Change
        │
        ▼
Trigger Build Process
        │
        ├─> Frontend Build
        │   ├─> npm install
        │   ├─> npm run build
        │   └─> Start server
        │
        └─> Backend Build
            ├─> pip install -r requirements.txt
            ├─> Build Docker image
            └─> Start uvicorn
        │
        ▼
Health Checks Pass
        │
        ▼
Update Routing (Zero Downtime)
        │
        ▼
Deployment Complete ✅
```

## 🔍 Health Monitoring

### Backend Health Check
```
GET /health

Response:
{
  "status": "healthy",
  "database": "connected"
}
```

### Frontend Health Check
```
Simply access the frontend URL
- Should load without errors
- Check browser console for issues
```

### Database Health Check
```bash
mysql -h nozomi.proxy.rlwy.net -P 33570 \
      -u root -pekDohXiaRAaEoHDorsgNysuKRgMGEOZv \
      railway -e "SELECT 1;"
```

## 📡 API Endpoints Overview

```
Authentication:
├─ POST   /api/auth/login
├─ POST   /api/auth/register
└─ POST   /api/auth/logout

Guests:
├─ GET    /api/guests
├─ POST   /api/guests
├─ GET    /api/guests/{id}
├─ PUT    /api/guests/{id}
└─ DELETE /api/guests/{id}

Rooms:
├─ GET    /api/rooms
├─ POST   /api/rooms
├─ GET    /api/rooms/{id}
├─ PUT    /api/rooms/{id}
└─ DELETE /api/rooms/{id}

Reservations:
├─ GET    /api/reservations
├─ POST   /api/reservations
├─ GET    /api/reservations/{id}
├─ PUT    /api/reservations/{id}
└─ DELETE /api/reservations/{id}

Services:
├─ GET    /api/services
├─ POST   /api/services
├─ GET    /api/services/{id}
├─ PUT    /api/services/{id}
└─ DELETE /api/services/{id}

Payments:
├─ GET    /api/payments
├─ POST   /api/payments
└─ GET    /api/payments/{id}

Reports:
├─ GET    /api/reports/revenue
├─ GET    /api/reports/occupancy
├─ GET    /api/reports/services
├─ GET    /api/reports/billing
└─ GET    /api/reports/trends
```

## 🛡️ Security Layers

```
1. HTTPS (Railway Automatic)
   └─> All traffic encrypted

2. CORS (Backend Configuration)
   └─> Only frontend domain allowed

3. JWT Authentication
   └─> Stateless token-based auth

4. Password Hashing
   └─> bcrypt hashing

5. SQL Injection Prevention
   └─> Parameterized queries

6. Input Validation
   └─> Pydantic models

7. Private Networking (Railway)
   └─> Database not publicly accessible
```

## 📈 Scalability

Railway allows easy scaling:

```
Current Setup:
├─ Frontend: 1 replica
├─ Backend: 1 replica
└─ Database: Managed (auto-scaling)

To Scale:
├─ Increase replicas in Railway dashboard
├─ Add load balancing (automatic)
└─ Database scales with usage
```

## 💰 Cost Estimation

```
Typical Monthly Cost (Railway):

MySQL Service:    ~$5-8
Backend Service:  ~$3-5
Frontend Service: ~$2-3
─────────────────────
Total:           ~$10-16/month

Note: First $5 free with Hobby plan
```

## 🎯 Next Steps After Deployment

1. ✅ Monitor application logs
2. ✅ Set up error notifications
3. ✅ Configure custom domain (optional)
4. ✅ Set up automated backups
5. ✅ Implement CI/CD (already done via GitHub)
6. ✅ Add monitoring/alerting
7. ✅ Performance optimization

---

**Your HRGSMS application is now running on a production-grade infrastructure!** 🚀
