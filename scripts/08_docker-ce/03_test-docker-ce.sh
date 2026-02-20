#!/bin/bash

echo "Testing Docker CE image execution..."

sudo docker run --rm hello-world

echo ""
echo "If you see 'Hello from Docker!' above, Docker CE is working correctly."
