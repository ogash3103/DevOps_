#!/bin/bash

# ArgoCD Installation Script for DevOps Portfolio

set -e

echo "=========================================="
echo "ArgoCD Installation Script"
echo "=========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if kubectl is installed
if ! command -v kubectl &> /dev/null; then
    echo -e "${RED}Error: kubectl is not installed${NC}"
    echo "Please install kubectl first: https://kubernetes.io/docs/tasks/tools/"
    exit 1
fi

echo -e "${GREEN}✓ kubectl is installed${NC}"

# Check if cluster is accessible
if ! kubectl cluster-info &> /dev/null; then
    echo -e "${RED}Error: Cannot connect to Kubernetes cluster${NC}"
    echo "Please ensure your cluster is running and kubectl is configured"
    exit 1
fi

echo -e "${GREEN}✓ Kubernetes cluster is accessible${NC}"
echo ""

# Create ArgoCD namespace
echo "Creating ArgoCD namespace..."
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
echo -e "${GREEN}✓ ArgoCD namespace created${NC}"
echo ""

# Install ArgoCD
echo "Installing ArgoCD..."
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
echo -e "${GREEN}✓ ArgoCD installed${NC}"
echo ""

# Wait for ArgoCD to be ready
echo "Waiting for ArgoCD to be ready (this may take a few minutes)..."
kubectl wait --for=condition=available --timeout=300s deployment/argocd-server -n argocd
echo -e "${GREEN}✓ ArgoCD is ready${NC}"
echo ""

# Get initial admin password
echo "Getting ArgoCD admin password..."
ARGOCD_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
echo -e "${GREEN}✓ Admin password retrieved${NC}"
echo ""

# Port forward ArgoCD server (optional)
echo "=========================================="
echo "ArgoCD Installation Complete!"
echo "=========================================="
echo ""
echo -e "${YELLOW}Access ArgoCD UI:${NC}"
echo "1. Run port-forward:"
echo "   kubectl port-forward svc/argocd-server -n argocd 8080:443"
echo ""
echo "2. Open browser:"
echo "   https://localhost:8080"
echo ""
echo -e "${YELLOW}Login credentials:${NC}"
echo "   Username: admin"
echo "   Password: $ARGOCD_PASSWORD"
echo ""
echo -e "${YELLOW}Install ArgoCD CLI (optional):${NC}"
echo "   macOS: brew install argocd"
echo "   Linux: curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64"
echo ""
echo -e "${YELLOW}Deploy application:${NC}"
echo "   kubectl apply -f argocd/application.yaml"
echo ""
echo "=========================================="
