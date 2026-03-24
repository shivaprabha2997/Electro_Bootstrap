FROM nginx:latest

# Copy HTML files
COPY index.html /usr/share/nginx/html/

# Expose port
EXPOSE 80
