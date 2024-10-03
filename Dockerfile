# Step 1: Use the official PHP image with necessary extensions
FROM php:8.1-fpm

# Step 2: Set working directory
WORKDIR /var/www/html

# Step 3: Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl \
    libpq-dev \
    libonig-dev

# Step 4: Install extensions
RUN docker-php-ext-install pdo pdo_pgsql mbstring exif pcntl bcmath gd

# Step 5: Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Step 6: Copy the Laravel project files
COPY . .

# Step 7: Install Laravel dependencies
RUN composer install

# Step 8: Copy the existing entrypoint script (used to serve Laravel)
COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Step 9: Expose port (default for Laravel is 8000)
EXPOSE 8000

# Step 10: Start the entrypoint script
ENTRYPOINT ["entrypoint.sh"]
CMD ["php-fpm"]

# PostgreSQL Service
FROM postgres:13

# Set environment variables
ENV POSTGRES_USER="root"
ENV POSTGRES_PASSWORD=""
ENV POSTGRES_DB="hously"

EXPOSE 5432
