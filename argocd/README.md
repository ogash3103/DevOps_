# ArgoCD Setup for DevOps Portfolio

## What is ArgoCD?

ArgoCD is a declarative, GitOps continuous delivery tool for Kubernetes. It automatically syncs your Kubernetes cluster with the desired state defined in your Git repository.

## Prerequisites

Before installing ArgoCD, ensure you have:

1. **Kubernetes Cluster** - Running cluster (Minikube, Kind, EKS, GKE, AKS, etc.)
2. **kubectl** - Kubernetes command-line tool installed and configured
3. **Git Repository** - Your application manifests in Git (already done!)

## Installation Methods

### Method 1: Automated Installation (Recommended)

Run the installation script:

```bash
./argocd/install.sh
```

This script will:
- Check prerequisites
- Create ArgoCD namespace
- Install ArgoCD
- Wait for ArgoCD to be ready
- Display login credentials

### Method 2: Manual Installation

#### Step 1: Create ArgoCD Namespace

```bash
kubectl create namespace argocd
```

#### Step 2: Install ArgoCD

```bash
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

#### Step 3: Wait for ArgoCD to be Ready

```bash
kubectl wait --for=condition=available --timeout=300s deployment/argocd-server -n argocd
```

#### Step 4: Get Admin Password

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

## Accessing ArgoCD UI

### Option 1: Port Forward (Local Development)

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

Then open: https://localhost:8080

### Option 2: LoadBalancer (Cloud)

```bash
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
```

Get external IP:
```bash
kubectl get svc argocd-server -n argocd
```

### Option 3: Ingress (Production)

Create an Ingress resource (example in `argocd/ingress-argocd.yaml`)

## Login Credentials

- **Username**: `admin`
- **Password**: Get from secret (see installation steps above)

## Deploy Your Application

### Using kubectl

```bash
kubectl apply -f argocd/application.yaml
```

### Using ArgoCD CLI

1. Install ArgoCD CLI:

```bash
# macOS
brew install argocd

# Linux
curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
chmod +x /usr/local/bin/argocd
```

2. Login to ArgoCD:

```bash
argocd login localhost:8080 --username admin --password <password>
```

3. Create application:

```bash
argocd app create devops-portfolio \
  --repo https://github.com/ogash3103/DevOps_Docker.git \
  --path k8s \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace default \
  --sync-policy automated \
  --auto-prune \
  --self-heal
```

## Verify Deployment

### Check ArgoCD Application Status

```bash
kubectl get applications -n argocd
```

### Check Application Pods

```bash
kubectl get pods -l app=devops-portfolio
```

### Check Service

```bash
kubectl get svc devops-portfolio-service
```

### Access Your Application

If using LoadBalancer:
```bash
kubectl get svc devops-portfolio-service -o jsonpath='{.status.loadBalancer.ingress[0].ip}'
```

If using port-forward:
```bash
kubectl port-forward svc/devops-portfolio-service 8081:80
```
Then open: http://localhost:8081

## ArgoCD Features

### 1. Automated Sync

ArgoCD automatically syncs your cluster with Git repository:
- Detects changes in Git
- Applies changes to cluster
- Self-heals if manual changes are made

### 2. Rollback

Easily rollback to previous versions:

```bash
argocd app rollback devops-portfolio
```

### 3. Health Status

Monitor application health in real-time:

```bash
argocd app get devops-portfolio
```

### 4. Sync Waves

Control deployment order using annotations:

```yaml
metadata:
  annotations:
    argocd.argoproj.io/sync-wave: "1"
```

## GitOps Workflow

1. **Make Changes**: Update Kubernetes manifests in `k8s/` directory
2. **Commit & Push**: Push changes to GitHub
3. **Auto Sync**: ArgoCD detects changes and syncs automatically
4. **Verify**: Check ArgoCD UI for sync status

## Troubleshooting

### Application Not Syncing

```bash
# Check application status
argocd app get devops-portfolio

# Force sync
argocd app sync devops-portfolio

# Check logs
kubectl logs -n argocd deployment/argocd-application-controller
```

### Cannot Access ArgoCD UI

```bash
# Check ArgoCD server status
kubectl get pods -n argocd

# Check service
kubectl get svc argocd-server -n argocd

# Restart port-forward
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

### Forgot Admin Password

```bash
# Get password again
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

# Or reset password
kubectl -n argocd patch secret argocd-secret \
  -p '{"stringData": {"admin.password": "'$(htpasswd -bnBC 10 "" newpassword | tr -d ':\n')'"}}'
```

## Best Practices

1. **Use Git as Single Source of Truth**: All changes should go through Git
2. **Enable Auto-Sync**: Let ArgoCD handle deployments automatically
3. **Use Sync Waves**: Control deployment order for complex applications
4. **Monitor Health**: Regularly check application health in ArgoCD UI
5. **Use Projects**: Organize applications using ArgoCD Projects
6. **Enable Notifications**: Set up Slack/email notifications for sync events

## Cleanup

### Delete Application

```bash
kubectl delete -f argocd/application.yaml
```

### Uninstall ArgoCD

```bash
kubectl delete -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl delete namespace argocd
```

## Additional Resources

- [ArgoCD Documentation](https://argo-cd.readthedocs.io/)
- [ArgoCD GitHub](https://github.com/argoproj/argo-cd)
- [GitOps Principles](https://www.gitops.tech/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)

## Support

For issues or questions:
- Check ArgoCD logs: `kubectl logs -n argocd deployment/argocd-server`
- Visit ArgoCD Slack: https://argoproj.github.io/community/join-slack
- GitHub Issues: https://github.com/argoproj/argo-cd/issues
