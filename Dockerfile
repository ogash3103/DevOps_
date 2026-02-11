# Use official nginx image as base
# Nginx is a lightweight web server perfect for serving static content
FROM nginx:alpine

# Set maintainer label
LABEL maintainer="ogabek0331@gmail.com"
LABEL description="DevOps Portfolio Website - Ogabek"

# Remove default nginx website
RUN rm -rf /usr/share/nginx/html/*

# Copy our website files to nginx html directory
COPY src/ /usr/share/nginx/html/

# Copy custom nginx configuration (optional)
# COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80 for web traffic
EXPOSE 80

# Health check to ensure container is running properly
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --quiet --tries=1 --spider http://localhost/ || exit 1

# Start nginx in foreground mode
# The daemon off directive keeps nginx running in the foreground
CMD ["nginx", "-g", "daemon off;"]
