#!/bin/bash

# Test Kubernetes manifests

echo "🧪 Testing Kubernetes manifests..."
echo ""

# Test with kubectl dry-run
echo "1. Testing deployment..."
kubectl apply -f k8s/deployment.yaml --dry-run=client
if [ $? -eq 0 ]; then
    echo "✅ Deployment is valid"
else
    echo "❌ Deployment has errors"
    exit 1
fi

echo ""
echo "2. Testing service..."
kubectl apply -f k8s/service.yaml --dry-run=client
if [ $? -eq 0 ]; then
    echo "✅ Service is valid"
else
    echo "❌ Service has errors"
    exit 1
fi

echo ""
echo "3. Testing configmap..."
kubectl apply -f k8s/configmap.yaml --dry-run=client
if [ $? -eq 0 ]; then
    echo "✅ ConfigMap is valid"
else
    echo "❌ ConfigMap has errors"
    exit 1
fi

echo ""
echo "4. Testing HPA..."
kubectl apply -f k8s/hpa.yaml --dry-run=client
if [ $? -eq 0 ]; then
    echo "✅ HPA is valid"
else
    echo "❌ HPA has errors"
    exit 1
fi

echo ""
echo "5. Testing with kustomize..."
kubectl kustomize k8s/ > /dev/null
if [ $? -eq 0 ]; then
    echo "✅ Kustomize build successful"
else
    echo "❌ Kustomize build failed"
    exit 1
fi

echo ""
echo "✅ All manifests are valid!"
echo ""
echo "To deploy:"
echo "  kubectl apply -k k8s/"
echo ""
