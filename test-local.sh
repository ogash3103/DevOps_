#!/bin/bash

# Local Testing Script for DevOps Portfolio

set -e

echo "=========================================="
echo "DevOps Portfolio - Local Test Script"
echo "=========================================="
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Test 1: Check files exist
echo "Test 1: Checking required files..."
files=("src/index.html" "src/skills.html" "src/blog.html" "src/contact.html" "src/404.html" "src/css/style.css" "src/js/main.js" "Dockerfile" "docker-compose.yml" ".github/workflows/deploy.yml")

for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${GREEN}✓${NC} $file exists"
    else
        echo -e "${RED}✗${NC} $file missing"
        exit 1
    fi
done

echo ""

# Test 2: Build Docker image
echo "Test 2: Building Docker image..."
docker build -t devops-portfolio-test . > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓${NC} Docker image built successfully"
else
    echo -e "${RED}✗${NC} Docker build failed"
    exit 1
fi

echo ""

# Test 3: Run container
echo "Test 3: Running Docker container..."
docker run -d -p 8080:80 --name test-portfolio devops-portfolio-test > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓${NC} Container started"
else
    echo -e "${RED}✗${NC} Container failed to start"
    exit 1
fi

# Wait for container to be ready
sleep 3

# Test 4: Check HTTP response
echo "Test 4: Testing HTTP response..."
response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080)
if [ "$response" = "200" ]; then
    echo -e "${GREEN}✓${NC} Website is accessible (HTTP 200)"
else
    echo -e "${RED}✗${NC} Website returned HTTP $response"
    docker stop test-portfolio > /dev/null 2>&1
    docker rm test-portfolio > /dev/null 2>&1
    exit 1
fi

# Test 5: Check all pages
echo "Test 5: Testing all pages..."
pages=("/" "/skills.html" "/blog.html" "/contact.html" "/404.html")

for page in "${pages[@]}"; do
    response=$(curl -s -o /dev/null -w "%{http_code}" "http://localhost:8080$page")
    if [ "$response" = "200" ]; then
        echo -e "${GREEN}✓${NC} $page is accessible"
    else
        echo -e "${RED}✗${NC} $page returned HTTP $response"
    fi
done

echo ""

# Cleanup
echo "Cleaning up..."
docker stop test-portfolio > /dev/null 2>&1
docker rm test-portfolio > /dev/null 2>&1
echo -e "${GREEN}✓${NC} Cleanup complete"

echo ""
echo "=========================================="
echo -e "${GREEN}ALL TESTS PASSED!${NC}"
echo "=========================================="
echo ""
echo "Your DevOps Portfolio is ready to deploy!"
echo ""
echo "Next steps:"
echo "1. Push to GitHub: git push origin main"
echo "2. Enable GitHub Pages (Settings > Pages)"
echo "3. Push to Docker Hub: docker push ogabek0331/devops-portfolio:latest"
echo ""
