# ArgoCD Quick Start Guide

## 🚀 5-Minute Setup

### Step 1: Install ArgoCD

```bash
# Run the installation script
./argocd/install.sh
```

Wait for the script to complete. It will display your admin password.

### Step 2: Access ArgoCD UI

Open a new terminal and run:

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

Open your browser: https://localhost:8080

**Login:**
- Username: `admin`
- Password: (displayed by install script)

### Step 3: Deploy Your Application

```bash
kubectl apply -f argocd/application.yaml
```

### Step 4: Verify Deployment

In ArgoCD UI, you should see:
- Application: `devops-portfolio`
- Status: `Synced` and `Healthy`

Or check via CLI:

```bash
kubectl get pods -l app=devops-portfolio
```

### Step 5: Access Your Application

```bash
# Port forward to your application
kubectl port-forward svc/devops-portfolio-service 8081:80
```

Open: http://localhost:8081

## 🎯 What Just Happened?

1. ✅ ArgoCD installed in your cluster
2. ✅ ArgoCD monitoring your Git repository
3. ✅ Your application deployed automatically
4. ✅ GitOps workflow enabled

## 🔄 GitOps Workflow

Now, any changes you push to GitHub will automatically deploy:

1. Edit `k8s/deployment.yaml`
2. Commit and push to GitHub
3. ArgoCD detects changes
4. Application updates automatically

## 📊 Monitor Your Application

### ArgoCD UI
- View sync status
- See resource health
- Check deployment history
- Rollback if needed

### CLI Commands

```bash
# Get application status
kubectl get applications -n argocd

# Get pods
kubectl get pods -l app=devops-portfolio

# Get service
kubectl get svc devops-portfolio-service

# View logs
kubectl logs -l app=devops-portfolio
```

## 🛠️ Common Tasks

### Update Application

```bash
# Edit deployment
vim k8s/deployment.yaml

# Commit and push
git add k8s/deployment.yaml
git commit -m "Update deployment"
git push origin main

# ArgoCD syncs automatically!
```

### Manual Sync

```bash
# Force sync via CLI
argocd app sync devops-portfolio

# Or click "Sync" in ArgoCD UI
```

### Rollback

```bash
# Rollback to previous version
argocd app rollback devops-portfolio
```

### Scale Application

```bash
# Edit replicas in k8s/deployment.yaml
# Change: replicas: 2 to replicas: 3
# Commit and push - ArgoCD will sync!
```

## 🎓 Next Steps

1. **Explore ArgoCD UI**: Familiarize yourself with the interface
2. **Try GitOps**: Make changes and watch auto-sync
3. **Add Monitoring**: Integrate Prometheus/Grafana
4. **Set Up Notifications**: Configure Slack alerts
5. **Learn Advanced Features**: Sync waves, hooks, etc.

## 📚 Learn More

- [ArgoCD Documentation](https://argo-cd.readthedocs.io/)
- [Full README](./README.md)
- [GitOps Guide](https://www.gitops.tech/)

## ❓ Need Help?

Check the [Troubleshooting](./README.md#troubleshooting) section in the full README.

---

**Congratulations! You're now using GitOps with ArgoCD! 🎉**
