# Railway Quick Start - HRGSMS

## 🚀 One-Click Deploy to Railway

Railway makes deployment super simple. Follow these steps:

### Step 1: Fork or Clone Repository
Make sure your code is in a GitHub repository.

### Step 2: Deploy Database (MySQL)

1. Go to [Railway](https://railway.app)
2. Create new project: **"New Project"**
3. Click **"Add Service"** → **"Database"** → **"Add MySQL"**
4. Wait for MySQL to provision (takes ~1 minute)

### Step 3: Initialize Database

**Option A - Using Railway Query Editor:**
1. Click MySQL service → **"Data"** tab → **"Query"**
2. Copy & paste contents of these files in order:
   ```
   hrgsms-db/schema.sql
   hrgsms-db/procedures.sql
   hrgsms-db/functions.sql
   hrgsms-db/triggers.sql
   hrgsms-db/seed_data.sql
   ```

**Option B - Using MySQL Client:**
```bash
# Get connection string from Railway MySQL "Connect" tab
mysql -h [host] -P [port] -u [user] -p[password] [database]

# Run SQL files
source hrgsms-db/schema.sql;
source hrgsms-db/procedures.sql;
source hrgsms-db/functions.sql;
source hrgsms-db/triggers.sql;
source hrgsms-db/seed_data.sql;
```

### Step 4: Deploy Backend

1. In Railway project: **"New Service"** → **"GitHub Repo"**
2. Select your repository
3. **Important:** Set **Root Directory** = `hrgsms-backend`
4. Railway auto-detects Dockerfile and builds

**Add Environment Variables:**
Click backend service → **"Variables"** → Add these:

```bash
# Database (Reference MySQL service)
DB_HOST=${{MySQL.MYSQLHOST}}
DB_PORT=${{MySQL.MYSQLPORT}}
DB_USER=${{MySQL.MYSQLUSER}}
DB_PASSWORD=${{MySQL.MYSQLPASSWORD}}
DB_NAME=${{MySQL.MYSQLDATABASE}}

# JWT
JWT_SECRET=YOUR_SUPER_SECRET_KEY_CHANGE_THIS
JWT_ALGORITHM=HS256
JWT_EXP_MINUTES=1440

# Environment
APP_ENV=production
```

**Generate Domain:**
- Backend service → **"Settings"** → **"Networking"** → **"Generate Domain"**
- Copy URL (e.g., `https://hrgsms-backend-production.up.railway.app`)

### Step 5: Deploy Frontend

1. In Railway project: **"New Service"** → **"GitHub Repo"**
2. Select same repository
3. **Important:** Set **Root Directory** = `hrgsms-frontend`
4. Railway auto-detects Dockerfile and builds

**Add Environment Variables:**
Click frontend service → **"Variables"** → Add:

```bash
# Backend API (use domain from Step 4)
NEXT_PUBLIC_API_URL=https://hrgsms-backend-production.up.railway.app

NODE_ENV=production
```

**Generate Domain:**
- Frontend service → **"Settings"** → **"Networking"** → **"Generate Domain"**
- Copy URL (e.g., `https://hrgsms-frontend-production.up.railway.app`)

### Step 6: Update Backend CORS

Add frontend URL to backend environment variables:

```bash
# In backend service variables, add:
FRONTEND_URL=https://hrgsms-frontend-production.up.railway.app
```

Railway will auto-redeploy backend. ✅

### Step 7: Test Your Deployment

1. **Backend API Docs:** `https://your-backend.up.railway.app/docs`
2. **Frontend App:** `https://your-frontend.up.railway.app`
3. **Health Check:** `https://your-backend.up.railway.app/health`

## ✅ Deployment Checklist

- [ ] MySQL database created and initialized
- [ ] Backend service deployed
- [ ] Backend environment variables configured
- [ ] Backend domain generated
- [ ] Frontend service deployed  
- [ ] Frontend environment variables configured
- [ ] Frontend domain generated
- [ ] Backend CORS updated with frontend URL
- [ ] Test login and basic functionality

## 🔄 Auto-Deploy on Git Push

Railway automatically redeploys when you push to GitHub:

```bash
git add .
git commit -m "Update feature"
git push origin main
```

Railway detects changes and redeploys affected services! 🎉

## 📊 Monitor Your Application

### View Logs
- Click any service → **"Deployments"** → Latest deployment → View logs

### View Metrics
- Click any service → **"Metrics"** → CPU, Memory, Network usage

### Debugging
```bash
# Install Railway CLI
npm i -g @railway/cli

# Login
railway login

# Link to project
railway link

# View logs
railway logs
```

## 💰 Pricing

Railway offers:
- **$5 free credit/month** (Hobby plan)
- **$0.000231/GB-hr** (Memory)
- **$0.000463/vCPU-hr** (CPU)

Typical costs for small app: **~$8-15/month**

## 🛠️ Common Issues

### Backend can't connect to database
✅ Verify MySQL service is running
✅ Check environment variables use `${{MySQL.VARIABLE}}`
✅ Ensure database is initialized

### Frontend can't reach backend  
✅ Check `NEXT_PUBLIC_API_URL` is correct
✅ Verify backend CORS includes frontend URL
✅ Test backend `/health` endpoint

### Build fails
✅ Check build logs in Railway
✅ Verify Dockerfile exists in correct directory
✅ Ensure dependencies are in requirements.txt/package.json

## 🔐 Security Tips

1. Use **strong** `JWT_SECRET` (use password generator)
2. Enable Railway's **private networking** for database
3. Add **custom domains** for production
4. Enable **2FA** on Railway account
5. Regularly review **environment variables**

## 📚 Resources

- [Railway Docs](https://docs.railway.app)
- [Railway Discord](https://discord.gg/railway)
- [Detailed Guide](./RAILWAY_DEPLOYMENT.md)

---

**Your HRGSMS is now live on Railway! 🎉**

Access your app at: `https://your-frontend.up.railway.app`
