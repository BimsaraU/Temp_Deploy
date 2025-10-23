#!/bin/bash

# HRGSMS Railway Database Initialization Script
# This script connects to your Railway MySQL database and initializes the schema

echo "================================================"
echo "HRGSMS Railway Database Initialization"
echo "================================================"
echo ""

# Railway MySQL Connection Details
MYSQL_HOST="nozomi.proxy.rlwy.net"
MYSQL_PORT="33570"
MYSQL_USER="root"
MYSQL_PASSWORD="ekDohXiaRAaEoHDorsgNysuKRgMGEOZv"
MYSQL_DATABASE="railway"

echo "Connecting to Railway MySQL Database..."
echo "Host: $MYSQL_HOST"
echo "Port: $MYSQL_PORT"
echo "Database: $MYSQL_DATABASE"
echo ""

# Check if mysql client is installed
if ! command -v mysql &> /dev/null; then
    echo "❌ Error: MySQL client is not installed."
    echo ""
    echo "Please install MySQL client:"
    echo "  - Windows: Download from https://dev.mysql.com/downloads/mysql/"
    echo "  - macOS: brew install mysql-client"
    echo "  - Linux: sudo apt-get install mysql-client"
    exit 1
fi

echo "✅ MySQL client found"
echo ""

# Test connection
echo "Testing database connection..."
mysql -h "$MYSQL_HOST" -P "$MYSQL_PORT" -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -e "SELECT 1;" "$MYSQL_DATABASE" 2>/dev/null

if [ $? -eq 0 ]; then
    echo "✅ Connection successful!"
    echo ""
else
    echo "❌ Connection failed. Please check your credentials."
    exit 1
fi

# Initialize database schema
echo "================================================"
echo "Step 1: Creating database schema..."
echo "================================================"
mysql -h "$MYSQL_HOST" -P "$MYSQL_PORT" -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE" < schema.sql
if [ $? -eq 0 ]; then
    echo "✅ Schema created successfully"
else
    echo "❌ Schema creation failed"
    exit 1
fi
echo ""

# Create procedures
echo "================================================"
echo "Step 2: Creating stored procedures..."
echo "================================================"
mysql -h "$MYSQL_HOST" -P "$MYSQL_PORT" -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE" < procedures.sql
if [ $? -eq 0 ]; then
    echo "✅ Procedures created successfully"
else
    echo "❌ Procedure creation failed"
    exit 1
fi
echo ""

# Create functions
echo "================================================"
echo "Step 3: Creating functions..."
echo "================================================"
mysql -h "$MYSQL_HOST" -P "$MYSQL_PORT" -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE" < functions.sql
if [ $? -eq 0 ]; then
    echo "✅ Functions created successfully"
else
    echo "❌ Function creation failed"
    exit 1
fi
echo ""

# Create triggers
echo "================================================"
echo "Step 4: Creating triggers..."
echo "================================================"
mysql -h "$MYSQL_HOST" -P "$MYSQL_PORT" -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE" < triggers.sql
if [ $? -eq 0 ]; then
    echo "✅ Triggers created successfully"
else
    echo "❌ Trigger creation failed"
    exit 1
fi
echo ""

# Insert seed data
echo "================================================"
echo "Step 5: Inserting seed data..."
echo "================================================"
mysql -h "$MYSQL_HOST" -P "$MYSQL_PORT" -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE" < seed_data.sql
if [ $? -eq 0 ]; then
    echo "✅ Seed data inserted successfully"
else
    echo "❌ Seed data insertion failed"
    exit 1
fi
echo ""

# Verify installation
echo "================================================"
echo "Verifying database installation..."
echo "================================================"
echo ""

echo "Checking tables..."
mysql -h "$MYSQL_HOST" -P "$MYSQL_PORT" -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE" -e "SHOW TABLES;"
echo ""

echo "================================================"
echo "✅ Database initialization completed successfully!"
echo "================================================"
echo ""
echo "Your Railway MySQL database is now ready for use."
echo ""
echo "Connection details for your application:"
echo "  DB_HOST: $MYSQL_HOST"
echo "  DB_PORT: $MYSQL_PORT"
echo "  DB_USER: $MYSQL_USER"
echo "  DB_NAME: $MYSQL_DATABASE"
echo ""
echo "Next steps:"
echo "  1. Deploy your backend with these database credentials"
echo "  2. Deploy your frontend"
echo "  3. Test your application"
echo ""
