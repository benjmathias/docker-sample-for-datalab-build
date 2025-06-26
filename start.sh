#!/bin/bash
# Simple Jupyter start script for ESA Datalabs

# Use fallback values if variables are empty
JUPYTER_PORT=${MAIN_PORT:-${IF_main_port:-10000}}
JUPYTER_ID=${MAIN_ID:-${IF_main_id:-"default"}}

echo "Starting Jupyter Lab on port $JUPYTER_PORT"
echo "Interface ID: $JUPYTER_ID"
echo "User: $USER"
echo "Available environment variables:"
echo "  MAIN_PORT=$MAIN_PORT"
echo "  MAIN_ID=$MAIN_ID"
echo "  IF_main_port=$IF_main_port"
echo "  IF_main_id=$IF_main_id"

# Start Jupyter Lab with correct SCIAPPS path configuration
exec jupyter lab \
  --ip=0.0.0.0 \
  --port=$JUPYTER_PORT \
  --no-browser \
  --allow-root \
  --ServerApp.token='' \
  --ServerApp.password='' \
  --ServerApp.base_url="/datalabs/$JUPYTER_ID" 