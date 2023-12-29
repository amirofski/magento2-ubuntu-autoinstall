#!/bin/bash

# Magento 2 Installation Script

# Set your desired Magento version and installation directory
MAGENTO_VERSION="2.4.3"
INSTALL_DIR="/var/www/html/magento"

# Update system packages
sudo apt update
sudo apt upgrade -y

# Install required packages
sudo apt install -y apache2 mariadb-server php7.4 php7.4-cli php7.4-fpm php7.4-mysql php7.4-curl php7.4-gd php7.4-intl php7.4-xsl php7.4-mbstring php7.4-zip php7.4-bcmath php7.4-json php7.4-iconv php7.4-soap php7.4-xml php7.4-simplexml php7.4-xmlreader php7.4-xmlwriter

# Enable Apache modules
sudo a2enmod rewrite
sudo systemctl restart apache2

# Create Magento database and user
sudo mysql -e "CREATE DATABASE magento;"
sudo mysql -e "CREATE USER 'magento'@'localhost' IDENTIFIED BY 'your_password';"
sudo mysql -e "GRANT ALL PRIVILEGES ON magento.* TO 'magento'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

# Download and install Magento
cd $INSTALL_DIR
composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition:$MAGENTO_VERSION .

# Configure Magento
php bin/magento setup:install --base-url=http://your_domain.com/ \
--db-host=localhost --db-name=magento --db-user=magento --db-password=your_password \
--admin-firstname=Admin --admin-lastname=User --admin-email=admin@example.com \
--admin-user=admin --admin-password=admin123 --language=en_US \
--currency=USD --timezone=America/New_York --use-rewrites=1

# Set file permissions
sudo chown -R www-data:www-data $INSTALL_DIR
sudo chmod -R 755 $INSTALL_DIR

# Enable and start services
sudo systemctl enable apache2
sudo systemctl enable mysql
sudo systemctl start apache2
sudo systemctl start mysql

echo "Magento 2 installation completed successfully!"
