FROM php:8.2-cli

# install system packages
RUN apt-get update && apt-get install -y \
    curl \
    zip \
    unzip \
    git \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    iputils-ping \
    && docker-php-ext-install pdo pdo_mysql zip

# install composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# set working directory
WORKDIR /var/www/html

# copy application
COPY . .

# mark the working directory as safe
RUN git config --global --add safe.directory /var/www/html

# install dependencies
RUN composer install

# set permissions
RUN chmod -R 775 storage bootstrap/cache

CMD php artisan serve --host=0.0.0.0 --port=8000
