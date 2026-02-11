# Docker Hub Setup Guide

## 🐳 Docker Hub ga Push Qilish

### 1. Docker Hub Account Yarating

1. https://hub.docker.com/ ga boring
2. Sign Up qiling (agar account yo'q bo'lsa)
3. Email ni verify qiling

### 2. Access Token Yarating

1. Docker Hub ga login qiling
2. Account Settings > Security ga boring
3. "New Access Token" tugmasini bosing
4. Token nomi: `github-actions`
5. Permissions: `Read, Write, Delete`
6. "Generate" tugmasini bosing
7. **Token ni copy qiling va xavfsiz joyga saqlang!** (Faqat bir marta ko'rsatiladi)

### 3. GitHub Secrets Sozlang

1. GitHub repository ga boring: https://github.com/ogash3103/DevOps_Docker
2. Settings > Secrets and variables > Actions
3. "New repository secret" tugmasini bosing

**Secret 1: DOCKERHUB_USERNAME**
- Name: `DOCKERHUB_USERNAME`
- Value: `ogabek0331` (sizning Docker Hub username)
- "Add secret" tugmasini bosing

**Secret 2: DOCKERHUB_TOKEN**
- Name: `DOCKERHUB_TOKEN`
- Value: (Docker Hub dan olgan access token)
- "Add secret" tugmasini bosing

### 4. Lokal Kompyuterdan Push Qilish

```bash
# 1. Docker Hub ga login qiling
docker login
# Username: ogabek0331
# Password: (Docker Hub password yoki token)

# 2. Image ni build qiling
docker build -t ogabek0331/devops-portfolio:latest .

# 3. Tag qo'shing (ixtiyoriy)
docker tag ogabek0331/devops-portfolio:latest ogabek0331/devops-portfolio:v1.0

# 4. Push qiling
docker push ogabek0331/devops-portfolio:latest
docker push ogabek0331/devops-portfolio:v1.0

# 5. Verify qiling
# https://hub.docker.com/r/ogabek0331/devops-portfolio
```

### 5. GitHub Actions Orqali Avtomatik Push

GitHub Actions workflow allaqachon sozlangan. Faqat secrets qo'shganingizdan keyin:

```bash
# Commit va push qiling
git add .
git commit -m "Update Docker configuration"
git push origin main

# GitHub Actions avtomatik ravishda:
# 1. Docker image build qiladi
# 2. Docker Hub ga push qiladi
# 3. Tag: latest va commit SHA
```

### 6. Tekshirish

Docker Hub da image ni tekshiring:
- URL: https://hub.docker.com/r/ogabek0331/devops-portfolio
- Tags: latest, commit SHA

### 7. Image ni Pull Qilish

Boshqa kompyuterdan yoki serverdan:

```bash
# Pull qiling
docker pull ogabek0331/devops-portfolio:latest

# Run qiling
docker run -d -p 8080:80 ogabek0331/devops-portfolio:latest

# Test qiling
curl http://localhost:8080
```

## Troubleshooting

### Login Muammosi

```bash
# Token bilan login
docker login -u ogabek0331
# Password: (access token ni kiriting)

# Yoki environment variable
export DOCKER_PASSWORD="your-token"
echo $DOCKER_PASSWORD | docker login -u ogabek0331 --password-stdin
```

### Push Muammosi

```bash
# Image nomini tekshiring
docker images | grep devops-portfolio

# To'g'ri tag qo'ying
docker tag devops-portfolio:latest ogabek0331/devops-portfolio:latest

# Qayta push qiling
docker push ogabek0331/devops-portfolio:latest
```

### GitHub Actions Muammosi

1. Repository Settings > Secrets ni tekshiring
2. DOCKERHUB_USERNAME va DOCKERHUB_TOKEN mavjudligini tasdiqlang
3. Actions tab da workflow loglarini ko'ring
4. Token permissions ni tekshiring (Read, Write, Delete)

## Best Practices

1. **Access Token Ishlating**: Password o'rniga token ishlating
2. **Tag Versiyalari**: Har bir release uchun version tag qo'shing
3. **Latest Tag**: Har doim latest tag ni yangilang
4. **Multi-arch**: Turli platformalar uchun build qiling (amd64, arm64)
5. **Image Size**: Image hajmini kichik saqlang
6. **Security Scan**: Docker Hub da security scan yoqing

## Qo'shimcha Ma'lumot

- Docker Hub Docs: https://docs.docker.com/docker-hub/
- GitHub Actions: https://docs.github.com/en/actions
- Docker Build: https://docs.docker.com/engine/reference/commandline/build/
