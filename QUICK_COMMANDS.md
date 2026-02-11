# 🚀 Tezkor Buyruqlar

## 1️⃣ WEBSITE NI LOKAL OCHISH

### Docker bilan (Eng Oson):

```bash
# Build qiling
docker build -t devops-portfolio .

# Run qiling
docker run -d -p 8080:80 --name my-portfolio devops-portfolio

# Browser da oching
open http://localhost:8080
# yoki
# Windows: start http://localhost:8080
# Linux: xdg-open http://localhost:8080
```

### Python HTTP Server bilan:

```bash
# src papkasida server ishga tushiring
cd src
python3 -m http.server 8000

# Browser da oching
open http://localhost:8000
```

### Docker Compose bilan:

```bash
# Ishga tushiring
docker-compose up -d

# Browser da oching
open http://localhost:8080

# To'xtatish
docker-compose down
```

---

## 2️⃣ ARGOCD UI NI OCHISH

### A. ArgoCD ni O'rnatish (Birinchi marta)

```bash
# 1. ArgoCD ni o'rnating
./argocd/install.sh

# Yoki manual:
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# 2. ArgoCD tayyor bo'lishini kuting
kubectl wait --for=condition=available --timeout=300s deployment/argocd-server -n argocd
```

### B. Admin Password ni Oling

```bash
# Password ni oling
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
echo ""

# Yoki:
argocd admin initial-password -n argocd
```

### C. ArgoCD UI ga Kiring

#### Usul 1: Port Forward (Eng Oson)

```bash
# Port forward qiling
kubectl port-forward svc/argocd-server -n argocd 8080:443

# Browser da oching (yangi terminal oching)
open https://localhost:8080

# Login:
# Username: admin
# Password: (yuqorida olgan password)
```

#### Usul 2: LoadBalancer (Cloud)

```bash
# Service ni LoadBalancer ga o'zgartiring
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

# External IP ni oling
kubectl get svc argocd-server -n argocd

# Browser da oching
# https://<EXTERNAL-IP>
```

#### Usul 3: NodePort (Lokal Kubernetes)

```bash
# Service ni NodePort ga o'zgartiring
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "NodePort"}}'

# Port ni oling
kubectl get svc argocd-server -n argocd

# Browser da oching
# https://localhost:<NODE-PORT>
```

---

## 3️⃣ ARGOCD CLI BILAN ISHLASH

### ArgoCD CLI ni O'rnatish

```bash
# macOS
brew install argocd

# Linux
curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
chmod +x /usr/local/bin/argocd

# Windows (PowerShell)
# https://github.com/argoproj/argo-cd/releases/latest dan yuklab oling
```

### ArgoCD ga Login

```bash
# Port forward ishga tushiring (birinchi terminal)
kubectl port-forward svc/argocd-server -n argocd 8080:443

# Login qiling (ikkinchi terminal)
argocd login localhost:8080

# Username: admin
# Password: (kubectl bilan olgan password)
```

### Application Deploy Qilish

```bash
# Application yarating
kubectl apply -f argocd/application.yaml

# Yoki CLI bilan:
argocd app create devops-portfolio \
  --repo https://github.com/ogash3103/DevOps_Docker.git \
  --path k8s \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace default \
  --sync-policy automated
```

### Application Statusini Ko'rish

```bash
# Barcha applicationlar
argocd app list

# Bitta application
argocd app get devops-portfolio

# Sync qilish
argocd app sync devops-portfolio

# Logs ko'rish
argocd app logs devops-portfolio
```

---

## 4️⃣ KUBERNETES CLUSTER YARATISH (Agar yo'q bo'lsa)

### Minikube (Eng Oson)

```bash
# O'rnatish (macOS)
brew install minikube

# Cluster yaratish
minikube start

# Dashboard
minikube dashboard

# ArgoCD UI uchun tunnel
minikube service argocd-server -n argocd
```

### Kind (Kubernetes in Docker)

```bash
# O'rnatish (macOS)
brew install kind

# Cluster yaratish
kind create cluster --name devops-cluster

# Cluster o'chirish
kind delete cluster --name devops-cluster
```

### Docker Desktop Kubernetes

```bash
# Docker Desktop > Settings > Kubernetes > Enable Kubernetes
# Restart Docker Desktop
# kubectl cluster-info
```

---

## 5️⃣ WEBSITE NI KUBERNETES DA OCHISH

### Application Deploy Qilish

```bash
# 1. Application deploy qiling
kubectl apply -f argocd/application.yaml

# 2. Pods statusini tekshiring
kubectl get pods -l app=devops-portfolio

# 3. Service ni tekshiring
kubectl get svc devops-portfolio-service
```

### Website ga Kirish

#### Usul 1: Port Forward

```bash
# Port forward
kubectl port-forward svc/devops-portfolio-service 8081:80

# Browser da oching
open http://localhost:8081
```

#### Usul 2: LoadBalancer (Cloud)

```bash
# External IP ni oling
kubectl get svc devops-portfolio-service

# Browser da oching
# http://<EXTERNAL-IP>
```

#### Usul 3: Minikube

```bash
# Minikube tunnel
minikube service devops-portfolio-service
```

---

## 6️⃣ FOYDALI BUYRUQLAR

### Docker

```bash
# Barcha containerlarni ko'rish
docker ps -a

# Container to'xtatish
docker stop <container-name>

# Container o'chirish
docker rm <container-name>

# Image o'chirish
docker rmi <image-name>

# Logs ko'rish
docker logs <container-name>

# Container ichiga kirish
docker exec -it <container-name> sh
```

### Kubernetes

```bash
# Pods
kubectl get pods
kubectl describe pod <pod-name>
kubectl logs <pod-name>
kubectl delete pod <pod-name>

# Services
kubectl get svc
kubectl describe svc <service-name>

# Deployments
kubectl get deployments
kubectl scale deployment devops-portfolio --replicas=3

# Namespace
kubectl get namespaces
kubectl get all -n argocd
```

### ArgoCD

```bash
# Application list
argocd app list

# Application details
argocd app get devops-portfolio

# Sync
argocd app sync devops-portfolio

# Rollback
argocd app rollback devops-portfolio

# Delete
argocd app delete devops-portfolio

# Password reset
argocd account update-password
```

---

## 7️⃣ TROUBLESHOOTING

### ArgoCD UI ochilmasa:

```bash
# 1. ArgoCD pods statusini tekshiring
kubectl get pods -n argocd

# 2. Logs ko'ring
kubectl logs -n argocd deployment/argocd-server

# 3. Port forward qayta ishga tushiring
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

### Website ochilmasa:

```bash
# 1. Container statusini tekshiring
docker ps

# 2. Logs ko'ring
docker logs <container-name>

# 3. Port band emasligini tekshiring
lsof -i :8080

# 4. Qayta ishga tushiring
docker restart <container-name>
```

### Kubernetes muammolari:

```bash
# 1. Cluster statusini tekshiring
kubectl cluster-info

# 2. Pods statusini tekshiring
kubectl get pods -A

# 3. Events ko'ring
kubectl get events --sort-by='.lastTimestamp'

# 4. Describe qiling
kubectl describe pod <pod-name>
```

---

## 8️⃣ CLEANUP (Tozalash)

### Docker

```bash
# Barcha containerlarni to'xtatish
docker stop $(docker ps -aq)

# Barcha containerlarni o'chirish
docker rm $(docker ps -aq)

# Ishlatilmayotgan imagelarni o'chirish
docker image prune -a
```

### Kubernetes

```bash
# Application o'chirish
kubectl delete -f argocd/application.yaml

# Deployment o'chirish
kubectl delete deployment devops-portfolio

# Service o'chirish
kubectl delete svc devops-portfolio-service
```

### ArgoCD

```bash
# ArgoCD o'chirish
kubectl delete -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl delete namespace argocd
```

---

## 🎯 TEZKOR BOSHLASH

### Website ni ochish (30 soniya):

```bash
docker build -t devops-portfolio . && docker run -d -p 8080:80 devops-portfolio && open http://localhost:8080
```

### ArgoCD ni ochish (1 daqiqa):

```bash
# Terminal 1: Port forward
kubectl port-forward svc/argocd-server -n argocd 8080:443

# Terminal 2: Password oling va browser oching
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo "" && open https://localhost:8080
```

---

**ESLATMA:** 
- ArgoCD uchun Kubernetes cluster kerak
- Website uchun faqat Docker yetarli
- Port raqamlarini o'zgartirishingiz mumkin (8080, 8081, etc.)
