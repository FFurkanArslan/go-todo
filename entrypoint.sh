#!/bin/sh

# Set environment variables from Docker environment
export DB_HOST=${DB_HOST}
export DB_USER=${DB_USER}
export DB_PASS=${DB_PASS}
export DB_NAME=${DB_NAME}
export PORT=${PORT}

# Run the main application
exec ./main
