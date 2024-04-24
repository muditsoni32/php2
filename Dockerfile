# Use Ubuntu 20.04 base image
FROM ubuntu:20.04

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Install software-properties-common and add PHP repository
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:ondrej/php && \
    apt-get update

# Install NGINX and PHP 8.0 with FPM
RUN apt-get install -y nginx php8.0-fpm php8.0

# Clear apt cache to reduce image size
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /var/www/
RUN rm -rf /etc/nginx/sites-enabled/default

# Separate apt-get update command
RUN apt-get update

# Install PHP extensions and dependencies
RUN apt-get install -y \
        libfreetype6-dev \
        libjpeg-dev \
        libpng-dev \
        libzip-dev \
        unzip \
        php8.0-gd \
        php8.0-pdo \
        php8.0-mysqli \
        php8.0-zip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy NGINX configuration file
COPY nginx.conf /etc/nginx/sites-enabled/

# Copy your PHP application files into the working directory (if needed)
COPY hello.php /var/www/

# Expose ports for HTTP and PHP-FPM
EXPOSE 80 9000

# Command to run the PHP application
CMD ["nginx", "-g", "daemon off;"]
