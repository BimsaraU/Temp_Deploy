# HRGSMS Railway Database Initialization

This guide helps you initialize your Railway MySQL database with the HRGSMS schema.

## Your Railway MySQL Connection Details

```
Host: nozomi.proxy.rlwy.net
Port: 33570
User: root
Password: ekDohXiaRAaEoHDorsgNysuKRgMGEOZv
Database: railway
```

**Connection String:**
```
mysql://root:ekDohXiaRAaEoHDorsgNysuKRgMGEOZv@nozomi.proxy.rlwy.net:33570/railway
```

## Quick Start - Automated Initialization

### Option 1: Windows (Easiest)

1. Open Command Prompt or PowerShell
2. Navigate to the `hrgsms-db` folder:
   ```cmd
   cd hrgsms-db
   ```
3. Run the initialization script:
   ```cmd
   initialize_railway_db.bat
   ```

### Option 2: Linux/Mac/Git Bash

1. Open Terminal or Git Bash
2. Navigate to the `hrgsms-db` folder:
   ```bash
   cd hrgsms-db
   ```
3. Make the script executable and run it:
   ```bash
   chmod +x initialize_railway_db.sh
   ./initialize_railway_db.sh
   ```

The script will automatically:
- Test the database connection
- Create all tables (schema)
- Create stored procedures
- Create functions
- Create triggers
- Insert seed data
- Verify the installation

## Manual Initialization (Alternative)

If you prefer to run commands manually:

### Step 1: Connect to Railway MySQL

```bash
mysql -h nozomi.proxy.rlwy.net -P 33570 -u root -pekDohXiaRAaEoHDorsgNysuKRgMGEOZv railway
```

Or use MySQL Workbench with these connection details.

### Step 2: Execute SQL Files

Run these commands in order:

```bash
# 1. Create schema
mysql -h nozomi.proxy.rlwy.net -P 33570 -u root -pekDohXiaRAaEoHDorsgNysuKRgMGEOZv railway < schema.sql

# 2. Create procedures
mysql -h nozomi.proxy.rlwy.net -P 33570 -u root -pekDohXiaRAaEoHDorsgNysuKRgMGEOZv railway < procedures.sql

# 3. Create functions
mysql -h nozomi.proxy.rlwy.net -P 33570 -u root -pekDohXiaRAaEoHDorsgNysuKRgMGEOZv railway < functions.sql

# 4. Create triggers
mysql -h nozomi.proxy.rlwy.net -P 33570 -u root -pekDohXiaRAaEoHDorsgNysuKRgMGEOZv railway < triggers.sql

# 5. Insert seed data
mysql -h nozomi.proxy.rlwy.net -P 33570 -u root -pekDohXiaRAaEoHDorsgNysuKRgMGEOZv railway < seed_data.sql
```

## Verify Database Installation

Connect to your database and check tables:

```bash
mysql -h nozomi.proxy.rlwy.net -P 33570 -u root -pekDohXiaRAaEoHDorsgNysuKRgMGEOZv railway -e "SHOW TABLES;"
```

You should see tables like: `booking`, `branch`, `chargeble_service`, `discount`, `guest`, etc.

## Configure Your Railway Backend Service

After database initialization, configure your **Backend Service** in Railway with these environment variables:

### Railway Backend Environment Variables

```bash
# Database Configuration
DB_HOST=nozomi.proxy.rlwy.net
DB_PORT=33570
DB_USER=root
DB_PASSWORD=ekDohXiaRAaEoHDorsgNysuKRgMGEOZv
DB_NAME=railway

# JWT Configuration
JWT_SECRET=your-super-secret-jwt-key-change-this-now
JWT_ALGORITHM=HS256
JWT_EXP_MINUTES=1440

# Application Environment
APP_ENV=production
```

**Important:** Change `JWT_SECRET` to a strong random string!

## Troubleshooting

### "mysql command not found"

**Install MySQL Client:**

- **Windows:** 
  ```cmd
  winget install Oracle.MySQL
  ```
  Or download from: https://dev.mysql.com/downloads/mysql/

- **Mac:**
  ```bash
  brew install mysql-client
  ```

- **Linux (Ubuntu/Debian):**
  ```bash
  sudo apt-get update
  sudo apt-get install mysql-client
  ```

### "Access denied" Error

- Verify you're using the correct password (no spaces)
- Check that Railway MySQL service is running
- Try connecting via Railway's web interface first

### Connection Timeout

- Check your internet connection
- Verify Railway MySQL service status
- Try adding `--protocol=TCP` flag:
  ```bash
  mysql -h nozomi.proxy.rlwy.net -P 33570 -u root -pekDohXiaRAaEoHDorsgNysuKRgMGEOZv --protocol=TCP railway
  ```

### Tables Already Exist Error

If tables already exist, drop them first:

```sql
DROP DATABASE railway;
CREATE DATABASE railway;
USE railway;
```

Then run the initialization scripts again.

## Using Railway Web Interface (No MySQL Client Needed)

1. Go to your Railway project
2. Click on your **MySQL** service
3. Click **"Data"** tab
4. Click **"Query"** button
5. Copy and paste the contents of each SQL file **one at a time** in this order:
   - `schema.sql`
   - `procedures.sql`
   - `functions.sql`
   - `triggers.sql`
   - `seed_data.sql`
6. Click **"Run"** after pasting each file

## Next Steps After Database Setup

1. ✅ Database initialized
2. 🚀 Deploy Backend:
   - Set root directory to `hrgsms-backend`
   - Add environment variables (see above)
   - Generate domain
3. 🚀 Deploy Frontend:
   - Set root directory to `hrgsms-frontend`
   - Add `NEXT_PUBLIC_API_URL` pointing to backend
   - Generate domain
4. 🎉 Test your application!

## Security Reminder

⚠️ **Important Security Notes:**

1. Never commit these credentials to GitHub
2. Rotate the MySQL password regularly in Railway
3. Use a strong, unique JWT_SECRET
4. Enable Railway's private networking if available
5. Monitor Railway logs for suspicious activity

## Support

If you encounter issues:
- Check Railway service logs
- Verify all SQL files are in the `hrgsms-db` folder
- Ensure MySQL client version is 5.7+ or 8.0+
- Contact Railway support via Discord: https://discord.gg/railway

---

**Database Status:** Ready for initialization ✅
