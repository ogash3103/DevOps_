#!/bin/bash

# Script to open DevOps Portfolio Website

echo "🚀 Opening DevOps Portfolio Website..."
echo ""

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker first."
    exit 1
fi

# Build image
echo "📦 Building Docker image..."
docker build -t devops-portfolio . > /dev/null 2>&1

# Stop existing container if running
docker stop devops-portfolio 2>/dev/null
docker rm devops-portfolio 2>/dev/null

# Run container
echo "🐳 Starting container..."
docker run -d -p 8080:80 --name devops-portfolio devops-portfolio > /dev/null 2>&1

# Wait for container to be ready
echo "⏳ Waiting for website to be ready..."
sleep 3

# Check if website is accessible
if curl -s http://localhost:8080 > /dev/null; then
    echo "✅ Website is ready!"
    echo ""
    echo "🌐 Opening browser..."
    echo "   URL: http://localhost:8080"
    echo ""
    
    # Open browser
    if [[ "$OSTYPE" == "darwin"* ]]; then
        open http://localhost:8080
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        xdg-open http://localhost:8080
    else
        echo "Please open: http://localhost:8080"
    fi
    
    echo ""
    echo "📝 To stop the website:"
    echo "   docker stop devops-portfolio"
    echo ""
else
    echo "❌ Website failed to start"
    echo "Check logs: docker logs devops-portfolio"
    exit 1
fi
