# ArgoCD Integration Guide for DevOps Portfolio

## Overview

This guide explains how ArgoCD is integrated into the DevOps Portfolio project and how to use it for continuous deployment.

## What is ArgoCD?

ArgoCD is a declarative, GitOps continuous delivery tool for Kubernetes. It:
- Monitors your Git repository for changes
- Automatically syncs your Kubernetes cluster with the desired state
- Provides a visual UI for managing deployments
- Enables easy rollbacks and version control

## Architecture

```
GitHub Repository (Source of Truth)
         ↓
    ArgoCD (Monitors)
         ↓
  Kubernetes Cluster (Target)
         ↓
   Your Application (Running)
```

## Project Structure

```
DevOps_Docker/
├── k8s/                          # Kubernetes manifests
│   ├── deployment.yaml          # Application deployment
│   ├── service.yaml             # Service definition
│   ├── ingress.yaml             # Ingress configuration
│   ├── configmap.yaml           # Configuration
│   ├── hpa.yaml                 # Auto-scaling
│   └── kustomization.yaml       # Kustomize config
├── argocd/                       # ArgoCD configuration
│   ├── application.yaml         # ArgoCD app definition
│   ├── install.sh               # Installation script
│   ├── README.md                # Full documentation
│   ├── QUICKSTART.md            # Quick start guide
│   └── ingress-argocd.yaml      # ArgoCD ingress
└── docs/
    └── ARGOCD_GUIDE.md          # This file
```

## Prerequisites

### Required
- Kubernetes cluster (Minikube, Kind, EKS, GKE, AKS)
- kubectl installed and configured
- Git repository (already set up)

### Optional
- ArgoCD CLI
- Helm (for advanced configurations)

## Installation

### Quick Install

```bash
# Run the automated installation script
./argocd/install.sh
```

This script will:
1. Check prerequisites
2. Create ArgoCD namespace
3. Install ArgoCD
4. Wait for readiness
5. Display admin credentials

### Manual Install

See [argocd/README.md](../argocd/README.md) for detailed manual installation steps.

## Configuration

### ArgoCD Application

The `argocd/application.yaml` file defines how ArgoCD manages your application:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: devops-portfolio
spec:
  source:
    repoURL: https://github.com/ogash3103/DevOps_Docker.git
    targetRevision: main
    path: k8s
  destination:
    server: https://kubernetes.default.svc
    namespace: default
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
```

**Key Features:**
- **Automated Sync**: Changes in Git trigger automatic deployment
- **Self-Heal**: Manual changes in cluster are reverted
- **Prune**: Deleted resources in Git are removed from cluster

## Deployment Workflow

### 1. Initial Deployment

```bash
# Deploy ArgoCD application
kubectl apply -f argocd/application.yaml

# Verify deployment
kubectl get applications -n argocd
```

### 2. GitOps Workflow

```
Developer → Git Push → ArgoCD Detects → Syncs Cluster → Application Updated
```

**Example:**

```bash
# 1. Make changes to Kubernetes manifests
vim k8s/deployment.yaml

# 2. Commit and push
git add k8s/deployment.yaml
git commit -m "Update deployment configuration"
git push origin main

# 3. ArgoCD automatically syncs (within 3 minutes)
# 4. Check status in ArgoCD UI or CLI
```

### 3. Manual Sync

If you need immediate deployment:

```bash
# Using kubectl
kubectl patch application devops-portfolio -n argocd \
  --type merge -p '{"operation":{"initiatedBy":{"username":"admin"},"sync":{}}}'

# Using ArgoCD CLI
argocd app sync devops-portfolio
```

## Monitoring and Management

### ArgoCD UI

Access the UI:

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

Open: https://localhost:8080

**UI Features:**
- Visual representation of resources
- Sync status and health
- Deployment history
- Rollback capability
- Resource details and logs

### CLI Commands

```bash
# Get application status
argocd app get devops-portfolio

# List all applications
argocd app list

# View sync history
argocd app history devops-portfolio

# View logs
argocd app logs devops-portfolio

# Rollback to previous version
argocd app rollback devops-portfolio
```

### Kubernetes Commands

```bash
# Check application pods
kubectl get pods -l app=devops-portfolio

# Check service
kubectl get svc devops-portfolio-service

# View pod logs
kubectl logs -l app=devops-portfolio

# Describe deployment
kubectl describe deployment devops-portfolio
```

## Advanced Features

### 1. Sync Waves

Control deployment order:

```yaml
metadata:
  annotations:
    argocd.argoproj.io/sync-wave: "1"
```

Lower numbers deploy first.

### 2. Sync Hooks

Run jobs before/after sync:

```yaml
metadata:
  annotations:
    argocd.argoproj.io/hook: PreSync
```

### 3. Health Checks

Custom health checks:

```yaml
metadata:
  annotations:
    argocd.argoproj.io/health-check: |
      hs = {}
      hs.status = "Healthy"
      return hs
```

### 4. Ignore Differences

Ignore specific fields:

```yaml
spec:
  ignoreDifferences:
  - group: apps
    kind: Deployment
    jsonPointers:
    - /spec/replicas
```

## Troubleshooting

### Application Not Syncing

**Problem**: Changes in Git not reflected in cluster

**Solutions:**
```bash
# Check application status
argocd app get devops-portfolio

# Check sync policy
kubectl get application devops-portfolio -n argocd -o yaml

# Force sync
argocd app sync devops-portfolio --force

# Check ArgoCD logs
kubectl logs -n argocd deployment/argocd-application-controller
```

### Sync Failed

**Problem**: Sync operation fails

**Solutions:**
```bash
# View sync errors
argocd app get devops-portfolio

# Check resource events
kubectl get events -n default

# Validate manifests
kubectl apply --dry-run=client -f k8s/

# Check ArgoCD server logs
kubectl logs -n argocd deployment/argocd-server
```

### Cannot Access UI

**Problem**: ArgoCD UI not accessible

**Solutions:**
```bash
# Check ArgoCD pods
kubectl get pods -n argocd

# Restart port-forward
kubectl port-forward svc/argocd-server -n argocd 8080:443

# Check service
kubectl get svc argocd-server -n argocd

# Check ingress (if configured)
kubectl get ingress -n argocd
```

## Best Practices

### 1. Git as Single Source of Truth
- All changes go through Git
- No manual kubectl apply in production
- Use pull requests for changes

### 2. Environment Separation
- Use different branches or repos for environments
- dev → staging → production workflow
- Separate ArgoCD applications per environment

### 3. Security
- Use RBAC for access control
- Enable SSO integration
- Rotate admin password
- Use sealed secrets for sensitive data

### 4. Monitoring
- Enable notifications (Slack, email)
- Monitor sync status
- Set up alerts for failed syncs
- Track deployment metrics

### 5. Testing
- Test manifests locally first
- Use dry-run before applying
- Implement automated tests
- Use staging environment

## Integration with CI/CD

### GitHub Actions + ArgoCD

```yaml
# .github/workflows/deploy.yml
- name: Update image tag
  run: |
    cd k8s
    kustomize edit set image ogabek0331/devops-portfolio:${{ github.sha }}
    git commit -am "Update image to ${{ github.sha }}"
    git push
```

ArgoCD will automatically detect and deploy the new image.

## Rollback Procedures

### Using ArgoCD UI
1. Open application in UI
2. Click "History and Rollback"
3. Select previous version
4. Click "Rollback"

### Using CLI
```bash
# View history
argocd app history devops-portfolio

# Rollback to specific revision
argocd app rollback devops-portfolio <revision-id>

# Rollback to previous version
argocd app rollback devops-portfolio
```

### Using Git
```bash
# Revert Git commit
git revert <commit-hash>
git push origin main

# ArgoCD will sync to reverted state
```

## Performance Optimization

### 1. Reduce Sync Frequency
```yaml
spec:
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - ApplyOutOfSyncOnly=true
```

### 2. Use Resource Tracking
```yaml
spec:
  syncPolicy:
    syncOptions:
      - ResourceTracking=annotation
```

### 3. Optimize Repository
- Use shallow clones
- Minimize manifest size
- Use Kustomize or Helm

## Cleanup

### Remove Application
```bash
kubectl delete -f argocd/application.yaml
```

### Uninstall ArgoCD
```bash
kubectl delete -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl delete namespace argocd
```

## Additional Resources

- [ArgoCD Official Docs](https://argo-cd.readthedocs.io/)
- [GitOps Principles](https://www.gitops.tech/)
- [Kubernetes Best Practices](https://kubernetes.io/docs/concepts/configuration/overview/)
- [ArgoCD Examples](https://github.com/argoproj/argocd-example-apps)

## Support

For issues or questions:
- Check [argocd/README.md](../argocd/README.md)
- Review [Troubleshooting](#troubleshooting) section
- Visit [ArgoCD Slack](https://argoproj.github.io/community/join-slack)
- Open GitHub issue

---

**Happy GitOps! 🚀**
