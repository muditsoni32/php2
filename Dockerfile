# Use Red Hat 8 base image
FROM registry.access.redhat.com/ubi8/ubi:latest

# Install NGINX and PHP 8.0 with FPM
RUN yum install -y httpd php php-fpm && \
    yum clean all && \
    rm -rf /var/cache/yum

# Set the working directory
WORKDIR /var/www/html
RUN rm -rf /etc/httpd/conf.d/welcome.conf

# Copy Apache configuration file
COPY httpd.conf /etc/httpd/conf/httpd.conf

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

# Command to run the PHP application
CMD systemctl start httpd && php-fpm && tail -f /var/log/httpd/access_log
