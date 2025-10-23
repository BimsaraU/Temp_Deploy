# HRGSMS Railway Deployment Checklist

Use this checklist to ensure a smooth deployment to Railway.

## Pre-Deployment Setup

### ✅ Database Initialization

- [ ] MySQL client installed on your local machine
- [ ] Database connection tested successfully
- [ ] Navigated to `hrgsms-db` folder
- [ ] Ran initialization script:
  - Windows: `initialize_railway_db.bat`
  - Linux/Mac: `./initialize_railway_db.sh`
- [ ] Verified tables created: `SHOW TABLES;` shows all tables
- [ ] Seed data inserted successfully

**Database Connection Details:**
```
Host: nozomi.proxy.rlwy.net
Port: 33570
User: root
Database: railway
```

---

## Backend Service Deployment

### ✅ Backend Setup in Railway

- [ ] Created new service from GitHub repo
- [ ] Set **Root Directory**: `hrgsms-backend`
- [ ] Railway detected Dockerfile

### ✅ Backend Environment Variables

Add these in Railway Backend Service → Variables tab:

- [ ] `DB_HOST=nozomi.proxy.rlwy.net`
- [ ] `DB_PORT=33570`
- [ ] `DB_USER=root`
- [ ] `DB_PASSWORD=ekDohXiaRAaEoHDorsgNysuKRgMGEOZv`
- [ ] `DB_NAME=railway`
- [ ] `JWT_SECRET=` (Generated secure 32+ character string)
- [ ] `JWT_ALGORITHM=HS256`
- [ ] `JWT_EXP_MINUTES=1440`
- [ ] `APP_ENV=production`

**Generate JWT_SECRET:**
```bash
openssl rand -hex 32
# OR
python -c "import secrets; print(secrets.token_hex(32))"
```

### ✅ Backend Domain

- [ ] Build completed successfully
- [ ] Generated public domain (Settings → Networking → Generate Domain)
- [ ] Copied backend URL: `https://_____.up.railway.app`
- [ ] Tested health endpoint: `https://your-backend.up.railway.app/health`
- [ ] Tested API docs: `https://your-backend.up.railway.app/docs`

**My Backend URL:** _________________________________

---

## Frontend Service Deployment

### ✅ Frontend Setup in Railway

- [ ] Created new service from GitHub repo
- [ ] Set **Root Directory**: `hrgsms-frontend`
- [ ] Railway detected Dockerfile

### ✅ Frontend Environment Variables

Add these in Railway Frontend Service → Variables tab:

- [ ] `NEXT_PUBLIC_API_URL=` (Your backend Railway URL)
- [ ] `NODE_ENV=production`

### ✅ Frontend Domain

- [ ] Build completed successfully
- [ ] Generated public domain (Settings → Networking → Generate Domain)
- [ ] Copied frontend URL: `https://_____.up.railway.app`
- [ ] Frontend loads successfully

**My Frontend URL:** _________________________________

---

## Final Configuration

### ✅ Update Backend CORS

Go back to Backend Service → Variables and add:

- [ ] `FRONTEND_URL=` (Your frontend Railway URL)
- [ ] Backend redeployed automatically
- [ ] Verified frontend can communicate with backend

---

## Testing & Verification

### ✅ Backend Tests

- [ ] Health check responds: `curl https://your-backend.up.railway.app/health`
- [ ] API documentation loads: `https://your-backend.up.railway.app/docs`
- [ ] Database connection verified in health check response

### ✅ Frontend Tests

- [ ] Frontend loads without errors
- [ ] Login page accessible
- [ ] Can create new account (register)
- [ ] Can login with test credentials
- [ ] Dashboard loads after login
- [ ] Can navigate between pages
- [ ] No CORS errors in browser console

### ✅ Integration Tests

- [ ] Login functionality works
- [ ] Can create new guest
- [ ] Can create new reservation
- [ ] Can view rooms
- [ ] Can manage services
- [ ] Can process payments
- [ ] Reports load correctly

---

## Post-Deployment

### ✅ Security

- [ ] JWT_SECRET is strong and unique (32+ characters)
- [ ] Database credentials not committed to Git
- [ ] `.env` and `.env.railway` in `.gitignore`
- [ ] 2FA enabled on Railway account
- [ ] Reviewed who has access to Railway project

### ✅ Monitoring

- [ ] Set up Railway notifications
- [ ] Bookmarked Railway dashboard
- [ ] Know how to access logs (Deployments → View Logs)
- [ ] Understand Railway metrics (Metrics tab)

### ✅ Documentation

- [ ] Saved backend URL for team
- [ ] Saved frontend URL for team
- [ ] Documented any custom configurations
- [ ] Updated project README if needed

### ✅ Backup

- [ ] Documented database backup procedure
- [ ] Know how to export database:
  ```bash
  mysqldump -h nozomi.proxy.rlwy.net -P 33570 -u root -pekDohXiaRAaEoHDorsgNysuKRgMGEOZv railway > backup.sql
  ```
- [ ] Scheduled regular backups (if applicable)

---

## Troubleshooting Reference

### Backend Issues

**Can't connect to database:**
- Check environment variables are exactly correct
- Verify MySQL service is running
- Check Railway backend logs

**Build fails:**
- Check Railway build logs
- Verify Dockerfile exists in `hrgsms-backend/`
- Check requirements.txt has all dependencies

### Frontend Issues

**Can't reach backend:**
- Verify NEXT_PUBLIC_API_URL is correct
- Check backend is running
- Look for CORS errors in browser console

**Build fails:**
- Check Railway build logs
- Verify Dockerfile exists in `hrgsms-frontend/`
- Check package.json has all dependencies

### CORS Errors

- Verify FRONTEND_URL is set in backend environment variables
- Check frontend URL matches exactly (including https://)
- Backend should redeploy after adding FRONTEND_URL

---

## Success Criteria

Your deployment is successful when:

✅ Database has all tables and seed data  
✅ Backend health check returns "healthy"  
✅ Backend API docs load  
✅ Frontend loads without errors  
✅ Can login and access all features  
✅ No CORS errors in browser console  
✅ All CRUD operations work (Create, Read, Update, Delete)  

---

## Quick Commands Reference

```bash
# Test database
mysql -h nozomi.proxy.rlwy.net -P 33570 -u root -pekDohXiaRAaEoHDorsgNysuKRgMGEOZv railway

# Test backend
curl https://your-backend.up.railway.app/health

# Generate JWT secret
openssl rand -hex 32

# Backup database
mysqldump -h nozomi.proxy.rlwy.net -P 33570 -u root -pekDohXiaRAaEoHDorsgNysuKRgMGEOZv railway > backup.sql

# View Railway logs (if Railway CLI installed)
railway logs
```

---

## Support Resources

- **Railway Docs:** https://docs.railway.app
- **Railway Discord:** https://discord.gg/railway
- **Project Docs:** 
  - `RAILWAY_ENV_SETUP.md` - Your specific setup
  - `RAILWAY_QUICKSTART.md` - Quick guide
  - `RAILWAY_DEPLOYMENT.md` - Full guide
  - `RAILWAY_QUICK_REFERENCE.txt` - Quick reference card

---

## Deployment Complete! 🎉

**Application URLs:**
- Frontend: https://___________________.up.railway.app
- Backend:  https://___________________.up.railway.app
- API Docs: https://___________________.up.railway.app/docs

**Deployed on:** _______________
**Deployed by:** _______________

**Notes:**
_________________________________________________________________
_________________________________________________________________
_________________________________________________________________
