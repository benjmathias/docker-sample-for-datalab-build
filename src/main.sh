#!/bin/sh
# Switch to user if running as root
if [ "$(id -u)" = "0" ]; then
    exec su -c "python3 -m app" user
else
    python3 -m app
fi
