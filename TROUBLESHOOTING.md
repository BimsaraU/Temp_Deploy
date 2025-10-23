# 🔧 HRGSMS Railway Troubleshooting Guide

Quick solutions to common deployment issues.

---

## 🗄️ Database Issues

### ❌ "mysql command not found"

**Problem:** MySQL client not installed on your system.

**Solution:**

**Windows:**
```bash
winget install Oracle.MySQL
# OR download from: https://dev.mysql.com/downloads/mysql/
```

**Mac:**
```bash
brew install mysql-client
```

**Linux (Ubuntu/Debian):**
```bash
sudo apt-get update
sudo apt-get install mysql-client
```

---

### ❌ "Access denied for user 'root'"

**Problem:** Incorrect password or connection details.

**Solution:**
1. Verify password has no extra spaces
2. Use exact credentials from Railway:
   ```bash
   mysql -h nozomi.proxy.rlwy.net -P 33570 -u root -pekDohXiaRAaEoHDorsgNysuKRgMGEOZv railway
   ```
3. Check Railway MySQL service is running

---

### ❌ "Can't connect to MySQL server"

**Problem:** Network issues or incorrect host/port.

**Solution:**
1. Check your internet connection
2. Verify Railway MySQL service status
3. Try adding `--protocol=TCP`:
   ```bash
   mysql -h nozomi.proxy.rlwy.net -P 33570 -u root -pekDohXiaRAaEoHDorsgNysuKRgMGEOZv --protocol=TCP railway
   ```
4. Try connecting from Railway web interface instead

---

### ❌ "Table already exists" Error

**Problem:** Database already has tables from previous initialization.

**Solution:**
```sql
-- Connect to database first, then:
DROP DATABASE railway;
CREATE DATABASE railway;
USE railway;
```
Then run initialization scripts again.

---

### ❌ Initialization script fails midway

**Problem:** SQL syntax error or missing file.

**Solution:**
1. Check all SQL files exist in `hrgsms-db/` folder:
   - schema.sql
   - procedures.sql
   - functions.sql
   - triggers.sql
   - seed_data.sql

2. Run files individually to find the problem:
   ```bash
   mysql -h nozomi.proxy.rlwy.net -P 33570 -u root -pekDohXiaRAaEoHDorsgNysuKRgMGEOZv railway < schema.sql
   ```

3. Check Railway MySQL logs for detailed errors

---

## 🔧 Backend Issues

### ❌ Backend build fails

**Problem:** Missing dependencies or Dockerfile issues.

**Solution:**
1. Check Railway build logs (Deployments → View Logs)
2. Verify `requirements.txt` has all dependencies:
   ```
   fastapi>=0.115.0
   uvicorn[standard]>=0.30.0
   python-dotenv>=1.0.1
   mysql-connector-python>=9.0.0
   python-jose[cryptography]>=3.3.0
   passlib[bcrypt]>=1.7.4
   pydantic>=2.7.0
   pydantic-settings>=2.2.1
   ```
3. Ensure `Dockerfile` exists in `hrgsms-backend/`
4. Verify Root Directory is set to `hrgsms-backend`

---

### ❌ Backend can't connect to database

**Problem:** Incorrect database environment variables.

**Solution:**
1. Verify environment variables in Railway Backend service:
   ```bash
   DB_HOST=nozomi.proxy.rlwy.net
   DB_PORT=33570
   DB_USER=root
   DB_PASSWORD=ekDohXiaRAaEoHDorsgNysuKRgMGEOZv
   DB_NAME=railway
   ```
2. Check for typos (copy-paste from docs)
3. View backend logs for specific error
4. Test database connection manually

---

### ❌ Backend starts but crashes immediately

**Problem:** Missing environment variables or database connection failure.

**Solution:**
1. Check Railway backend logs
2. Verify all required environment variables are set:
   - DB_HOST, DB_PORT, DB_USER, DB_PASSWORD, DB_NAME
   - JWT_SECRET, JWT_ALGORITHM, JWT_EXP_MINUTES
   - APP_ENV
3. Test `/health` endpoint
4. Verify database is initialized

---

### ❌ "/health endpoint returns unhealthy"

**Problem:** Database connection issue.

**Solution:**
1. Check database environment variables
2. Verify MySQL service is running
3. Test database connection manually:
   ```bash
   mysql -h nozomi.proxy.rlwy.net -P 33570 -u root -pekDohXiaRAaEoHDorsgNysuKRgMGEOZv railway -e "SELECT 1;"
   ```
4. Check backend logs for connection errors

---

### ❌ "Port already in use" in local development

**Problem:** Port 8000 is occupied.

**Solution:**
```bash
# Find and kill process on port 8000
# Windows:
netstat -ano | findstr :8000
taskkill /PID <PID> /F

# Linux/Mac:
lsof -ti:8000 | xargs kill -9

# Or use different port:
uvicorn app.main:app --port 8001
```

---

## 🎨 Frontend Issues

### ❌ Frontend build fails

**Problem:** Missing dependencies or build errors.

**Solution:**
1. Check Railway build logs
2. Verify `package.json` has all dependencies:
   ```json
   {
     "dependencies": {
       "next": "14.1.0",
       "react": "18.2.0",
       "react-dom": "18.2.0",
       "axios": "^1.7.2",
       "chart.js": "^4.4.0",
       "react-chartjs-2": "^5.2.0"
     }
   }
   ```
3. Ensure `next.config.js` has `output: 'standalone'`
4. Verify Root Directory is set to `hrgsms-frontend`

---

### ❌ Frontend loads but shows blank page

**Problem:** API connection issue or build error.

**Solution:**
1. Check browser console (F12) for errors
2. Verify `NEXT_PUBLIC_API_URL` is correct
3. Test backend is accessible:
   ```bash
   curl https://your-backend.up.railway.app/health
   ```
4. Check frontend logs in Railway
5. Clear browser cache and reload

---

### ❌ "Network Error" when calling API

**Problem:** CORS or incorrect API URL.

**Solution:**
1. Verify `NEXT_PUBLIC_API_URL` in frontend env vars
2. Check backend CORS configuration
3. Ensure `FRONTEND_URL` is set in backend:
   ```bash
   FRONTEND_URL=https://your-frontend.up.railway.app
   ```
4. Check browser console for CORS errors
5. Test API directly: `https://your-backend.up.railway.app/docs`

---

### ❌ "404 Not Found" on page refresh

**Problem:** Next.js routing issue (shouldn't happen with Railway).

**Solution:**
1. Verify Next.js is running in production mode
2. Check `next.config.js` configuration
3. Rebuild frontend service in Railway

---

## 🔗 CORS Issues

### ❌ "Access to fetch blocked by CORS policy"

**Problem:** Backend doesn't allow frontend domain.

**Solution:**
1. Add `FRONTEND_URL` to backend environment variables:
   ```bash
   FRONTEND_URL=https://your-frontend.up.railway.app
   ```
2. Verify `app/main.py` includes CORS middleware
3. Check frontend URL is exactly correct (https://, no trailing slash)
4. Backend will auto-redeploy after env var change
5. Clear browser cache

---

### ❌ CORS works locally but not on Railway

**Problem:** Production CORS config different from local.

**Solution:**
1. Check `APP_ENV=production` in backend
2. Verify `FRONTEND_URL` includes `https://`
3. Review `app/main.py` CORS configuration:
   ```python
   if os.getenv("APP_ENV") == "production":
       origins.append("*")  # Or specific URL
   ```

---

## 🔐 Authentication Issues

### ❌ "Invalid credentials" when logging in

**Problem:** User doesn't exist or password incorrect.

**Solution:**
1. Verify seed data was inserted:
   ```bash
   mysql -h nozomi.proxy.rlwy.net -P 33570 -u root -pekDohXiaRAaEoHDorsgNysuKRgMGEOZv railway -e "SELECT * FROM user_account;"
   ```
2. Check password hashing is working
3. Try creating new user via `/api/auth/register`
4. Verify JWT_SECRET is set in backend

---

### ❌ "Token expired" errors

**Problem:** JWT token expiration.

**Solution:**
1. Check `JWT_EXP_MINUTES` setting (default: 1440 = 24 hours)
2. Login again to get new token
3. Clear localStorage and login again
4. Increase expiration time if needed

---

### ❌ Can't access protected routes

**Problem:** JWT token not sent or invalid.

**Solution:**
1. Check token is stored in localStorage
2. Verify Authorization header is sent:
   ```javascript
   Authorization: Bearer <token>
   ```
3. Check browser console for errors
4. Try logging out and logging in again
5. Verify JWT_SECRET is same across deployments

---

## 🚀 Deployment Issues

### ❌ Railway deployment stuck

**Problem:** Build taking too long.

**Solution:**
1. Check Railway status page: https://railway.app/status
2. Cancel deployment and retry
3. Check build logs for errors
4. Contact Railway support if persists

---

### ❌ Changes not reflecting after push

**Problem:** Railway didn't detect changes or cache issue.

**Solution:**
1. Check Railway detected the push (Deployments tab)
2. Manually trigger redeploy:
   - Go to service → Deployments → Click "Redeploy"
3. Hard refresh browser (Ctrl+Shift+R)
4. Clear CDN cache if using custom domain

---

### ❌ "Root Directory not found"

**Problem:** Incorrect root directory setting.

**Solution:**
1. Go to service → Settings → Root Directory
2. Set exactly:
   - Backend: `hrgsms-backend`
   - Frontend: `hrgsms-frontend`
3. Redeploy

---

### ❌ Environment variables not working

**Problem:** Variables not loaded or typos.

**Solution:**
1. Go to service → Variables tab
2. Verify all required variables are present
3. Check for typos (especially in variable names)
4. Restart service after adding variables
5. Variables are case-sensitive!

---

## 💾 Data Issues

### ❌ No data showing in application

**Problem:** Seed data not inserted.

**Solution:**
1. Check database has data:
   ```bash
   mysql -h nozomi.proxy.rlwy.net -P 33570 -u root -pekDohXiaRAaEoHDorsgNysuKRgMGEOZv railway -e "SELECT COUNT(*) FROM guest;"
   ```
2. Re-run seed data:
   ```bash
   mysql -h nozomi.proxy.rlwy.net -P 33570 -u root -pekDohXiaRAaEoHDorsgNysuKRgMGEOZv railway < hrgsms-db/seed_data.sql
   ```
3. Check backend API returns data: `/api/guests`

---

### ❌ "Foreign key constraint fails"

**Problem:** Trying to insert data in wrong order.

**Solution:**
1. Follow correct order in schema.sql
2. Ensure parent records exist before child records
3. Check seed_data.sql has correct order
4. Disable foreign key checks temporarily:
   ```sql
   SET FOREIGN_KEY_CHECKS=0;
   -- Your INSERT statements
   SET FOREIGN_KEY_CHECKS=1;
   ```

---

## 🔍 Debugging Tips

### View Backend Logs
```
Railway Dashboard → Backend Service → Deployments → View Logs
```

### View Frontend Logs
```
Railway Dashboard → Frontend Service → Deployments → View Logs
```

### Test API Directly
```
Visit: https://your-backend.up.railway.app/docs
Try endpoints in Swagger UI
```

### Check Database
```bash
mysql -h nozomi.proxy.rlwy.net -P 33570 -u root -pekDohXiaRAaEoHDorsgNysuKRgMGEOZv railway
```

### Browser Developer Tools
```
Press F12 → Console tab (check for JavaScript errors)
Press F12 → Network tab (check API calls)
```

---

## 📞 Getting Help

### Before asking for help, gather:
1. ✅ Error message (exact text)
2. ✅ Railway service logs
3. ✅ Browser console errors (if frontend issue)
4. ✅ Steps to reproduce
5. ✅ What you've already tried

### Resources:
- **Railway Discord:** https://discord.gg/railway
- **Railway Docs:** https://docs.railway.app
- **FastAPI Docs:** https://fastapi.tiangolo.com
- **Next.js Docs:** https://nextjs.org/docs

### Common Log Locations:
- Railway: Service → Deployments → Logs
- Browser: F12 → Console
- Local Backend: Terminal output
- Local Frontend: Terminal output

---

## ✅ Verification Checklist

When troubleshooting, verify:

- [ ] Railway services are running (not crashed)
- [ ] Environment variables are set correctly
- [ ] Database is initialized with data
- [ ] Root directories are correct
- [ ] API endpoint is accessible
- [ ] CORS is configured
- [ ] Browser cache is cleared
- [ ] Logs don't show errors

---

## 🎯 Quick Fixes

**90% of issues are solved by:**

1. ✅ Checking environment variables
2. ✅ Viewing Railway logs
3. ✅ Verifying database connection
4. ✅ Clearing browser cache
5. ✅ Redeploying service

---

**Still stuck?** Check the specific guide for your issue or reach out to Railway support!
