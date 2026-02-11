# Monitoring Setup Guide

## Google Analytics Setup

### Step 1: Create Google Analytics Account
1. Go to https://analytics.google.com/
2. Sign in with your Google account
3. Click "Start measuring"
4. Enter account name and configure settings
5. Click "Next"

### Step 2: Set Up Property
1. Enter property name (e.g., "DevOps Portfolio")
2. Select timezone and currency
3. Click "Next"

### Step 3: Get Tracking Code
1. Select "Web" as platform
2. Enter website URL
3. Copy the tracking code (GA4 measurement ID)

### Step 4: Add to Website
Add this code to all HTML files before `</head>`:

```html
<!-- Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-XXXXXXXXXX"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'G-XXXXXXXXXX');
</script>
```

Replace `G-XXXXXXXXXX` with your actual measurement ID.

## UptimeRobot Setup

### Step 1: Create Account
1. Go to https://uptimerobot.com/
2. Sign up for free account
3. Verify email address

### Step 2: Add Monitor
1. Click "Add New Monitor"
2. Select "HTTP(s)" as monitor type
3. Enter friendly name: "DevOps Portfolio"
4. Enter URL: Your GitHub Pages URL
5. Set monitoring interval: 5 minutes (free tier)
6. Click "Create Monitor"

### Step 3: Configure Alerts
1. Go to "My Settings"
2. Add alert contacts (email, SMS, etc.)
3. Configure alert thresholds
4. Save settings

### Step 4: Create Status Page (Optional)
1. Click "Add Status Page"
2. Select monitors to include
3. Customize appearance
4. Get public URL
5. Share with stakeholders

## Custom Error Logging

The website already includes basic error logging in `src/js/main.js`:

```javascript
// Error tracking
window.addEventListener('error', function(e) {
    console.error('Error occurred:', e.error);
});

// Performance monitoring
window.addEventListener('load', function() {
    if (window.performance) {
        const perfData = window.performance.timing;
        const pageLoadTime = perfData.loadEventEnd - perfData.navigationStart;
        console.log('Page load time:', pageLoadTime + 'ms');
    }
});
```

## Monitoring Metrics to Track

### Analytics Metrics
- Page views
- Unique visitors
- Session duration
- Bounce rate
- Traffic sources
- Geographic location
- Device types (desktop/mobile/tablet)
- Browser types

### Uptime Metrics
- Availability percentage
- Response time
- Downtime events
- SSL certificate status

### Performance Metrics
- Page load time
- First Contentful Paint (FCP)
- Largest Contentful Paint (LCP)
- Time to Interactive (TTI)
- Cumulative Layout Shift (CLS)

## Viewing Monitoring Data

### Google Analytics Dashboard
1. Log in to Google Analytics
2. Select your property
3. View real-time data in "Realtime" section
4. View historical data in "Reports" section
5. Create custom reports as needed

### UptimeRobot Dashboard
1. Log in to UptimeRobot
2. View all monitors on dashboard
3. Click monitor for detailed statistics
4. View uptime percentage and response times
5. Check alert history

## Setting Up Alerts

### UptimeRobot Alerts
Configure alerts for:
- Site goes down
- Response time exceeds threshold
- SSL certificate expiring soon

### Google Analytics Alerts
Configure custom alerts for:
- Traffic drops significantly
- Unusual spike in traffic
- High bounce rate
- Specific goal completions

## Best Practices

1. **Check Regularly**: Review monitoring data at least weekly
2. **Set Realistic Thresholds**: Don't alert on every minor issue
3. **Document Incidents**: Keep log of downtime and resolutions
4. **Test Alerts**: Verify alerts are working correctly
5. **Privacy Compliance**: Ensure analytics comply with GDPR/privacy laws
6. **Backup Monitoring**: Use multiple monitoring services

## Troubleshooting

### Analytics Not Tracking
- Verify tracking code is on all pages
- Check browser console for errors
- Ensure ad blockers aren't blocking tracking
- Wait 24-48 hours for data to appear

### UptimeRobot False Alarms
- Verify website is actually accessible
- Check if monitoring interval is too aggressive
- Ensure server can handle monitoring requests
- Review alert thresholds

## Next Steps

1. Set up monitoring for all environments (dev, staging, prod)
2. Create custom dashboards for key metrics
3. Integrate monitoring with incident response procedures
4. Document monitoring setup for team members
5. Regularly review and optimize monitoring configuration
