# Use PHP 8.0 base image
FROM php:8.0

# Set working directory
WORKDIR /var/www/html

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

# Copy your PHP application files into the working directory (if needed)
# COPY . /var/www/html

# Expose port 80 (if needed)
# EXPOSE 80

# Command to run PHP application (if needed)
# CMD ["php", "-S", "0.0.0.0:80"]
