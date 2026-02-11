# DevOps Portfolio Project - Complete Implementation Report

## 📋 Executive Summary

This project demonstrates a complete DevOps implementation for a portfolio website, showcasing modern practices including containerization, GitOps, continuous deployment, and Kubernetes orchestration. The project successfully implements Docker containerization, Helm chart deployment, and ArgoCD-based GitOps workflow.

**Project Status:** ✅ Fully Operational  
**Deployment Method:** GitOps with ArgoCD  
**Container Registry:** Docker Hub  
**Orchestration:** Kubernetes (Minikube)

---

## 👤 Project Information

**Author:** Ogabek  
**GitHub Repository:** https://github.com/ogash3103/DevOps_  
**Docker Hub:** https://hub.docker.com/r/ogabek0331/devops-portfolio  
**Application Name:** devops-portfolio  
**Namespace:** devops-portfolio

---

## 🏗️ Architecture Overview

### Technology Stack

| Component | Technology | Purpose |
|-----------|-----------|---------|
| **Frontend** | HTML, CSS, JavaScript | Static website |
| **Web Server** | Nginx (Alpine) | Serving static content |
| **Containerization** | Docker | Application packaging |
| **Container Registry** | Docker Hub | Image storage |
| **Orchestration** | Kubernetes | Container orchestration |
| **Package Manager** | Helm | Kubernetes deployment |
| **GitOps** | ArgoCD | Continuous deployment |
| **Version Control** | Git/GitHub | Source code management |

### Project Structure

```
DevOps_/
├── src/                           # Website source code
│   ├── index.html                # Home page
│   ├── skills.html               # Skills showcase
│   ├── blog.html                 # Blog section
│   ├── contact.html              # Contact form
│   ├── 404.html                  # Error page
│   ├── css/
│   │   └── style.css            # Styling
│   └── js/
│       └── main.js              # JavaScript functionality
├── deploy/                       # Deployment configurations
│   ├── argocd/
│   │   └── application.yaml     # ArgoCD application manifest
│   └── helm/
│       └── portfolio/
│           ├── Chart.yaml       # Helm chart metadata
│           ├── values.yaml      # Configuration values
│           └── templates/
│               ├── deployment.yaml   # Kubernetes deployment
│               ├── service.yaml      # Kubernetes service
│               └── ingress.yaml      # Ingress configuration
├── assets/                       # Static assets
│   └── images/                  # Image files
├── Dockerfile                    # Docker image definition
├── nginx.conf                    # Nginx configuration
├── .dockerignore                # Docker ignore rules
├── .gitignore                   # Git ignore rules
└── README.md                    # This file
```

---

## 🐳 Docker Implementation
<img width="3024" height="1964" alt="image" src="https://github.com/user-attachments/assets/ed451694-bca0-4f43-a3db-805a594d55ad" />


### Dockerfile Configuration

```dockerfile
FROM nginx:alpine

# Copy website files
COPY src/ /usr/share/nginx/html/

# Copy custom nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=3s \
    CMD wget --quiet --tries=1 --spider http://localhost/ || exit 1

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
```

### Custom Nginx Configuration

```nginx
server {
    listen 80;
    server_name localhost;
    
    root /usr/share/nginx/html;
    index index.html;
    
    location / {
        try_files $uri $uri/ /index.html;
    }
    
    error_page 404 /404.html;
    
    location = /404.html {
        internal;
    }
}
```

### Docker Image Details

- **Base Image:** nginx:alpine (lightweight, ~91.8MB)
- **Image Name:** ogabek0331/devops-portfolio:latest
- **Registry:** Docker Hub
- **Build Command:** `docker build -t ogabek0331/devops-portfolio:latest .`
- **Push Command:** `docker push ogabek0331/devops-portfolio:latest`

### Local Docker Testing

```bash
# Build image
docker build -t ogabek0331/devops-portfolio:latest .

# Run container
docker run -d -p 3000:80 --name my-portfolio ogabek0331/devops-portfolio:latest

# Test
curl http://localhost:3000

# Access in browser
open http://localhost:3000
```

**Result:** ✅ Successfully running on port 3000

---

## ☸️ Kubernetes Deployment with Helm
<img width="1678" height="568" alt="image" src="https://github.com/user-attachments/assets/072d80c5-09dd-44cf-be77-8e042b4e8f24" />

### Helm Chart Structure

#### Chart.yaml
```yaml
apiVersion: v2
name: portfolio
description: DevOps Portfolio Website
type: application
version: 0.1.0
appVersion: "1.0"
```

#### values.yaml
```yaml
replicaCount: 1

image:
  repository: ogabek0331/devops-portfolio
  tag: latest
  pullPolicy: Always

service:
  type: ClusterIP
  port: 80

ingress:
  enabled: false
  className: nginx
  host: portfolio.local
  path: /

resources:
  limits:
    cpu: 100m
    memory: 128Mi
  requests:
    cpu: 50m
    memory: 64Mi
```

#### Deployment Template
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: portfolio
  labels:
    app: portfolio
spec:
  replicas: {{ .Values.replicaCount }}
  selector:
    matchLabels:
      app: portfolio
  template:
    metadata:
      labels:
        app: portfolio
    spec:
      containers:
        - name: portfolio
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          ports:
            - containerPort: 80
          resources:
            {{- toYaml .Values.resources | nindent 12 }}
```

#### Service Template
```yaml
apiVersion: v1
kind: Service
metadata:
  name: portfolio
  labels:
    app: portfolio
spec:
  type: {{ .Values.service.type }}
  selector:
    app: portfolio
  ports:
    - port: {{ .Values.service.port }}
      targetPort: 80
```

### Helm Deployment Commands

```bash
# Validate Helm chart
helm template portfolio deploy/helm/portfolio

# Install with Helm
helm install portfolio deploy/helm/portfolio -n devops-portfolio

# Upgrade
helm upgrade portfolio deploy/helm/portfolio -n devops-portfolio

# Uninstall
helm uninstall portfolio -n devops-portfolio
```

---

## 🔄 GitOps with ArgoCD

ERROR
<img width="3024" height="1964" alt="image" src="https://github.com/user-attachments/assets/db75bd84-182b-4d8e-8d70-805b2a386edb" />



### ArgoCD Installation

```bash
# Create namespace
kubectl create namespace argocd

# Install ArgoCD
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait for pods to be ready
kubectl wait --for=condition=Ready pods --all -n argocd --timeout=300s

# Get initial admin password
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d

# Port forward to access UI
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

**ArgoCD UI:** http://localhost:8080  
**Username:** admin  
**Password:** J3fgXjtw2ITqRqsi

### ArgoCD Application Configuration

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: devops-portfolio
  namespace: argocd
spec:
  project: default

  source:
    repoURL: https://github.com/ogash3103/DevOps_.git
    targetRevision: main
    path: deploy/helm/portfolio

  destination:
    server: https://kubernetes.default.svc
    namespace: devops-portfolio

  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
```

### ArgoCD Setup Commands

```bash
# Login to ArgoCD
argocd login localhost:8080 --username admin --password J3fgXjtw2ITqRqsi --insecure

# Add repository
argocd repo add https://github.com/ogash3103/DevOps_.git

# Create application
kubectl apply -f deploy/argocd/application.yaml

# Check application status
argocd app get devops-portfolio

# Sync application
argocd app sync devops-portfolio
```

### ArgoCD Application Status

```
Name:               argocd/devops-portfolio
Project:            default
Server:             https://kubernetes.default.svc
Namespace:          devops-portfolio
Sync Status:        ✅ Synced to main (9d4b771)
Health Status:      ✅ Healthy

Resources:
  - Namespace:      devops-portfolio  ✅ Synced
  - Service:        portfolio          ✅ Healthy
  - Deployment:     portfolio          ✅ Healthy
```
<img width="3024" height="1964" alt="image" src="https://github.com/user-attachments/assets/22b4c1d2-06f7-4aaf-a0fa-39a1f938ea28" />

---

## 🚀 Deployment Verification

### Kubernetes Resources

```bash
# Check all resources
kubectl get all -n devops-portfolio
```

**Output:**
```
NAME                             READY   STATUS    RESTARTS   AGE
pod/portfolio-6fd8799656-wbqjc   1/1     Running   0          10m

NAME                TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
service/portfolio   ClusterIP   10.101.24.34   <none>        80/TCP    10m

NAME                        READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/portfolio   1/1     1            1           10m

NAME                                   DESIRED   CURRENT   READY   AGE
replicaset.apps/portfolio-6fd8799656   1         1         1       10m
```

### Access Application

```bash
# Port forward to access locally
kubectl port-forward -n devops-portfolio svc/portfolio 3001:80

# Test with curl
curl http://localhost:3001

# Open in browser
open http://localhost:3001
```

**Result:** ✅ Website accessible at http://localhost:3001

---

## 📊 Implementation Results

### ✅ Completed Tasks

| Task | Status | Details |
|------|--------|---------|
| Docker Image Build | ✅ Complete | Image size: 91.8MB |
| Docker Hub Push | ✅ Complete | ogabek0331/devops-portfolio:latest |
| Helm Chart Creation | ✅ Complete | Version 0.1.0 |
| Kubernetes Deployment | ✅ Complete | 1 replica running |
| ArgoCD Installation | ✅ Complete | Version: stable |
| ArgoCD Application | ✅ Complete | Sync: Automated |
| GitOps Workflow | ✅ Complete | Self-heal enabled |
| Health Checks | ✅ Complete | All healthy |

### 🎯 Key Achievements

1. **Containerization:** Successfully containerized static website with Nginx
2. **Image Optimization:** Used Alpine-based image for minimal size
3. **Helm Packaging:** Created reusable Helm chart with configurable values
4. **GitOps Implementation:** Automated deployment with ArgoCD
5. **Self-Healing:** Enabled automatic recovery from failures
6. **Resource Management:** Configured CPU and memory limits
7. **Clean Architecture:** Organized project structure following best practices

### 📈 Performance Metrics

- **Image Size:** 91.8MB (optimized with Alpine)
- **Deployment Time:** ~30 seconds
- **Pod Startup Time:** ~5 seconds
- **Resource Usage:** 
  - CPU: 50m (request) / 100m (limit)
  - Memory: 64Mi (request) / 128Mi (limit)

---

## 🔧 Troubleshooting & Solutions

### Issue 1: ArgoCD "default" Namespace Error
**Problem:** ArgoCD tried to manage "default" namespace  
**Solution:** Changed application name from "portfolio" to "devops-portfolio"  
**Result:** ✅ Resolved - No more namespace conflicts

### Issue 2: Docker Port 8080 HTTPS Redirect
**Problem:** Port 8080 redirected to HTTPS  
**Solution:** Used port 3000 instead and custom nginx.conf  
**Result:** ✅ Resolved - Website accessible on port 3000

### Issue 3: Helm Chart Resources Not Applied
**Problem:** Resources field was empty in values.yaml  
**Solution:** Added proper resource limits and requests  
**Result:** ✅ Resolved - Resources properly configured

---

## 📚 Commands Reference

### Docker Commands
```bash
# Build
docker build -t ogabek0331/devops-portfolio:latest .

# Run
docker run -d -p 3000:80 --name my-portfolio ogabek0331/devops-portfolio:latest

# Push
docker push ogabek0331/devops-portfolio:latest

# Stop & Remove
docker stop my-portfolio && docker rm my-portfolio
```

### Kubernetes Commands
```bash
# Get resources
kubectl get all -n devops-portfolio

# Describe pod
kubectl describe pod -n devops-portfolio -l app=portfolio

# View logs
kubectl logs -n devops-portfolio -l app=portfolio

# Port forward
kubectl port-forward -n devops-portfolio svc/portfolio 3001:80
```

### Helm Commands
```bash
# Install
helm install portfolio deploy/helm/portfolio -n devops-portfolio

# Upgrade
helm upgrade portfolio deploy/helm/portfolio -n devops-portfolio

# Uninstall
helm uninstall portfolio -n devops-portfolio

# Template (dry-run)
helm template portfolio deploy/helm/portfolio
```

### ArgoCD Commands
```bash
# Login
argocd login localhost:8080 --username admin --password <password> --insecure

# Add repo
argocd repo add https://github.com/ogash3103/DevOps_.git

# Get app status
argocd app get devops-portfolio

# Sync app
argocd app sync devops-portfolio

# Delete app
argocd app delete devops-portfolio
```

---

## 🎓 Lessons Learned

1. **Naming Matters:** Avoid generic names like "portfolio" that might conflict with system resources
2. **Port Selection:** Some ports (like 8080) may have special behaviors in Docker Desktop
3. **ArgoCD Patience:** ArgoCD automated sync needs time to complete operations
4. **Helm Best Practices:** Always define resource limits for production deployments
5. **GitOps Benefits:** Automated sync and self-heal provide robust deployment workflow

---

## 🔮 Future Enhancements

- [ ] Add Ingress controller for external access
- [ ] Implement SSL/TLS certificates
- [ ] Add monitoring with Prometheus/Grafana
- [ ] Implement horizontal pod autoscaling
- [ ] Add CI/CD pipeline with GitHub Actions
- [ ] Implement blue-green deployment strategy
- [ ] Add automated testing in pipeline

---

## 📞 Contact Information

**Author:** Ogabek  
**Email:** ogabek0331@gmail.com  
**GitHub:** https://github.com/ogash3103  
**Docker Hub:** https://hub.docker.com/u/ogabek0331  
**LinkedIn:** https://linkedin.com/in/ogabek
web-site netlify: https://devops-portfolio-ogash.netlify.app/
---

## 📄 License

MIT License - Feel free to use this project for learning and development purposes.

---

## 🙏 Acknowledgments

- Nginx team for the lightweight Alpine image
- ArgoCD community for excellent GitOps tooling
- Kubernetes and Helm communities for robust orchestration
- Docker for containerization platform

---

**Last Updated:** February 12, 2026  
**Project Status:** ✅ Production Ready  
**Documentation Version:** 1.0
