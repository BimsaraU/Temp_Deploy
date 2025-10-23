# HRGSMS - Hotel Room and Guest Service Management System

## Docker Setup

### Prerequisites
- Docker Desktop installed on your system
- Docker Compose (included with Docker Desktop)

### Quick Start

1. **Clone the repository** (if not already done)
   ```bash
   git clone <your-repo-url>
   cd HRGSMS-36
   ```

2. **Create environment file**
   ```bash
   cp .env.example .env
   ```
   Edit `.env` file and update the values as needed (especially `JWT_SECRET` and database passwords for production).

3. **Start all services**
   ```bash
   docker-compose up -d
   ```

4. **Check service status**
   ```bash
   docker-compose ps
   ```

5. **Access the application**
   - Frontend: http://localhost:3000
   - Backend API: http://localhost:8000
   - API Documentation: http://localhost:8000/docs
   - Database: localhost:3306

### Docker Commands

#### Build and start services
```bash
docker-compose up -d
```

#### Stop services
```bash
docker-compose down
```

#### Stop services and remove volumes (⚠️ deletes database data)
```bash
docker-compose down -v
```

#### View logs
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f backend
docker-compose logs -f frontend
docker-compose logs -f database
```

#### Rebuild after code changes
```bash
# Rebuild specific service
docker-compose build backend
docker-compose up -d backend

# Rebuild all services
docker-compose build
docker-compose up -d
```

#### Execute commands inside containers
```bash
# Backend
docker-compose exec backend bash

# Frontend
docker-compose exec frontend sh

# Database
docker-compose exec database mysql -u root -p
```

### Development Mode

For development with hot-reload:

1. **Backend**: Modify `docker-compose.yml` backend service:
   ```yaml
   command: uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
   ```

2. **Frontend**: Already configured with Next.js development mode in the Dockerfile.

Or run services locally without Docker:

#### Backend (Local)
```bash
cd hrgsms-backend
bash start.sh
```

#### Frontend (Local)
```bash
cd hrgsms-frontend
npm install
npm run dev
```

### Database Initialization

The database will be automatically initialized with the schema files in `hrgsms-db/` directory on first startup:
- `schema.sql` - Database schema
- `seed_data.sql` - Initial data
- `procedures.sql` - Stored procedures
- `functions.sql` - Functions
- `triggers.sql` - Triggers

### Troubleshooting

#### Services won't start
```bash
# Check logs
docker-compose logs

# Remove containers and try again
docker-compose down
docker-compose up -d
```

#### Database connection issues
```bash
# Check if database is healthy
docker-compose ps

# Restart database
docker-compose restart database
```

#### Port already in use
Edit `docker-compose.yml` and change the port mappings:
```yaml
ports:
  - "3001:3000"  # Frontend
  - "8001:8000"  # Backend
  - "3307:3306"  # Database
```

#### Clear everything and start fresh
```bash
docker-compose down -v
docker system prune -a
docker-compose up -d --build
```

### Production Deployment

1. Update environment variables in `.env`
2. Set strong passwords and JWT secret
3. Configure proper domain names
4. Set up reverse proxy (nginx/traefik)
5. Enable SSL/TLS certificates
6. Configure backup strategy for database volume

## Project Structure

```
HRGSMS-36/
├── hrgsms-backend/       # FastAPI backend
├── hrgsms-frontend/      # Next.js frontend
├── hrgsms-db/           # Database schema and seeds
├── docker-compose.yml   # Docker orchestration
└── .env                 # Environment variables
```

## License

[Your License Here]
