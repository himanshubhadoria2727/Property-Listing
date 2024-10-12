# Use the official PHP image
FROM php:8.1-fpm

# Install system dependencies and PHP extensions
RUN apt-get update && apt-get install -y \
    libpq-dev \
    libzip-dev \
    libjpeg-dev \
    libpng-dev \
    libfreetype6-dev \
    libonig-dev \
    libxslt1-dev \
    libxml2-dev \
    zlib1g-dev \
    libssl-dev \
    unzip \
    && docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd pdo pdo_pgsql zip calendar

# Set the working directory
WORKDIR /var/www

# Copy the application files
COPY . .

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install application dependencies
RUN composer install --no-interaction --prefer-dist

# Expose the port the app runs on
EXPOSE 9000

# Start the PHP-FPM server
CMD ["php-fpm"]
