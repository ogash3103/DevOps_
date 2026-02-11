# Setup Guide

## Prerequisites

Before you begin, ensure you have the following installed:
- Git
- Docker and Docker Compose
- A GitHub account
- A Docker Hub account

## Local Development Setup

### 1. Clone the Repository

```bash
git clone https://github.com/[username]/devops-portfolio-[yourname].git
cd devops-portfolio-[yourname]
```

### 2. View the Website Locally

You can open the HTML files directly in your browser:

```bash
# On macOS
open src/index.html

# On Linux
xdg-open src/index.html

# On Windows
start src/index.html
```

Or use a simple HTTP server:

```bash
# Using Python 3
cd src
python3 -m http.server 8000

# Using Node.js (if you have http-server installed)
npx http-server src -p 8000
```

Then visit `http://localhost:8000` in your browser.

### 3. Docker Setup

Build and run the Docker container:

```bash
# Build the image
docker build -t devops-portfolio .

# Run the container
docker run -d -p 8080:80 --name devops-portfolio devops-portfolio

# View the website
open http://localhost:8080
```

Or use Docker Compose:

```bash
# Start the container
docker-compose up -d

# View logs
docker-compose logs -f

# Stop the container
docker-compose down
```

## Deployment Setup

### GitHub Pages Deployment

1. Go to your GitHub repository settings
2. Navigate to "Pages" section
3. Set source to "gh-pages" branch
4. Save the settings
5. Your site will be available at `https://[username].github.io/[repository-name]/`

### Docker Hub Deployment

1. Login to Docker Hub:
```bash
docker login
```

2. Tag your image:
```bash
docker tag devops-portfolio [dockerhub-username]/devops-portfolio:latest
```

3. Push to Docker Hub:
```bash
docker push [dockerhub-username]/devops-portfolio:latest
```

## Monitoring Setup

### Google Analytics

1. Create a Google Analytics account
2. Get your tracking ID
3. Add the tracking code to all HTML files before `</head>`:

```html
<!-- Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=GA_MEASUREMENT_ID"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'GA_MEASUREMENT_ID');
</script>
```

### UptimeRobot

1. Sign up at uptimerobot.com
2. Add a new monitor with your website URL
3. Configure alert settings

## Troubleshooting

### Docker Issues

If Docker build fails:
```bash
# Clean up Docker
docker system prune -a

# Rebuild without cache
docker build --no-cache -t devops-portfolio .
```

### GitHub Actions Issues

If deployment fails:
1. Check GitHub Actions logs
2. Ensure GitHub Pages is enabled
3. Verify branch permissions

## Next Steps

1. Customize the content with your information
2. Add your own blog posts
3. Configure monitoring tools
4. Run performance tests
5. Document your DevOps journey
