#!/bin/sh
# Check if user exists
if ! id -u user >/dev/null 2>&1; then
    # Create the user with UID 5002
    useradd -u 5002 -m -s /bin/bash user
fi

# Run the main application script
exec ./main.sh
