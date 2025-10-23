# Railway Deployment Environment Variables

## 🗄️ MySQL Database Service (Already Created)

Your Railway MySQL connection details:
```
Host: nozomi.proxy.rlwy.net
Port: 33570
User: root
Password: ekDohXiaRAaEoHDorsgNysuKRgMGEOZv
Database: railway
```

**Status:** Database is provisioned ✅  
**Next Step:** Initialize schema using scripts in `hrgsms-db/` folder

---

## 🔧 Backend Service Environment Variables

Add these to your **Backend Service** in Railway:

```bash
# Database Configuration (from your Railway MySQL)
DB_HOST=nozomi.proxy.rlwy.net
DB_PORT=33570
DB_USER=root
DB_PASSWORD=ekDohXiaRAaEoHDorsgNysuKRgMGEOZv
DB_NAME=railway

# JWT Configuration (CHANGE THIS!)
JWT_SECRET=your-super-secret-jwt-key-minimum-32-characters-long
JWT_ALGORITHM=HS256
JWT_EXP_MINUTES=1440

# Application Environment
APP_ENV=production

# Frontend URL (Add after frontend is deployed)
FRONTEND_URL=https://your-frontend.up.railway.app
```

**Root Directory:** `hrgsms-backend`

### Generate Strong JWT Secret

Run one of these to generate a secure JWT secret:

```bash
# Option 1: Using OpenSSL
openssl rand -hex 32

# Option 2: Using Python
python -c "import secrets; print(secrets.token_hex(32))"

# Option 3: Using Node.js
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
```

Replace `your-super-secret-jwt-key-minimum-32-characters-long` with the generated value.

---

## 🎨 Frontend Service Environment Variables

Add these to your **Frontend Service** in Railway:

```bash
# Backend API URL (use your backend Railway domain)
NEXT_PUBLIC_API_URL=https://your-backend.up.railway.app

# Node Environment
NODE_ENV=production
```

**Root Directory:** `hrgsms-frontend`

---

## 📝 Step-by-Step Setup

### 1️⃣ Initialize Database Schema

**Run this on your local machine:**

```bash
# Navigate to database folder
cd hrgsms-db

# Windows: Run batch file
initialize_railway_db.bat

# Mac/Linux/Git Bash: Run shell script
chmod +x initialize_railway_db.sh
./initialize_railway_db.sh
```

This will create all tables, procedures, functions, triggers, and seed data.

**Verify initialization:**
```bash
mysql -h nozomi.proxy.rlwy.net -P 33570 -u root -pekDohXiaRAaEoHDorsgNysuKRgMGEOZv railway -e "SHOW TABLES;"
```

### 2️⃣ Deploy Backend

1. In Railway: **New Service** → **GitHub Repo** → Select your repo
2. Set **Root Directory:** `hrgsms-backend`
3. Go to **Variables** tab → Add environment variables (see Backend section above)
4. Wait for build to complete
5. Go to **Settings** → **Networking** → **Generate Domain**
6. Copy the backend URL (e.g., `https://hrgsms-backend-production.up.railway.app`)

### 3️⃣ Deploy Frontend

1. In Railway: **New Service** → **GitHub Repo** → Select your repo
2. Set **Root Directory:** `hrgsms-frontend`
3. Go to **Variables** tab → Add:
   ```bash
   NEXT_PUBLIC_API_URL=https://hrgsms-backend-production.up.railway.app
   NODE_ENV=production
   ```
4. Wait for build to complete
5. Go to **Settings** → **Networking** → **Generate Domain**
6. Copy the frontend URL (e.g., `https://hrgsms-frontend-production.up.railway.app`)

### 4️⃣ Update Backend CORS

1. Go back to **Backend Service** → **Variables**
2. Add or update:
   ```bash
   FRONTEND_URL=https://hrgsms-frontend-production.up.railway.app
   ```
3. Backend will automatically redeploy with CORS configured

---

## ✅ Verification Checklist

- [ ] MySQL database initialized with all tables
- [ ] Backend service deployed with correct env variables
- [ ] Backend domain generated and accessible
- [ ] Frontend service deployed with backend URL
- [ ] Frontend domain generated and accessible
- [ ] Backend CORS updated with frontend URL
- [ ] Test API docs: `https://your-backend.up.railway.app/docs`
- [ ] Test frontend: `https://your-frontend.up.railway.app`
- [ ] Test login functionality

---

## 🔍 Quick Test Commands

### Test Backend API
```bash
# Health check
curl https://your-backend.up.railway.app/health

# API root
curl https://your-backend.up.railway.app/
```

### Test Database Connection
```bash
mysql -h nozomi.proxy.rlwy.net -P 33570 -u root -pekDohXiaRAaEoHDorsgNysuKRgMGEOZv railway -e "SELECT COUNT(*) as table_count FROM information_schema.tables WHERE table_schema='railway';"
```

---

## 🚨 Common Issues

### Backend can't connect to database
- Verify DB_HOST, DB_PORT, DB_USER, DB_PASSWORD are correct
- Check Railway MySQL service is running
- View backend logs in Railway

### Frontend can't reach backend
- Verify NEXT_PUBLIC_API_URL is correct
- Check backend service is running
- Verify CORS is configured (FRONTEND_URL set)

### Database not initialized
- Run initialization scripts from `hrgsms-db/` folder
- Check MySQL client is installed
- Verify connection details

---

## 📚 Files Reference

- `hrgsms-db/initialize_railway_db.bat` - Windows init script
- `hrgsms-db/initialize_railway_db.sh` - Linux/Mac init script
- `hrgsms-db/RAILWAY_DB_INIT.md` - Database setup guide
- `RAILWAY_DEPLOYMENT.md` - Full deployment guide
- `RAILWAY_QUICKSTART.md` - Quick start guide

---

## 🔐 Security Reminders

⚠️ **IMPORTANT:**

1. ✅ Generate and use a strong JWT_SECRET (32+ characters)
2. ✅ Never commit `.env` files or credentials to Git
3. ✅ Use Railway's environment variables (not hardcoded)
4. ✅ Enable 2FA on Railway account
5. ✅ Rotate passwords regularly
6. ✅ Monitor Railway logs for suspicious activity

---

**Your credentials are ready for deployment!** 🚀

Next: Initialize database → Deploy backend → Deploy frontend → Test!
