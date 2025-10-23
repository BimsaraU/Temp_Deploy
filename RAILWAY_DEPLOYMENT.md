# Railway Deployment Guide - HRGSMS

This guide will help you deploy the HRGSMS application to Railway.

## Prerequisites

- Railway account (sign up at https://railway.app)
- GitHub account with your repository
- Basic understanding of environment variables

## Architecture

Your application will be deployed as 3 separate Railway services:
1. **MySQL Database** - Railway's MySQL plugin
2. **Backend API** - FastAPI application
3. **Frontend** - Next.js application

## Deployment Steps

### 1. Create a New Railway Project

1. Go to https://railway.app
2. Click "New Project"
3. Select "Deploy from GitHub repo"
4. Authorize Railway to access your repository
5. Select your `Temp_Deploy` repository

### 2. Deploy MySQL Database

1. In your Railway project, click "New Service"
2. Select "Database" → "Add MySQL"
3. Railway will automatically provision a MySQL database
4. Note the connection details from the "Variables" tab:
   - `MYSQL_URL`
   - `MYSQL_HOST`
   - `MYSQL_PORT`
   - `MYSQL_USER`
   - `MYSQL_PASSWORD`
   - `MYSQL_DATABASE`

#### Initialize Database Schema

You have two options to initialize the database:

**Option A: Using Railway MySQL Client**
1. Click on the MySQL service
2. Go to "Data" tab
3. Click "Query"
4. Copy and paste the contents of each SQL file in this order:
   - `hrgsms-db/schema.sql`
   - `hrgsms-db/procedures.sql`
   - `hrgsms-db/functions.sql`
   - `hrgsms-db/triggers.sql`
   - `hrgsms-db/seed_data.sql`
5. Execute each file

**Option B: Using MySQL Client Locally**
```bash
# Connect to Railway MySQL from your local machine
mysql -h [MYSQL_HOST] -P [MYSQL_PORT] -u [MYSQL_USER] -p[MYSQL_PASSWORD] [MYSQL_DATABASE]

# Then run each SQL file
source hrgsms-db/schema.sql;
source hrgsms-db/procedures.sql;
source hrgsms-db/functions.sql;
source hrgsms-db/triggers.sql;
source hrgsms-db/seed_data.sql;
```

### 3. Deploy Backend API

1. In your Railway project, click "New Service"
2. Select "GitHub Repo" → Choose your repository
3. Set the **Root Directory** to: `hrgsms-backend`
4. Railway will automatically detect the Dockerfile

#### Configure Backend Environment Variables

Click on the backend service → "Variables" tab → Add the following:

```bash
# Database Configuration (Reference from MySQL service)
DB_HOST=${{MySQL.MYSQL_HOST}}
DB_PORT=${{MySQL.MYSQL_PORT}}
DB_USER=${{MySQL.MYSQL_USER}}
DB_PASSWORD=${{MySQL.MYSQL_PASSWORD}}
DB_NAME=${{MySQL.MYSQL_DATABASE}}

# JWT Configuration
JWT_SECRET=your-super-secret-key-change-this-in-production
JWT_ALGORITHM=HS256
JWT_EXP_MINUTES=1440

# Application Environment
APP_ENV=production
```

**Note:** Railway allows you to reference variables from other services using `${{ServiceName.VARIABLE_NAME}}` syntax.

#### Generate Public Domain

1. Click on the backend service
2. Go to "Settings" tab
3. Scroll to "Networking"
4. Click "Generate Domain"
5. Copy the generated URL (e.g., `https://your-backend.up.railway.app`)

### 4. Deploy Frontend

1. In your Railway project, click "New Service"
2. Select "GitHub Repo" → Choose your repository
3. Set the **Root Directory** to: `hrgsms-frontend`
4. Railway will automatically detect the Dockerfile

#### Configure Frontend Environment Variables

Click on the frontend service → "Variables" tab → Add the following:

```bash
# API Configuration (use the backend domain from step 3)
NEXT_PUBLIC_API_URL=https://your-backend.up.railway.app

# Node Environment
NODE_ENV=production
```

#### Generate Public Domain

1. Click on the frontend service
2. Go to "Settings" tab
3. Scroll to "Networking"
4. Click "Generate Domain"
5. Copy the generated URL (e.g., `https://your-frontend.up.railway.app`)

### 5. Configure CORS (Backend)

Update your backend CORS settings to allow requests from your frontend domain:

1. Edit `hrgsms-backend/app/main.py`
2. Add your Railway frontend domain to allowed origins:

```python
from fastapi.middleware.cors import CORSMiddleware

app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:3000",
        "https://your-frontend.up.railway.app"  # Add this
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

3. Commit and push changes - Railway will automatically redeploy

## Verification

### Test Backend API

Visit: `https://your-backend.up.railway.app/docs`

You should see the FastAPI Swagger documentation.

### Test Frontend

Visit: `https://your-frontend.up.railway.app`

You should see your HRGSMS application.

## Service URLs

After deployment, you'll have:

- **Database**: Internal Railway network (MySQL)
- **Backend API**: `https://your-backend.up.railway.app`
- **Frontend**: `https://your-frontend.up.railway.app`
- **API Docs**: `https://your-backend.up.railway.app/docs`

## Environment Variables Reference

### Backend Service

| Variable | Description | Example |
|----------|-------------|---------|
| `DB_HOST` | MySQL host from Railway | `${{MySQL.MYSQL_HOST}}` |
| `DB_PORT` | MySQL port | `${{MySQL.MYSQL_PORT}}` |
| `DB_USER` | MySQL user | `${{MySQL.MYSQL_USER}}` |
| `DB_PASSWORD` | MySQL password | `${{MySQL.MYSQL_PASSWORD}}` |
| `DB_NAME` | Database name | `${{MySQL.MYSQL_DATABASE}}` |
| `JWT_SECRET` | Secret key for JWT | Your secure key |
| `JWT_ALGORITHM` | JWT algorithm | `HS256` |
| `JWT_EXP_MINUTES` | Token expiration | `1440` |
| `APP_ENV` | Environment | `production` |

### Frontend Service

| Variable | Description | Example |
|----------|-------------|---------|
| `NEXT_PUBLIC_API_URL` | Backend API URL | `https://your-backend.up.railway.app` |
| `NODE_ENV` | Node environment | `production` |

## Monitoring and Logs

### View Logs

1. Click on any service in Railway
2. Go to "Deployments" tab
3. Click on the latest deployment
4. View real-time logs

### View Metrics

1. Click on any service
2. Go to "Metrics" tab
3. View CPU, Memory, and Network usage

## Troubleshooting

### Backend won't connect to database

- Verify database environment variables are correctly referenced
- Check that database service is healthy
- Ensure database schema is initialized

### Frontend can't reach backend

- Verify `NEXT_PUBLIC_API_URL` is set correctly
- Check backend CORS configuration includes frontend domain
- Ensure backend service is running

### Database connection timeout

- Check that all SQL files were executed successfully
- Verify MySQL service is running
- Check Railway service logs for detailed errors

### Build failures

- Check Railway build logs
- Verify Dockerfile syntax
- Ensure all dependencies are listed in requirements.txt/package.json

## Updating Your Application

Railway automatically redeploys when you push to your GitHub repository:

1. Make changes to your code
2. Commit and push to GitHub:
   ```bash
   git add .
   git commit -m "Your commit message"
   git push origin master
   ```
3. Railway will automatically detect changes and redeploy affected services

## Cost Optimization

Railway offers:
- **$5 free credit per month** for Hobby plan
- Pay-as-you-go pricing after free credits

To optimize costs:
1. Monitor resource usage in Railway dashboard
2. Scale down services when not in use
3. Use Railway's sleep feature for development environments

## Custom Domains (Optional)

To use your own domain:

1. Click on frontend service → "Settings" → "Networking"
2. Click "Custom Domain"
3. Add your domain (e.g., `hrgsms.yourdomain.com`)
4. Add the provided CNAME record to your DNS provider
5. Wait for DNS propagation (usually 5-30 minutes)

Repeat for backend if needed.

## Security Recommendations

1. ✅ Use strong, unique `JWT_SECRET`
2. ✅ Enable Railway's private networking for database
3. ✅ Regularly update dependencies
4. ✅ Monitor Railway logs for suspicious activity
5. ✅ Use Railway's environment variable groups for multiple environments
6. ✅ Enable 2FA on your Railway account

## Backup Strategy

Railway MySQL includes automatic backups, but you should also:

1. Use Railway's built-in backup feature
2. Export database regularly:
   ```bash
   mysqldump -h [HOST] -P [PORT] -u [USER] -p[PASSWORD] [DATABASE] > backup.sql
   ```
3. Store backups in a separate location (AWS S3, Google Drive, etc.)

## Support

- **Railway Documentation**: https://docs.railway.app
- **Railway Discord**: https://discord.gg/railway
- **GitHub Issues**: Create an issue in your repository

## Quick Reference Commands

```bash
# View Railway CLI help
railway help

# Link to Railway project
railway link

# View logs
railway logs

# Run command in Railway environment
railway run <command>

# Deploy manually
railway up
```

---

**Deployment Checklist:**
- [ ] MySQL database created and initialized
- [ ] Backend deployed with correct environment variables
- [ ] Backend domain generated
- [ ] Frontend deployed with backend URL configured
- [ ] Frontend domain generated
- [ ] CORS configured in backend
- [ ] Application tested end-to-end
- [ ] Environment variables secured
- [ ] Monitoring set up

🚀 Your HRGSMS application is now live on Railway!
