#!/bin/bash
# Simple Jupyter start script for ESA Datalabs

echo "Starting Jupyter Lab on port $IF_main_port"
echo "Interface ID: $IF_main_id"
echo "User: $USER"

# Start Jupyter Lab with correct SCIAPPS path configuration
exec jupyter lab \
  --ip=0.0.0.0 \
  --port=$IF_main_port \
  --no-browser \
  --allow-root \
  --ServerApp.token='' \
  --ServerApp.password='' \
  --ServerApp.base_url="/datalabs/$IF_main_id" 