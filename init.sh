#!/bin/sh
# Note: User creation is now handled by the datalab init container infrastructure
# This script just runs the main application

# Run the main application script
exec ./main.sh
