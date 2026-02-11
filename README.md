# DevOps Portfolio Project

## Project Overview
This is a comprehensive DevOps portfolio website demonstrating modern DevOps practices including CI/CD, containerization, monitoring, and performance optimization.

## Author
Portfolio Owner: Ogabek

## Technology Stack
- Frontend: HTML, CSS, JavaScript (Static Website)
- Version Control: Git & GitHub
- CI/CD: GitHub Actions
- GitOps: ArgoCD
- Containerization: Docker
- Orchestration: Kubernetes
- Hosting: GitHub Pages / Kubernetes
- Monitoring: Google Analytics, UptimeRobot
- Performance Testing: Google PageSpeed Insights, Lighthouse

## Project Structure
```
devops-portfolio/
├── src/                    # Source code
│   ├── index.html         # Home page
│   ├── skills.html        # Skills page
│   ├── blog.html          # Blog section
│   ├── contact.html       # Contact page
│   ├── css/               # Stylesheets
│   └── js/                # JavaScript files
├── assets/                # Images and media
├── docs/                  # Documentation
├── .github/
│   └── workflows/         # CI/CD pipelines
├── Dockerfile             # Container configuration
├── docker-compose.yml     # Docker compose setup
├── .gitignore            # Git ignore rules
└── README.md             # This file
```

## DevOps Practices Demonstrated
1. Version Control with Git branching strategy
2. Automated CI/CD pipeline with GitHub Actions
3. Container-based deployment with Docker
4. GitOps with ArgoCD for Kubernetes deployments
5. Real-time monitoring and analytics
6. Performance testing and optimization
7. Infrastructure as Code (IaC)

## Live Website
🌐 [Live Portfolio](https://ogash3103.github.io/DevOps_Docker/)

## Docker Hub
🐳 [Docker Hub Repository](https://hub.docker.com/r/ogabek0331/devops-portfolio)

## Quick Start

**New to this project?** Check out the [Quick Start Guide](docs/QUICK_START.md) for step-by-step instructions!

### Prerequisites
- Git
- GitHub account
- Docker (for containerization)
- Docker Hub account (for image hosting)

### Local Development
```bash
# Clone the repository
git clone https://github.com/ogash3103/DevOps_Docker.git

# Navigate to project directory
cd DevOps_Docker

# Option 1: Open directly in browser
open src/index.html

# Option 2: Use Python HTTP server
cd src && python3 -m http.server 8000
# Visit http://localhost:8000
```

### Docker Deployment
```bash
# Build Docker image
docker build -t devops-portfolio .

# Run container
docker run -d -p 8080:80 --name devops-portfolio devops-portfolio

# Or use Docker Compose
docker-compose up -d
```

## Branching Strategy
- `main` - Production-ready code
- `development` - Integration branch for features
- `feature/*` - Individual feature branches

## CI/CD Pipeline
Automated deployment triggered on push to main branch:
1. Code quality checks
2. Build process
3. Automated tests
4. Deploy to GitHub Pages

## Monitoring
- Analytics: Google Analytics for visitor tracking
- Uptime: UptimeRobot for availability monitoring
- Performance: Lighthouse CI for performance metrics

## Performance Optimization
- Image compression and optimization
- CSS/JS minification
- Caching headers
- Lazy loading implementation

## License
MIT License

## Documentation

- [Quick Start Guide](docs/QUICK_START.md) - Get started quickly
- [Setup Guide](docs/SETUP.md) - Detailed setup instructions
- [ArgoCD Guide](docs/ARGOCD_GUIDE.md) - GitOps with ArgoCD
- [Monitoring Setup](docs/MONITORING_SETUP.md) - Configure analytics and uptime monitoring
- [Performance Optimization](docs/PERFORMANCE_OPTIMIZATION.md) - Optimize website performance
- [Submission Guide](docs/SUBMISSION_GUIDE.md) - Complete submission checklist

## ArgoCD / Kubernetes

This project includes full Kubernetes deployment with ArgoCD GitOps:

```bash
# Install ArgoCD
./argocd/install.sh

# Deploy application
kubectl apply -f argocd/application.yaml

# Access ArgoCD UI
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

See [argocd/README.md](argocd/README.md) for detailed instructions.

## Report Templates

All report templates are available in the `docs/` folder:
- Task 1: Repository Setup and Version Control
- Task 2: CI/CD Pipeline Implementation
- Task 3: Monitoring and Analytics
- Task 4: Containerization and Environment Management
- Task 5: Performance Testing and Optimization (Final Report)

## Contact
- Email: ogabek0331@gmail.com
- LinkedIn: [linkedin.com/in/ogabek](https://linkedin.com/in/ogabek)
- GitHub: [github.com/ogash3103](https://github.com/ogash3103)
- Docker Hub: [hub.docker.com/u/ogabek0331](https://hub.docker.com/u/ogabek0331)
