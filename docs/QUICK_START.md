# Quick Start Guide

This guide will help you get started with the DevOps Portfolio project quickly.

## Prerequisites

- Git installed
- GitHub account
- Docker installed (optional, for containerization)
- Text editor or IDE

## Step-by-Step Setup

### 1. Create GitHub Repository

```bash
# Create a new repository on GitHub named: devops-portfolio-[yourname]
# Make it public
# Don't initialize with README (we already have one)
```

### 2. Push to GitHub

```bash
# Add remote origin (replace with your GitHub username and repo name)
git remote add origin https://github.com/[username]/devops-portfolio-[yourname].git

# Push all branches
git push -u origin main
git push origin development
git push origin --all
```

### 3. Enable GitHub Pages

1. Go to repository Settings
2. Navigate to "Pages" section
3. Under "Source", select "Deploy from a branch"
4. Select "gh-pages" branch (will be created after first workflow run)
5. Click Save

### 4. Customize Content

Update the following with your information:

#### README.md
- Replace `[Your Name]` with your actual name
- Update contact information
- Add your GitHub username

#### src/index.html, skills.html, blog.html, contact.html
- Update personal information
- Add your skills and experience
- Customize blog posts
- Update contact details

#### links.txt
- Replace `[username]` with your GitHub username
- Replace `[yourname]` with your name

### 5. Test Locally

```bash
# Option 1: Open directly in browser
open src/index.html

# Option 2: Use Python HTTP server
cd src
python3 -m http.server 8000
# Visit http://localhost:8000

# Option 3: Use Docker
docker build -t devops-portfolio .
docker run -p 8080:80 devops-portfolio
# Visit http://localhost:8080
```

### 6. Make Your First Commit

```bash
# Create a new branch
git checkout -b feature/customize-content

# Make changes to files
# ... edit files ...

# Commit changes
git add .
git commit -m "feat: Customize portfolio with personal information"

# Push to GitHub
git push origin feature/customize-content

# Merge to main (or create pull request on GitHub)
git checkout main
git merge feature/customize-content
git push origin main
```

### 7. Watch CI/CD Pipeline

1. Go to your GitHub repository
2. Click "Actions" tab
3. Watch the workflow run
4. After successful completion, your site will be live!

### 8. Access Your Live Website

Your website will be available at:
```
https://[username].github.io/devops-portfolio-[yourname]/
```

## Next Steps

### Task 1: Version Control ✅
- [x] Repository created
- [ ] Minimum 10 commits
- [ ] Branch structure demonstrated
- [ ] Take screenshots
- [ ] Write report

### Task 2: CI/CD Pipeline
- [ ] Verify workflow runs successfully
- [ ] Intentionally break something to show failed workflow
- [ ] Fix and show successful workflow
- [ ] Take screenshots
- [ ] Write report

### Task 3: Monitoring
- [ ] Set up Google Analytics
- [ ] Set up UptimeRobot
- [ ] Collect data for 1 week
- [ ] Take screenshots
- [ ] Record video
- [ ] Write report

### Task 4: Docker
- [ ] Build Docker image locally
- [ ] Test container
- [ ] Push to Docker Hub
- [ ] Take screenshots
- [ ] Record video
- [ ] Write report

### Task 5: Performance
- [ ] Run baseline tests
- [ ] Implement optimizations
- [ ] Re-test and compare
- [ ] Take screenshots
- [ ] Record final video
- [ ] Write final report

## Common Commands

### Git Commands
```bash
# Check status
git status

# View branches
git branch -a

# Create new branch
git checkout -b feature/new-feature

# Commit changes
git add .
git commit -m "description"

# Push to GitHub
git push origin branch-name

# Merge branch
git checkout main
git merge feature/new-feature
```

### Docker Commands
```bash
# Build image
docker build -t devops-portfolio .

# Run container
docker run -d -p 8080:80 --name portfolio devops-portfolio

# View running containers
docker ps

# Stop container
docker stop portfolio

# Remove container
docker rm portfolio

# View logs
docker logs portfolio

# Push to Docker Hub
docker login
docker tag devops-portfolio [username]/devops-portfolio:latest
docker push [username]/devops-portfolio:latest
```

### Docker Compose Commands
```bash
# Start services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down

# Rebuild and start
docker-compose up -d --build
```

## Troubleshooting

### GitHub Pages Not Working
- Wait 5-10 minutes after first deployment
- Check Actions tab for workflow errors
- Verify gh-pages branch exists
- Check repository settings

### Docker Build Fails
- Ensure Dockerfile is in root directory
- Check Docker is running
- Verify src/ directory exists
- Try building without cache: `docker build --no-cache -t devops-portfolio .`

### Workflow Fails
- Check Actions tab for error details
- Verify all required files exist
- Check YAML syntax in deploy.yml
- Ensure repository permissions are correct

## Getting Help

1. Check documentation in `docs/` folder
2. Review error messages carefully
3. Search GitHub Issues
4. Ask in class forums
5. Consult with instructor

## Tips for Success

1. **Commit Often**: Make small, frequent commits with clear messages
2. **Test Locally**: Always test changes before pushing
3. **Read Errors**: Error messages usually tell you what's wrong
4. **Document Everything**: Take screenshots and notes as you go
5. **Start Early**: Don't wait until the last minute
6. **Ask Questions**: Don't struggle alone - ask for help

## Resources

- [Git Documentation](https://git-scm.com/doc)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Docker Documentation](https://docs.docker.com/)
- [GitHub Pages Documentation](https://docs.github.com/en/pages)

Good luck with your DevOps journey! 🚀
