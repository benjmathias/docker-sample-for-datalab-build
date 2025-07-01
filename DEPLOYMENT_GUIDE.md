# Deployment Guide

## Overview

This guide provides comprehensive documentation for deploying the Test Lab application in various environments including local development, Docker containers, and ESA Datalabs infrastructure.

## Table of Contents

1. [Shell Scripts Documentation](#shell-scripts-documentation)
2. [Docker Configuration](#docker-configuration)
3. [Environment Setup](#environment-setup)
4. [Build Process](#build-process)
5. [Runtime Configuration](#runtime-configuration)
6. [Troubleshooting](#troubleshooting)

## Shell Scripts Documentation

### `src/main.sh`

**Purpose**: Entry point script for ESA Datalabs environment

**Location**: `/opt/datalab/start.sh` (copied during Docker build)

**Function**: 
- Sets up the runtime environment for ESA Datalabs
- Configures port from environment variables
- Starts the Python application

**Usage**:
```bash
./src/main.sh
```

**Environment Variables Used**:
- `MAIN_PORT`: Sets the application port (default: 8000)

**Script Breakdown**:
```bash
#!/bin/bash
# This is the start.sh script called by the ESA Datalabs infrastructure
# It runs as the proper user via the run.sh infrastructure

# Set up environment
export PORT=${MAIN_PORT:-8000}

# Start the Python application
echo "Starting custom datalab application on port $PORT"
cd /opt/datalab
exec python3 -m app
```

**Key Features**:
- Uses `exec` to replace the shell process with Python
- Defaults to port 8000 if `MAIN_PORT` is not set
- Changes to the correct working directory before starting the app
- Provides informative startup message

---

### `build.sh`

**Purpose**: Build script for Docker image creation

**Usage**:
```bash
./build.sh
```

**Script Content**:
```bash
#!/bin/bash
docker build -t test-lab .
```

**Function**:
- Builds Docker image with tag `test-lab`
- Uses current directory as build context

---

### `run.sh`

**Purpose**: Run script for starting the Docker container

**Usage**:
```bash
./run.sh
```

**Script Content**:
```bash
#!/bin/bash
docker run -p 10000:10000 -p 8000:8000 test-lab
```

**Function**:
- Runs the Docker container
- Maps both ports 10000 and 8000 to host
- Uses the `test-lab` image

---

### `init.sh`

**Purpose**: Initialization script for environment setup

**Usage**:
```bash
./init.sh
```

**Script Content**:
```bash
#!/bin/bash
# Initialization script
echo "Initializing environment..."
chmod +x build.sh run.sh src/main.sh
echo "Permissions set for scripts"
echo "Ready to build and run"
```

**Function**:
- Sets executable permissions on all scripts
- Provides setup confirmation messages
- Prepares the environment for building and running

## Docker Configuration

### Dockerfile Analysis

**Base Image**: `scidockreg.esac.esa.int:62530/datalabs/datalabs_base:0.8.0-stable-20.04`

**Multi-stage Build Process**:

#### Stage 1: Environment Setup
```dockerfile
ARG JL_BASE_VERSION=0.8.0-stable
ARG REGISTRY=scidockreg.esac.esa.int:62530
FROM ${REGISTRY}/datalabs/datalabs_base:${JL_BASE_VERSION}-20.04
ENV DEBIAN_FRONTEND noninteractive
LABEL maintainer="nmaltsev@argans.eu"
```

#### Stage 2: Port Configuration
```dockerfile
EXPOSE 10000
EXPOSE 8000
ARG WORK_DIR="/opt/datalab"
WORKDIR $WORK_DIR
```

#### Stage 3: System Dependencies
```dockerfile
RUN apt-get update \
  && apt-get install -y --no-install-recommends python3-pip=20.0.2-5ubuntu1.11 \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
```

#### Stage 4: Python Dependencies
```dockerfile
RUN pip3 install --no-cache-dir aiohttp==3.7.4
```

#### Stage 5: Application Setup
```dockerfile
COPY src/app.py ./
COPY src/main.sh ./start.sh
RUN chmod +x ./start.sh
RUN chmod -R 755 $WORK_DIR
```

#### Stage 6: Runtime Configuration
```dockerfile
CMD ["/sbin/tini", "--", "/.datalab/run.sh"]
```

### Docker Build Arguments

| Argument | Default Value | Description |
|----------|---------------|-------------|
| `JL_BASE_VERSION` | `0.8.0-stable` | Version of the base Datalabs image |
| `REGISTRY` | `scidockreg.esac.esa.int:62530` | Docker registry URL |
| `WORK_DIR` | `/opt/datalab` | Working directory inside container |

### Docker Build Example

```bash
# Basic build
docker build -t test-lab .

# Build with custom arguments
docker build \
  --build-arg JL_BASE_VERSION=0.9.0-stable \
  --build-arg WORK_DIR=/custom/path \
  -t test-lab:custom .
```

## Environment Setup

### Local Development Environment

**Prerequisites**:
```bash
# Install Python 3 and pip
sudo apt-get update
sudo apt-get install python3 python3-pip

# Install application dependencies
pip3 install aiohttp==3.7.4
```

**Setup Process**:
```bash
# 1. Clone/download the project
cd /path/to/project

# 2. Initialize environment
./init.sh

# 3. Run locally
cd src
python3 app.py
```

### Docker Development Environment

**Setup Process**:
```bash
# 1. Initialize environment
./init.sh

# 2. Build Docker image
./build.sh

# 3. Run Docker container
./run.sh
```

### ESA Datalabs Environment

**Automatic Setup**:
The ESA Datalabs infrastructure handles the setup automatically:

1. Builds the Docker image using the provided Dockerfile
2. Runs the container with the standard datalab entrypoint
3. Executes `/.datalab/run.sh` which calls our `start.sh` script
4. Sets appropriate environment variables

**Manual Setup** (if needed):
```bash
# Build for ESA Datalabs
docker build -t datalab-app .

# Run with ESA Datalabs configuration
docker run -e MAIN_PORT=8000 -p 8000:8000 datalab-app
```

## Build Process

### Complete Build Workflow

```bash
#!/bin/bash
# Complete build and test workflow

echo "Step 1: Initialize environment"
./init.sh

echo "Step 2: Build Docker image"
./build.sh

echo "Step 3: Test the build"
docker run --rm -d --name test-lab-container -p 10000:10000 test-lab

# Wait for startup
sleep 5

echo "Step 4: Health check"
if curl -f http://localhost:10000/ > /dev/null 2>&1; then
    echo "✓ Build successful - application is running"
else
    echo "✗ Build failed - application is not responding"
fi

echo "Step 5: Cleanup"
docker stop test-lab-container

echo "Build process completed"
```

### Build Verification

**Image Inspection**:
```bash
# Check image details
docker image inspect test-lab

# Check image size
docker images test-lab

# Check image layers
docker history test-lab
```

**Container Testing**:
```bash
# Run interactive container for debugging
docker run -it --rm test-lab /bin/bash

# Check file permissions
docker run --rm test-lab ls -la /opt/datalab/

# Check Python installation
docker run --rm test-lab python3 --version

# Check aiohttp installation
docker run --rm test-lab python3 -c "import aiohttp; print(aiohttp.__version__)"
```

## Runtime Configuration

### Port Configuration

**Default Ports**:
- **Development**: 10000
- **ESA Datalabs**: 8000

**Custom Port Configuration**:
```bash
# Local development with custom port
export PORT=9000
python3 src/app.py

# Docker with custom port
docker run -e PORT=9000 -p 9000:9000 test-lab

# ESA Datalabs with custom port
export MAIN_PORT=9000
./src/main.sh
```

### Environment Variables

| Variable | Purpose | Default | Example |
|----------|---------|---------|---------|
| `PORT` | Application port | 10000 | `export PORT=8080` |
| `MAIN_PORT` | ESA Datalabs port | 8000 | `export MAIN_PORT=9000` |
| `WORK_DIR` | Working directory | `/opt/datalab` | Docker build arg only |

### Logging Configuration

**Default Logging**:
```python
import logging
log = logging.getLogger(__name__)
```

**Enable Debug Logging**:
```bash
# Set logging level via environment
export PYTHONPATH=/opt/datalab
export LOG_LEVEL=DEBUG

# Or modify the application
python3 -c "
import logging
logging.basicConfig(level=logging.DEBUG)
exec(open('app.py').read())
"
```

## Troubleshooting

### Common Issues

#### Port Already in Use
**Symptom**: Application fails to start with port binding error

**Solution**:
```bash
# Check what's using the port
sudo netstat -tulpn | grep :10000

# Kill the process using the port
sudo kill -9 <PID>

# Or use a different port
export PORT=10001
python3 src/app.py
```

#### Permission Denied
**Symptom**: Scripts cannot be executed

**Solution**:
```bash
# Fix script permissions
chmod +x build.sh run.sh src/main.sh init.sh

# Or run init.sh
./init.sh
```

#### Docker Build Fails
**Symptom**: Docker build fails with dependency errors

**Solutions**:
```bash
# Clear Docker cache
docker system prune -f

# Build with no cache
docker build --no-cache -t test-lab .

# Check base image availability
docker pull scidockreg.esac.esa.int:62530/datalabs/datalabs_base:0.8.0-stable-20.04
```

#### Application Not Responding
**Symptom**: Application starts but doesn't respond to requests

**Debugging Steps**:
```bash
# Check if application is running
docker ps

# Check application logs
docker logs <container_id>

# Check if ports are mapped correctly
docker port <container_id>

# Test with curl
curl -v http://localhost:10000/

# Check inside container
docker exec -it <container_id> /bin/bash
```

### Debug Mode

**Enable Debug Mode**:
```bash
# Run with debug output
python3 -u src/app.py

# Docker debug mode
docker run -it --rm -p 10000:10000 test-lab /bin/bash
# Then inside container:
cd /opt/datalab
python3 -u app.py
```

### Health Checks

**Application Health Check**:
```bash
#!/bin/bash
# health_check.sh

check_health() {
    local port=${1:-10000}
    local max_attempts=30
    local attempt=1
    
    echo "Checking application health on port $port..."
    
    while [ $attempt -le $max_attempts ]; do
        if curl -f http://localhost:$port/ > /dev/null 2>&1; then
            echo "✓ Application is healthy (attempt $attempt)"
            return 0
        fi
        
        echo "Attempt $attempt/$max_attempts failed, retrying in 2 seconds..."
        sleep 2
        ((attempt++))
    done
    
    echo "✗ Application health check failed after $max_attempts attempts"
    return 1
}

# Usage
check_health 10000
```

**Docker Health Check**:
```dockerfile
# Add to Dockerfile for health checking
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:${PORT:-10000}/ || exit 1
```

### Performance Monitoring

**Resource Usage**:
```bash
# Monitor Docker container resources
docker stats <container_id>

# Check application memory usage
docker exec <container_id> ps aux | grep python

# Monitor network connections
docker exec <container_id> netstat -tulpn
```

### Log Analysis

**Application Logs**:
```bash
# View real-time logs
docker logs -f <container_id>

# Search for specific log entries
docker logs <container_id> | grep "Test handler"

# Export logs for analysis
docker logs <container_id> > app_logs.txt
```