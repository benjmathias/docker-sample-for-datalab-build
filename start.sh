#!/bin/bash
# Simple Jupyter start script for ESA Datalabs

echo "Starting Jupyter Lab on port $MAIN_PORT"
echo "Datalab ID: $MAIN_ID"

# Start Jupyter Lab with basic configuration
exec jupyter lab \
  --ip=0.0.0.0 \
  --port=$MAIN_PORT \
  --no-browser \
  --allow-root \
  --NotebookApp.token='' \
  --NotebookApp.password='' \
  --NotebookApp.base_url="/datalabs/$MAIN_ID" 