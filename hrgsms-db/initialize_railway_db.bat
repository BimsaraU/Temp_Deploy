@echo off
REM HRGSMS Railway Database Initialization Script for Windows
REM This script connects to your Railway MySQL database and initializes the schema

echo ================================================
echo HRGSMS Railway Database Initialization
echo ================================================
echo.

REM Railway MySQL Connection Details
set MYSQL_HOST=nozomi.proxy.rlwy.net
set MYSQL_PORT=33570
set MYSQL_USER=root
set MYSQL_PASSWORD=ekDohXiaRAaEoHDorsgNysuKRgMGEOZv
set MYSQL_DATABASE=railway

echo Connecting to Railway MySQL Database...
echo Host: %MYSQL_HOST%
echo Port: %MYSQL_PORT%
echo Database: %MYSQL_DATABASE%
echo.

REM Check if mysql client is installed
where mysql >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo Error: MySQL client is not installed.
    echo.
    echo Please install MySQL client:
    echo   - Download from https://dev.mysql.com/downloads/mysql/
    echo   - Or install via: winget install Oracle.MySQL
    pause
    exit /b 1
)

echo MySQL client found
echo.

REM Test connection
echo Testing database connection...
mysql -h %MYSQL_HOST% -P %MYSQL_PORT% -u %MYSQL_USER% -p%MYSQL_PASSWORD% -e "SELECT 1;" %MYSQL_DATABASE% 2>nul

if %ERRORLEVEL% EQU 0 (
    echo Connection successful!
    echo.
) else (
    echo Connection failed. Please check your credentials.
    pause
    exit /b 1
)

REM Initialize database schema
echo ================================================
echo Step 1: Creating database schema...
echo ================================================
mysql -h %MYSQL_HOST% -P %MYSQL_PORT% -u %MYSQL_USER% -p%MYSQL_PASSWORD% %MYSQL_DATABASE% < schema.sql
if %ERRORLEVEL% EQU 0 (
    echo Schema created successfully
) else (
    echo Schema creation failed
    pause
    exit /b 1
)
echo.

REM Create procedures
echo ================================================
echo Step 2: Creating stored procedures...
echo ================================================
mysql -h %MYSQL_HOST% -P %MYSQL_PORT% -u %MYSQL_USER% -p%MYSQL_PASSWORD% %MYSQL_DATABASE% < procedures.sql
if %ERRORLEVEL% EQU 0 (
    echo Procedures created successfully
) else (
    echo Procedure creation failed
    pause
    exit /b 1
)
echo.

REM Create functions
echo ================================================
echo Step 3: Creating functions...
echo ================================================
mysql -h %MYSQL_HOST% -P %MYSQL_PORT% -u %MYSQL_USER% -p%MYSQL_PASSWORD% %MYSQL_DATABASE% < functions.sql
if %ERRORLEVEL% EQU 0 (
    echo Functions created successfully
) else (
    echo Function creation failed
    pause
    exit /b 1
)
echo.

REM Create triggers
echo ================================================
echo Step 4: Creating triggers...
echo ================================================
mysql -h %MYSQL_HOST% -P %MYSQL_PORT% -u %MYSQL_USER% -p%MYSQL_PASSWORD% %MYSQL_DATABASE% < triggers.sql
if %ERRORLEVEL% EQU 0 (
    echo Triggers created successfully
) else (
    echo Trigger creation failed
    pause
    exit /b 1
)
echo.

REM Insert seed data
echo ================================================
echo Step 5: Inserting seed data...
echo ================================================
mysql -h %MYSQL_HOST% -P %MYSQL_PORT% -u %MYSQL_USER% -p%MYSQL_PASSWORD% %MYSQL_DATABASE% < seed_data.sql
if %ERRORLEVEL% EQU 0 (
    echo Seed data inserted successfully
) else (
    echo Seed data insertion failed
    pause
    exit /b 1
)
echo.

REM Verify installation
echo ================================================
echo Verifying database installation...
echo ================================================
echo.

echo Checking tables...
mysql -h %MYSQL_HOST% -P %MYSQL_PORT% -u %MYSQL_USER% -p%MYSQL_PASSWORD% %MYSQL_DATABASE% -e "SHOW TABLES;"
echo.

echo ================================================
echo Database initialization completed successfully!
echo ================================================
echo.
echo Your Railway MySQL database is now ready for use.
echo.
echo Connection details for your application:
echo   DB_HOST: %MYSQL_HOST%
echo   DB_PORT: %MYSQL_PORT%
echo   DB_USER: %MYSQL_USER%
echo   DB_NAME: %MYSQL_DATABASE%
echo.
echo Next steps:
echo   1. Deploy your backend with these database credentials
echo   2. Deploy your frontend
echo   3. Test your application
echo.
pause
