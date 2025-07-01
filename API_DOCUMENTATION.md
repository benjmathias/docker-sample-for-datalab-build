# API Documentation

## Project Overview

**Test Lab** is a simple web application built with Python's aiohttp framework. It provides a basic multi-page web interface with navigation between different test pages.

- **Title**: Test bmathias
- **Description**: This lab is a simple lab for testing purposes
- **Language**: Python 3 with aiohttp
- **Port**: Configurable (default: 10000, ESA Datalabs: 8000)
- **Framework**: aiohttp 3.7.4

## Table of Contents

1. [Web Application API](#web-application-api)
2. [Handler Functions](#handler-functions)
3. [Configuration](#configuration)
4. [Deployment](#deployment)
5. [Usage Examples](#usage-examples)

## Web Application API

### Base URL
- **Development**: `http://localhost:10000`
- **ESA Datalabs**: `http://localhost:8000`

### Endpoints

#### `GET /`
**Description**: Main index page with navigation links

**Response**: 
- **Content-Type**: `text/html`
- **Status Code**: 200

**Response Body**:
```html
<html>
    <head>
        <title>Test lab</title>
        <meta charset="utf-8">
    </head>
    <body>
        <h1>Test lab</h1>
        <a href="/page1">Page1</a><br>
        <a href="./page2">Page2</a>
    </body>
<html>
```

**Example**:
```bash
curl http://localhost:10000/
```

---

#### `GET /page1`
**Description**: First test page with navigation to homepage and page3

**Response**: 
- **Content-Type**: `text/html`
- **Status Code**: 200

**Response Body**:
```html
<html>
    <head>
        <title>Test page</title>
        <meta charset="utf-8">
    </head>
    <body>
        <h1>Test page</h1>
        <a href="/">Homepage</a><br/><a href="/page3">Page3</a>
    </body>
<html>
```

**Example**:
```bash
curl http://localhost:10000/page1
```

---

#### `GET /page2`
**Description**: Second test page demonstrating relative path navigation

**Response**: 
- **Content-Type**: `text/html`
- **Status Code**: 200

**Response Body**:
```html
<html>
    <head>
        <title>Page with relative paths</title>
        <meta charset="utf-8">
    </head>
    <body>
        <h1>Test page</h1>
        <a href="./">Back</a>
    </body>
<html>
```

**Example**:
```bash
curl http://localhost:10000/page2
```

---

#### `GET /page3`
**Description**: Third test page with navigation back to homepage

**Response**: 
- **Content-Type**: `text/html`
- **Status Code**: 200

**Response Body**:
```html
<html>
    <head>
        <title>Test page</title>
        <meta charset="utf-8">
    </head>
    <body>
        <h1>Test page</h1>
        <a href="/">Homepage</a>
    </body>
<html>
```

**Example**:
```bash
curl http://localhost:10000/page3
```

## Handler Functions

### `index_handler(request)`
**Description**: Handles requests to the root path (`/`)

**Parameters**:
- `request` (aiohttp.web.Request): The incoming HTTP request object

**Returns**: 
- `aiohttp.web.Response`: HTML response with the main index page

**Logging**: Logs '[Index handler]' at INFO level

**Example Usage**:
```python
from aiohttp import web

# This handler is automatically called when accessing "/"
# No direct usage required - handled by aiohttp routing
```

---

### `test1_handler(request)`
**Description**: Handles requests to `/page1`

**Parameters**:
- `request` (aiohttp.web.Request): The incoming HTTP request object

**Returns**: 
- `aiohttp.web.Response`: HTML response with test page 1 content

**Logging**: Logs '[Test handler]' at INFO level

**Example Usage**:
```python
from aiohttp import web

# This handler is automatically called when accessing "/page1"
# No direct usage required - handled by aiohttp routing
```

---

### `test2_handler(request)`
**Description**: Handles requests to `/page2`

**Parameters**:
- `request` (aiohttp.web.Request): The incoming HTTP request object

**Returns**: 
- `aiohttp.web.Response`: HTML response with test page 2 content (demonstrates relative paths)

**Logging**: Logs '[Test handler]' at INFO level

**Example Usage**:
```python
from aiohttp import web

# This handler is automatically called when accessing "/page2"
# No direct usage required - handled by aiohttp routing
```

---

### `test3_handler(request)`
**Description**: Handles requests to `/page3`

**Parameters**:
- `request` (aiohttp.web.Request): The incoming HTTP request object

**Returns**: 
- `aiohttp.web.Response`: HTML response with test page 3 content

**Logging**: Logs '[Test handler]' at INFO level

**Example Usage**:
```python
from aiohttp import web

# This handler is automatically called when accessing "/page3"
# No direct usage required - handled by aiohttp routing
```

## Configuration

### Environment Variables

#### `PORT`
**Description**: Configures the port number for the web server

**Type**: Integer
**Default**: 10000
**ESA Datalabs Default**: 8000 (set via `MAIN_PORT`)

**Usage**:
```bash
export PORT=8080
python3 src/app.py
```

#### `MAIN_PORT` (ESA Datalabs)
**Description**: Used in ESA Datalabs environment to set the PORT

**Type**: Integer
**Default**: 8000

**Usage**:
```bash
export MAIN_PORT=8080
./src/main.sh
```

### Application Configuration

The application is configured with the following routes:

```python
app.add_routes([
    web.get("/", index_handler),
    web.get("/page1", test1_handler),
    web.get("/page2", test2_handler),
    web.get("/page3", test3_handler),
])
```

## Deployment

### Docker Deployment

**Base Image**: `scidockreg.esac.esa.int:62530/datalabs/datalabs_base:0.8.0-stable-20.04`

**Exposed Ports**:
- 10000 (default application port)
- 8000 (ESA Datalabs port)

**Build Command**:
```bash
docker build -t test-lab .
```

**Run Command**:
```bash
docker run -p 10000:10000 test-lab
```

### Local Development

**Prerequisites**:
- Python 3
- pip3

**Installation**:
```bash
pip3 install aiohttp==3.7.4
```

**Run Application**:
```bash
cd src
python3 app.py
```

**Run with Custom Port**:
```bash
export PORT=8080
python3 src/app.py
```

### ESA Datalabs Deployment

The application is designed to run in the ESA Datalabs environment:

**Start Script**: `src/main.sh`
```bash
chmod +x src/main.sh
./src/main.sh
```

## Usage Examples

### Basic Navigation Flow

1. **Start at Homepage**:
   ```bash
   curl http://localhost:10000/
   ```

2. **Navigate to Page 1**:
   ```bash
   curl http://localhost:10000/page1
   ```

3. **Navigate to Page 3**:
   ```bash
   curl http://localhost:10000/page3
   ```

4. **Return to Homepage**:
   ```bash
   curl http://localhost:10000/
   ```

### Testing Relative Paths

1. **Access Page 2**:
   ```bash
   curl http://localhost:10000/page2
   ```

2. **Use Relative Navigation** (in browser):
   - Click "Back" link which uses relative path `./`

### Complete Web Application Test

```bash
#!/bin/bash

# Test all endpoints
echo "Testing homepage..."
curl -s http://localhost:10000/ | grep -q "Test lab" && echo "✓ Homepage works"

echo "Testing page1..."
curl -s http://localhost:10000/page1 | grep -q "Test page" && echo "✓ Page1 works"

echo "Testing page2..."
curl -s http://localhost:10000/page2 | grep -q "relative paths" && echo "✓ Page2 works"

echo "Testing page3..."
curl -s http://localhost:10000/page3 | grep -q "Test page" && echo "✓ Page3 works"

echo "All tests completed!"
```

### Health Check

```bash
# Simple health check
curl -f http://localhost:10000/ > /dev/null 2>&1 && echo "Service is running" || echo "Service is down"
```

### Development Testing with Different Ports

```bash
# Test with custom port
export PORT=8080
python3 src/app.py &
APP_PID=$!

# Wait for startup
sleep 2

# Test the application
curl http://localhost:8080/

# Cleanup
kill $APP_PID
```

## Logging

All handlers log their execution at INFO level:
- `index_handler`: Logs '[Index handler]'
- `test1_handler`: Logs '[Test handler]'
- `test2_handler`: Logs '[Test handler]'
- `test3_handler`: Logs '[Test handler]'

**Enable Logging**:
```python
import logging
logging.basicConfig(level=logging.INFO)
```

## Error Handling

The application uses aiohttp's default error handling. Common HTTP status codes:

- **200 OK**: Successful page load
- **404 Not Found**: Invalid route accessed
- **500 Internal Server Error**: Server-side error

## Dependencies

### Python Packages
- `aiohttp==3.7.4`: Web framework for async HTTP server/client

### System Dependencies
- `python3-pip==20.0.2-5ubuntu1.11`: Python package installer
- `tini`: Process manager for Docker containers

## Contact Information

- **Developer**: benjamin.mathias@acri-st.fr
- **Organization**: acri-st
- **Role**: Developer
- **ID**: 123456