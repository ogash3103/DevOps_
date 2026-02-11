#!/bin/bash

# Script to open ArgoCD UI

echo "🚀 Opening ArgoCD UI..."
echo ""

# Check if kubectl is installed
if ! command -v kubectl &> /dev/null; then
    echo "❌ kubectl is not installed"
    echo "Install: https://kubernetes.io/docs/tasks/tools/"
    exit 1
fi

# Check if cluster is accessible
if ! kubectl cluster-info &> /dev/null; then
    echo "❌ Cannot connect to Kubernetes cluster"
    echo ""
    echo "Options:"
    echo "1. Start Minikube: minikube start"
    echo "2. Enable Docker Desktop Kubernetes"
    echo "3. Create Kind cluster: kind create cluster"
    exit 1
fi

echo "✅ Kubernetes cluster is accessible"
echo ""

# Check if ArgoCD is installed
if ! kubectl get namespace argocd &> /dev/null; then
    echo "❌ ArgoCD is not installed"
    echo ""
    echo "Install ArgoCD:"
    echo "   ./argocd/install.sh"
    echo ""
    echo "Or manually:"
    echo "   kubectl create namespace argocd"
    echo "   kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml"
    exit 1
fi

echo "✅ ArgoCD is installed"
echo ""

# Get admin password
echo "🔑 Getting admin password..."
PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" 2>/dev/null | base64 -d)

if [ -z "$PASSWORD" ]; then
    echo "❌ Could not get admin password"
    echo "ArgoCD might still be starting. Wait a few minutes and try again."
    exit 1
fi

echo "✅ Admin password retrieved"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📋 ArgoCD Login Credentials:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "   Username: admin"
echo "   Password: $PASSWORD"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Start port forward in background
echo "🌐 Starting port forward..."
kubectl port-forward svc/argocd-server -n argocd 8080:443 > /dev/null 2>&1 &
PF_PID=$!

# Wait for port forward to be ready
sleep 3

echo "✅ Port forward is ready"
echo ""
echo "🌐 Opening browser..."
echo "   URL: https://localhost:8080"
echo ""

# Open browser
if [[ "$OSTYPE" == "darwin"* ]]; then
    open https://localhost:8080
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    xdg-open https://localhost:8080
else
    echo "Please open: https://localhost:8080"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📝 Important Notes:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "1. Accept the self-signed certificate warning"
echo "2. Login with credentials shown above"
echo "3. Port forward is running (PID: $PF_PID)"
echo ""
echo "To stop port forward:"
echo "   kill $PF_PID"
echo "   or press Ctrl+C in this terminal"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Press Ctrl+C to stop port forward..."

# Wait for user to stop
wait $PF_PID
