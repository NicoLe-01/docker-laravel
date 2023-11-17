# Gunakan image resmi PHP
FROM php:8.1-apache

# Set direktori kerja
WORKDIR /var/www

# Salin seluruh proyek Laravel ke dalam kontainer
COPY . .

# Install dependensi menggunakan Composer
RUN apt-get update && \
    apt-get install -y \
        libzip-dev \
        unzip \
        && docker-php-ext-install zip pdo_mysql

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install dependensi proyek Laravel
RUN composer install --no-interaction --no-plugins --no-scripts

# Setelah instalasi, jika Anda memiliki file .env, salin ke dalam kontainer
COPY .env.example .env

# Generate key aplikasi Laravel
RUN php artisan key:generate

# Expose port 80 untuk Apache
EXPOSE 80

# Perintah yang dijalankan ketika kontainer dijalankan
CMD ["apache2-foreground", "-D", "FOREGROUND", "-e", "info", "ServerName=localhost"]
