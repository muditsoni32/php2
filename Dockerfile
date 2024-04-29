# Use Red Hat 8 base image
FROM registry.access.redhat.com/ubi8/ubi:latest

# Install NGINX and PHP 8.0 with FPM
RUN yum install -y nginx php php-fpm && \
    yum clean all && \
    rm -rf /var/cache/yum

# Set the working directory
WORKDIR /var/www/html

# Remove default NGINX configuration
RUN rm -rf /etc/nginx/conf.d/default.conf

# Copy NGINX configuration file
COPY nginx.conf /etc/nginx/conf.d/

# Install PHP extensions and dependencies
RUN yum install -y \
        php-gd \
        php-pdo \
        php-mysqlnd \
        php-zip && \
    yum clean all && \
    rm -rf /var/cache/yum

# Copy your PHP application files into the working directory (if needed)
COPY index.php /var/www/html/

# Expose ports for HTTP and PHP-FPM
EXPOSE 80 9000

# Start NGINX and PHP-FPM
CMD nginx && php-fpm && tail -f /var/log/nginx/access.log
