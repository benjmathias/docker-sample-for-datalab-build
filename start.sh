#!/bin/bash
# Simple Jupyter start script for ESA Datalabs

# Extract datalab ID from hostname if variables are empty
HOSTNAME_ID=$(hostname | sed 's/datalab-\([^-]*\).*/\1/')

# Use fallback values if variables are empty
JUPYTER_PORT=${MAIN_PORT:-${IF_main_port:-10000}}
JUPYTER_ID=${MAIN_ID:-${IF_main_id:-$HOSTNAME_ID}}

echo "Starting Jupyter Lab on port $JUPYTER_PORT"
echo "Interface ID: $JUPYTER_ID"
echo "Hostname: $(hostname)"
echo "User: $USER"

echo "=== ALL ENVIRONMENT VARIABLES ==="
env | grep -E "(ID|PORT|MAIN|IF_|DATALAB)" | sort

echo "=== COMPUTED VALUES ==="
echo "  HOSTNAME_ID=$HOSTNAME_ID"
echo "  JUPYTER_PORT=$JUPYTER_PORT"
echo "  JUPYTER_ID=$JUPYTER_ID"

# Start Jupyter Lab with correct SCIAPPS path configuration
exec jupyter lab \
  --ip=0.0.0.0 \
  --port=$JUPYTER_PORT \
  --no-browser \
  --allow-root \
  --ServerApp.token='' \
  --ServerApp.password='' \
  --ServerApp.base_url="/datalabs/$JUPYTER_ID" 