#!/bin/bash

# Install Composer if not present
if ! command -v composer &> /dev/null; then
    curl -sS https://getcomposer.org/installer | php
    mv composer.phar /usr/local/bin/composer
    chmod +x /usr/local/bin/composer
fi

# Install Symfony CLI
if ! command -v symfony &> /dev/null; then
    curl -sS https://get.symfony.com/cli/installer | bash
    sudo mv ~/.symfony5/bin/symfony /usr/local/bin/symfony
fi

# Install PHP extensions needed by Symfony
apt-get update
apt-get install -y php8.3-xml php8.3-curl php8.3-mbstring php8.3-zip php8.3-intl php8.3-sqlite3

# Install Node.js dependencies
npm install

# Install Composer dependencies and create Symfony project if not exists
if [ ! -f "symfony.lock" ]; then
    composer install --no-interaction
    # If this is a fresh setup, create Symfony project structure
    symfony new . --version="7.3.*" --webapp --no-git
fi

# Install additional Symfony bundles for API development
composer require symfony/serializer-pack --no-interaction
composer require symfony/validator --no-interaction
#composer require doctrine/doctrine-bundle --no-interaction
#composer require doctrine/doctrine-migrations-bundle --no-interaction

# Set permissions
chmod -R 755 var/
chmod -R 755 public/

echo "🎉 Setup complete!"
echo "Run 'symfony server:start' to start the Symfony development server"
echo "Run 'npm run dev' to start the React development server"

echo "🚀 Starting migration from src/ to src/Framework/"

# Create the new Framework directory
mkdir -p src/Framework

# Move all files from src/ to src/Framework/ (except Framework directory itself)
echo "📁 Moving files..."
find src/ -maxdepth 1 -type f -exec mv {} src/Framework/ \;
find src/ -maxdepth 1 -type d ! -name Framework ! -name src -exec mv {} src/Framework/ \;

# Update namespaces in PHP files
echo "🔄 Updating namespaces in PHP files..."
find src/Framework -name "*.php" -type f -exec sed -i 's/namespace App;/namespace App\\Framework;/g' {} \;

# Update any references in config files
echo "⚙️ Updating configuration files..."

# Update services.yaml
if [ -f "config/services.yaml" ]; then
    sed -i 's/App\\/App\\Framework\\/g' config/services.yaml
    sed -i 's/src\//src\/Framework\//g' config/services.yaml
fi

# Update routes configuration if it exists
if [ -f "config/routes.yaml" ]; then
    sed -i 's/App\\/App\\Framework\\/g' config/routes.yaml
    sed -i 's/src\//src\/Framework\//g' config/routes.yaml
fi

if [ -f "config/packages/doctrine.yaml" ]; then
    sed -i 's/App\\/App\\Framework\\/g' config/packages/doctrine.yaml
    sed -i 's/src\//src\/Framework\//g' config/packages/doctrine.yaml
fi

# Update any routing annotations or attributes files
find config/ -name "*.yaml" -o -name "*.yml" -exec sed -i 's/App\\/App\\Framework\\/g' {} \; 2>/dev/null

# Update public/index.php
if [ -f "public/index.php" ]; then
    echo "🌐 Updating public/index.php..."
    sed -i 's/App\\Kernel/App\\Framework\\Kernel/g' public/index.php
fi

# Update bin/console
if [ -f "bin/console" ]; then
    echo "🖥️ Updating bin/console..."
    sed -i 's/App\\Kernel/App\\Framework\\Kernel/g' bin/console
fi

mkdir src/Domain
mkdir src/Infrastructure
mkdir src/Application

# Regenerate Composer autoload
echo "📦 Regenerating Composer autoload..."
composer dump-autoload

echo "✅ Migration completed!"
echo ""
echo "🔍 Next steps:"
echo "1. Check that all files are in src/Framework/"
echo "2. Test your application: symfony server:start"
echo "3. Run: symfony console about"
echo "4. If you have tests, update their namespaces too"
echo ""
echo "⚠️  Don't forget to update:"
echo "- Any hardcoded references to 'App\\' in your code"
echo "- PHPUnit configuration (phpunit.xml.dist)"
echo "- Any custom configuration files"
