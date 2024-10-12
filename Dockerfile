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
    nginx \
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

# Copy Nginx configuration file
COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf

# Expose the port that Nginx will serve (port 80)
EXPOSE 80

# Start Nginx and PHP-FPM
CMD ["sh", "-c", "nginx && php-fpm"]
