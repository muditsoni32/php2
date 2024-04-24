# Use PHP 8.0 base image
FROM ubuntu:20.04

# Install NGINX
RUN apt-get update && \
    apt-get install -y nginx && \
    apt-get install -y php8.0-fpm php8.0 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /var/www/
RUN rm -rf /etc/nginx/sites-enabled/default

# Install PHP extensions and dependencies
RUN apt-get update && \
    apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libzip-dev \
        unzip \
        && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install -j$(nproc) gd pdo_mysql mysqli zip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy NGINX configuration file
COPY nginx.conf /etc/nginx/sites-enabled/

# Copy your PHP application files into the working directory (if needed)
COPY hello.php /var/www/

# Expose port 80
EXPOSE 80
EXPOSE 9000
# Command to run PHP application
CMD ["nginx", "-g", "daemon off;"]
