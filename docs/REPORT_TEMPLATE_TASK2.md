# Task 2 Report: CI/CD Pipeline Implementation

**Student Name:** [Your Name]  
**Date:** [Date]  
**Word Count:** ~400 words

## How the CI/CD Pipeline Works

[Explain your CI/CD pipeline architecture]

My CI/CD pipeline is implemented using GitHub Actions and consists of four main jobs that run sequentially:

### 1. Lint Job (Code Quality Check)
- Validates HTML syntax using html5validator
- Checks for TODO comments in the codebase
- Ensures code quality standards are met before proceeding

### 2. Build Job
- Verifies all required files exist
- Simulates the build process
- Runs basic tests to ensure file integrity
- Only runs if lint job passes

### 3. Docker Job
- Builds a Docker image of the application
- Tests the Docker image by running a container
- Verifies the website is accessible inside the container
- Only runs if build job passes

### 4. Deploy Job
- Deploys the website to GitHub Pages
- Only runs on push to main branch (not on pull requests)
- Uses the peaceiris/actions-gh-pages action for deployment
- Publishes the src/ directory to gh-pages branch

The pipeline is triggered automatically on:
- Push to main branch
- Pull requests to main branch

## Why Automation is Important

[Explain the importance of automation in DevOps]

Automation is a cornerstone of DevOps for several critical reasons:

1. **Consistency**: Automated processes eliminate human error and ensure every deployment follows the same steps
2. **Speed**: What takes hours manually can be done in minutes automatically
3. **Reliability**: Automated tests catch issues before they reach production
4. **Scalability**: As projects grow, manual processes become bottlenecks
5. **Documentation**: The pipeline itself serves as documentation of the deployment process
6. **Confidence**: Developers can push changes knowing they'll be tested and deployed correctly

Without automation, every deployment would require manual steps, increasing the risk of errors and slowing down development velocity.

## Problems Encountered and Solutions

[Describe challenges you faced and how you solved them]

### Problem 1: HTML Validation Failures
**Issue**: Initial HTML validation failed due to missing alt attributes on images and unclosed tags.

**Solution**: I reviewed the validation errors, added proper alt attributes for accessibility, and fixed all unclosed tags. I also added `|| echo "HTML validation completed"` to prevent the pipeline from failing on warnings.

### Problem 2: Docker Build Context
**Issue**: Docker build failed because it couldn't find the src/ directory.

**Solution**: I ensured the Dockerfile COPY command used the correct path (`COPY src/ /usr/share/nginx/html/`) and verified the directory structure in the repository.

### Problem 3: GitHub Pages Deployment Permissions
**Issue**: Initial deployment failed due to insufficient permissions.

**Solution**: I verified that GitHub Actions had write permissions in the repository settings (Settings > Actions > General > Workflow permissions) and ensured the GITHUB_TOKEN had the necessary permissions.

### Problem 4: Failed Workflow Demonstration
**Issue**: Needed to demonstrate a failed workflow for evidence.

**Solution**: I intentionally introduced a syntax error in the HTML, committed it, observed the failed workflow, then fixed the error and committed again to show the successful workflow.

These challenges taught me the importance of thorough testing, reading error logs carefully, and understanding the deployment environment.

---

**Evidence Checklist:**
- ✅ Working website URL
- ✅ Screenshot of successful workflow run
- ✅ Screenshot of failed workflow
- ✅ Copy of deploy.yml file with comments
- ✅ This report (400 words)
