# Function Reference

## Overview

This document provides detailed reference documentation for all functions, handlers, and components in the Test Lab application.

## Table of Contents

1. [Request Handlers](#request-handlers)
2. [Application Configuration](#application-configuration)
3. [Utility Functions](#utility-functions)
4. [Type Definitions](#type-definitions)
5. [Constants](#constants)
6. [Error Handling](#error-handling)

## Request Handlers

### `index_handler(request)`

**Module**: `src/app.py`  
**Type**: Async Function  
**Visibility**: Public

**Description**:
Handles HTTP GET requests to the root path (`/`). Returns the main index page with navigation links to other pages in the application.

**Parameters**:
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `request` | `aiohttp.web.Request` | Yes | The incoming HTTP request object containing headers, query parameters, and other request data |

**Returns**:
| Type | Description |
|------|-------------|
| `aiohttp.web.Response` | HTTP response object with HTML content and text/html content type |

**Response Details**:
- **Status Code**: 200 (OK)
- **Content-Type**: `text/html`
- **Body**: HTML page with title "Test lab" and navigation links

**Side Effects**:
- Logs message '[Index handler]' at INFO level

**Example Usage**:
```python
from aiohttp import web

# Handler is automatically invoked by aiohttp when route is accessed
app = web.Application()
app.add_routes([web.get("/", index_handler)])

# Manual invocation (for testing)
import asyncio
from unittest.mock import Mock

async def test_index_handler():
    mock_request = Mock(spec=web.Request)
    response = await index_handler(mock_request)
    assert response.status == 200
    assert "Test lab" in response.text

# Run test
asyncio.run(test_index_handler())
```

**HTML Response Structure**:
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

---

### `test1_handler(request)`

**Module**: `src/app.py`  
**Type**: Async Function  
**Visibility**: Public

**Description**:
Handles HTTP GET requests to `/page1`. Returns a test page with navigation links to the homepage and page3.

**Parameters**:
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `request` | `aiohttp.web.Request` | Yes | The incoming HTTP request object |

**Returns**:
| Type | Description |
|------|-------------|
| `aiohttp.web.Response` | HTTP response object with HTML content for test page 1 |

**Response Details**:
- **Status Code**: 200 (OK)
- **Content-Type**: `text/html` (set explicitly)
- **Body**: HTML page with title "Test page" and navigation links

**Side Effects**:
- Logs message '[Test handler]' at INFO level

**Example Usage**:
```python
# Testing the handler
async def test_test1_handler():
    mock_request = Mock(spec=web.Request)
    response = await test1_handler(mock_request)
    
    assert response.status == 200
    assert response.content_type == "text/html"
    assert "Test page" in response.text
    assert 'href="/"' in response.text  # Homepage link
    assert 'href="/page3"' in response.text  # Page3 link
```

**HTML Response Structure**:
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

---

### `test2_handler(request)`

**Module**: `src/app.py`  
**Type**: Async Function  
**Visibility**: Public

**Description**:
Handles HTTP GET requests to `/page2`. Returns a test page that demonstrates relative path navigation with a "Back" link.

**Parameters**:
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `request` | `aiohttp.web.Request` | Yes | The incoming HTTP request object |

**Returns**:
| Type | Description |
|------|-------------|
| `aiohttp.web.Response` | HTTP response object with HTML content for test page 2 |

**Response Details**:
- **Status Code**: 200 (OK)
- **Content-Type**: `text/html` (set explicitly)
- **Body**: HTML page demonstrating relative path navigation

**Side Effects**:
- Logs message '[Test handler]' at INFO level

**Special Features**:
- Demonstrates relative path navigation using `./` syntax
- Shows how relative links work in web applications

**Example Usage**:
```python
# Testing relative path functionality
async def test_test2_handler():
    mock_request = Mock(spec=web.Request)
    response = await test2_handler(mock_request)
    
    assert response.status == 200
    assert "Page with relative paths" in response.text
    assert 'href="./"' in response.text  # Relative path link
```

**HTML Response Structure**:
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

---

### `test3_handler(request)`

**Module**: `src/app.py`  
**Type**: Async Function  
**Visibility**: Public

**Description**:
Handles HTTP GET requests to `/page3`. Returns a test page with navigation back to the homepage.

**Parameters**:
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `request` | `aiohttp.web.Request` | Yes | The incoming HTTP request object |

**Returns**:
| Type | Description |
|------|-------------|
| `aiohttp.web.Response` | HTTP response object with HTML content for test page 3 |

**Response Details**:
- **Status Code**: 200 (OK)
- **Content-Type**: `text/html` (set explicitly)
- **Body**: HTML page with homepage navigation

**Side Effects**:
- Logs message '[Test handler]' at INFO level

**Example Usage**:
```python
# Testing the final page in the navigation flow
async def test_test3_handler():
    mock_request = Mock(spec=web.Request)
    response = await test3_handler(mock_request)
    
    assert response.status == 200
    assert "Test page" in response.text
    assert 'href="/"' in response.text  # Homepage link
```

**HTML Response Structure**:
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

## Application Configuration

### `app`

**Module**: `src/app.py`  
**Type**: `aiohttp.web.Application`  
**Visibility**: Public

**Description**:
Main application instance that defines the web server configuration and routing.

**Configuration**:
```python
app = web.Application()
app.add_routes([
    web.get("/", index_handler),
    web.get("/page1", test1_handler),
    web.get("/page2", test2_handler),
    web.get("/page3", test3_handler),
])
```

**Routes**:
| Path | Method | Handler | Description |
|------|--------|---------|-------------|
| `/` | GET | `index_handler` | Main index page |
| `/page1` | GET | `test1_handler` | Test page 1 |
| `/page2` | GET | `test2_handler` | Test page 2 (relative paths) |
| `/page3` | GET | `test3_handler` | Test page 3 |

**Example Usage**:
```python
# Accessing the application for testing
from aiohttp.test_utils import make_mocked_request

# Create test requests
request = make_mocked_request('GET', '/')

# Access route information
for route in app.router.routes():
    print(f"Route: {route.method} {route.resource.canonical}")
```

### `port_number`

**Module**: `src/app.py`  
**Type**: `int`  
**Visibility**: Module-level

**Description**:
Determines the port number for the web server based on environment variables.

**Logic**:
```python
env_port = os.environ.get('PORT')
port_number = int(env_port) if env_port and env_port.isdigit() else 10000
```

**Behavior**:
- Reads `PORT` environment variable
- Validates that the value is a digit
- Falls back to default port 10000 if not set or invalid

**Example Values**:
| Environment | PORT Value | Resulting Port |
|-------------|------------|----------------|
| Development | Not set | 10000 |
| Custom | "8080" | 8080 |
| Invalid | "abc" | 10000 |
| ESA Datalabs | Set via `MAIN_PORT` | 8000 |

## Utility Functions

### `web.run_app(app, port=port_number)`

**Module**: `aiohttp.web`  
**Type**: Function Call  
**Visibility**: Application Entry Point

**Description**:
Starts the aiohttp web server with the configured application and port.

**Parameters**:
| Parameter | Type | Value | Description |
|-----------|------|-------|-------------|
| `app` | `web.Application` | Application instance | The configured web application |
| `port` | `int` | `port_number` | Port number to bind the server |

**Behavior**:
- Starts the HTTP server
- Binds to all interfaces (0.0.0.0)
- Runs until interrupted (Ctrl+C)
- Handles graceful shutdown

**Example Usage**:
```python
# Standard usage (as in the application)
web.run_app(app, port=port_number)

# Custom configuration
web.run_app(app, host='127.0.0.1', port=8080)

# With additional options
web.run_app(
    app, 
    port=port_number,
    access_log=logging.getLogger('aiohttp.access')
)
```

## Type Definitions

### Request Handler Type

**Definition**:
```python
from typing import Callable, Awaitable
from aiohttp.web import Request, Response

RequestHandler = Callable[[Request], Awaitable[Response]]
```

**Usage**:
All handler functions in the application conform to this type signature.

### Response Type

**Definition**:
```python
from aiohttp.web import Response

# Standard HTML response
HTMLResponse = Response  # with content_type='text/html'
```

## Constants

### Default Values

| Constant | Value | Description |
|----------|-------|-------------|
| `DEFAULT_PORT` | 10000 | Default port when PORT env var is not set |
| `ESA_DATALABS_PORT` | 8000 | Default port for ESA Datalabs environment |

### Content Types

| Constant | Value | Usage |
|----------|-------|-------|
| `HTML_CONTENT_TYPE` | `'text/html'` | All response content type |

### Log Messages

| Handler | Log Message | Level |
|---------|-------------|-------|
| `index_handler` | `'[Index handler]'` | INFO |
| `test1_handler` | `'[Test handler]'` | INFO |
| `test2_handler` | `'[Test handler]'` | INFO |
| `test3_handler` | `'[Test handler]'` | INFO |

## Error Handling

### Default Error Handling

The application relies on aiohttp's built-in error handling:

**404 Not Found**:
- Returned for undefined routes
- Default aiohttp 404 page

**500 Internal Server Error**:
- Returned for unhandled exceptions in handlers
- Default aiohttp error page

### Custom Error Handling (Extension)

To add custom error handling, you can extend the application:

```python
from aiohttp.web import middleware

@middleware
async def error_handler(request, handler):
    try:
        response = await handler(request)
        return response
    except Exception as ex:
        # Custom error handling
        return web.Response(
            text=f"<html><body><h1>Error</h1><p>{str(ex)}</p></body></html>",
            content_type='text/html',
            status=500
        )

# Add middleware to application
app.middlewares.append(error_handler)
```

### Logging Configuration

**Logger Setup**:
```python
import logging

log = logging.getLogger(__name__)

# Enable logging (add to application)
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
```

**Log Output Example**:
```
2023-12-07 10:30:15,123 - __main__ - INFO - [Index handler]
2023-12-07 10:30:20,456 - __main__ - INFO - [Test handler]
```

## Testing Utilities

### Handler Testing

```python
import asyncio
from unittest.mock import Mock
from aiohttp.web import Request

async def test_handler(handler_func, expected_content):
    """Utility function to test handlers"""
    mock_request = Mock(spec=Request)
    response = await handler_func(mock_request)
    
    assert response.status == 200
    assert expected_content in response.text
    return response

# Usage examples
async def run_tests():
    await test_handler(index_handler, "Test lab")
    await test_handler(test1_handler, "Test page")
    await test_handler(test2_handler, "relative paths")
    await test_handler(test3_handler, "Test page")
    print("All handler tests passed!")

# Run tests
asyncio.run(run_tests())
```

### Integration Testing

```python
from aiohttp.test_utils import AioHTTPTestCase, unittest_run_loop

class TestLabTestCase(AioHTTPTestCase):
    async def get_application(self):
        return app
    
    @unittest_run_loop
    async def test_index_page(self):
        resp = await self.client.request("GET", "/")
        self.assertEqual(resp.status, 200)
        text = await resp.text()
        self.assertIn("Test lab", text)
    
    @unittest_run_loop
    async def test_all_pages(self):
        pages = ["/", "/page1", "/page2", "/page3"]
        for page in pages:
            resp = await self.client.request("GET", page)
            self.assertEqual(resp.status, 200)
```

## Performance Considerations

### Handler Performance

- All handlers are lightweight and return static HTML
- No database queries or external API calls
- Response time should be < 10ms under normal conditions

### Memory Usage

- Each handler creates a new Response object
- HTML content is embedded as strings (no template engine)
- Memory footprint is minimal

### Scalability

- Application is stateless
- Can handle multiple concurrent requests
- Suitable for horizontal scaling with load balancers