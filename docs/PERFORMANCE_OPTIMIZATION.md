# Performance Optimization Guide

## Performance Testing Tools

### 1. Google PageSpeed Insights
- URL: https://pagespeed.web.dev/
- Tests both mobile and desktop performance
- Provides Core Web Vitals metrics
- Offers specific optimization recommendations

### 2. GTmetrix
- URL: https://gtmetrix.com/
- Detailed performance analysis
- Waterfall chart for resource loading
- Historical performance tracking

### 3. Lighthouse (Chrome DevTools)
- Built into Chrome browser
- Press F12 > Lighthouse tab
- Comprehensive audits for performance, accessibility, SEO
- Can run locally before deployment

### 4. WebPageTest
- URL: https://www.webpagetest.org/
- Advanced testing options
- Multiple location testing
- Connection speed simulation

## Optimization Techniques

### 1. Image Optimization

#### Compression
```bash
# Using TinyPNG (online tool)
# Visit https://tinypng.com/
# Upload images and download compressed versions

# Using ImageOptim (Mac)
# Drag and drop images to optimize

# Using command line (ImageMagick)
convert input.jpg -quality 85 output.jpg
```

#### WebP Format
```html
<!-- Use picture element for WebP with fallback -->
<picture>
  <source srcset="image.webp" type="image/webp">
  <img src="image.jpg" alt="Description">
</picture>
```

#### Lazy Loading
```html
<!-- Add loading="lazy" attribute -->
<img src="image.jpg" alt="Description" loading="lazy">
```

### 2. CSS Optimization

#### Minification
```bash
# Using online tools
# Visit https://cssminifier.com/

# Using npm package
npm install -g clean-css-cli
cleancss -o style.min.css style.css
```

#### Critical CSS
Extract and inline critical CSS for above-the-fold content:
```html
<head>
  <style>
    /* Critical CSS here */
    body { margin: 0; font-family: sans-serif; }
    .hero { padding: 2rem; }
  </style>
  <link rel="preload" href="style.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
</head>
```

### 3. JavaScript Optimization

#### Minification
```bash
# Using online tools
# Visit https://javascript-minifier.com/

# Using Terser
npm install -g terser
terser main.js -o main.min.js
```

#### Defer Non-Critical Scripts
```html
<!-- Defer script loading -->
<script src="main.js" defer></script>

<!-- Or async for independent scripts -->
<script src="analytics.js" async></script>
```

### 4. Caching Configuration

#### Nginx Configuration
Create `nginx.conf` for Docker:
```nginx
server {
    listen 80;
    server_name localhost;
    root /usr/share/nginx/html;
    index index.html;

    # Enable gzip compression
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types text/plain text/css text/xml text/javascript application/javascript application/xml+rss application/json;

    # Cache static assets
    location ~* \.(jpg|jpeg|png|gif|ico|css|js|svg|woff|woff2)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # HTML files - short cache
    location ~* \.html$ {
        expires 1h;
        add_header Cache-Control "public, must-revalidate";
    }

    # Error pages
    error_page 404 /404.html;
}
```

### 5. Resource Hints

#### Preconnect
```html
<!-- Preconnect to external domains -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://www.google-analytics.com">
```

#### DNS Prefetch
```html
<!-- DNS prefetch for external resources -->
<link rel="dns-prefetch" href="https://fonts.googleapis.com">
```

#### Preload
```html
<!-- Preload critical resources -->
<link rel="preload" href="style.css" as="style">
<link rel="preload" href="main.js" as="script">
```

## Performance Metrics Explained

### Core Web Vitals

#### Largest Contentful Paint (LCP)
- Measures loading performance
- Should occur within 2.5 seconds
- Optimize by:
  - Reducing server response time
  - Optimizing images
  - Removing render-blocking resources

#### First Input Delay (FID)
- Measures interactivity
- Should be less than 100ms
- Optimize by:
  - Minimizing JavaScript execution
  - Breaking up long tasks
  - Using web workers

#### Cumulative Layout Shift (CLS)
- Measures visual stability
- Should be less than 0.1
- Optimize by:
  - Setting image dimensions
  - Reserving space for ads
  - Avoiding inserting content above existing content

### Other Important Metrics

#### First Contentful Paint (FCP)
- Time until first content appears
- Target: < 1.8 seconds

#### Time to Interactive (TTI)
- Time until page is fully interactive
- Target: < 3.8 seconds

#### Total Blocking Time (TBT)
- Time page is blocked from responding
- Target: < 200ms

## Optimization Checklist

### Images
- [ ] Compress all images
- [ ] Use appropriate formats (WebP, JPEG, PNG)
- [ ] Implement lazy loading
- [ ] Set width and height attributes
- [ ] Use responsive images with srcset

### CSS
- [ ] Minify CSS files
- [ ] Remove unused CSS
- [ ] Inline critical CSS
- [ ] Use CSS containment
- [ ] Avoid @import

### JavaScript
- [ ] Minify JavaScript files
- [ ] Remove unused code
- [ ] Defer non-critical scripts
- [ ] Use code splitting
- [ ] Minimize third-party scripts

### Fonts
- [ ] Use system fonts when possible
- [ ] Subset custom fonts
- [ ] Use font-display: swap
- [ ] Preload critical fonts

### Caching
- [ ] Configure browser caching
- [ ] Use CDN for static assets
- [ ] Implement service workers
- [ ] Enable gzip/brotli compression

### HTML
- [ ] Minimize HTML
- [ ] Remove comments
- [ ] Reduce DOM size
- [ ] Use semantic HTML

## Testing Workflow

### 1. Baseline Testing
```bash
# Run Lighthouse
lighthouse https://your-site.com --output html --output-path ./baseline-report.html

# Test with PageSpeed Insights
# Visit https://pagespeed.web.dev/
# Enter your URL and run test
```

### 2. Implement Optimizations
Apply optimization techniques from this guide.

### 3. Re-test
```bash
# Run Lighthouse again
lighthouse https://your-site.com --output html --output-path ./optimized-report.html

# Compare results
```

### 4. Document Results
Create comparison table:
| Metric | Before | After | Improvement |
|--------|--------|-------|-------------|
| Performance Score | 72 | 94 | +22 |
| FCP | 2.1s | 1.2s | 43% |
| LCP | 3.8s | 1.9s | 50% |

## Monitoring Performance

### Continuous Monitoring
- Set up Lighthouse CI in GitHub Actions
- Monitor Core Web Vitals in Google Analytics
- Track performance budgets
- Alert on performance regressions

### Performance Budget Example
```json
{
  "budget": [
    {
      "resourceSizes": [
        { "resourceType": "script", "budget": 300 },
        { "resourceType": "image", "budget": 500 },
        { "resourceType": "stylesheet", "budget": 100 }
      ]
    }
  ]
}
```

## Common Performance Issues

### Issue 1: Large Images
**Symptom**: Slow LCP, large page size
**Solution**: Compress images, use WebP, implement lazy loading

### Issue 2: Render-Blocking Resources
**Symptom**: Slow FCP, poor performance score
**Solution**: Defer JavaScript, inline critical CSS, use async/defer

### Issue 3: Too Many HTTP Requests
**Symptom**: Slow page load, high TBT
**Solution**: Combine files, use sprites, implement HTTP/2

### Issue 4: No Caching
**Symptom**: Slow repeat visits
**Solution**: Configure cache headers, use service workers

### Issue 5: Large JavaScript Bundles
**Symptom**: Slow TTI, high FID
**Solution**: Code splitting, tree shaking, lazy loading

## Resources

- [Web.dev Performance](https://web.dev/performance/)
- [MDN Web Performance](https://developer.mozilla.org/en-US/docs/Web/Performance)
- [Google PageSpeed Insights](https://pagespeed.web.dev/)
- [WebPageTest Documentation](https://docs.webpagetest.org/)
- [Lighthouse Documentation](https://developer.chrome.com/docs/lighthouse/)

## Next Steps

1. Run baseline performance tests
2. Implement optimizations from this guide
3. Re-test and document improvements
4. Set up continuous performance monitoring
5. Establish performance budgets
6. Regularly review and optimize
