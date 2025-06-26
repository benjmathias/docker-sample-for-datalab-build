#!/bin/bash
# This is the start.sh script called by the ESA Datalabs infrastructure
# It runs as the proper user via the run.sh infrastructure

# Set up environment
export PORT=${MAIN_PORT:-8000}

# Start the Python application
echo "Starting custom datalab application on port $PORT"
cd /opt/datalab
exec python3 -m app
