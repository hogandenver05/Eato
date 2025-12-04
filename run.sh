#!/bin/bash

echo "Starting Laravel deployment script"

# Stop on first error
set -e

# Step one: check for Composer
if ! command -v composer >/dev/null 2>&1; then
    echo "Composer is not installed"
    exit 1
fi

echo "Composer detected"

# Step two: install dependencies
echo "Installing Composer dependencies"
composer install

# Step three: copy environment file if missing
if [ ! -f .env ]; then
    echo "Creating environment file"
    cp .env.example .env
fi

# Step four: generate application key
echo "Generating application key"
php artisan key:generate

# Step five: verify database settings
echo "Checking database connection"
php -r "
// Load .env file
\$envFile = __DIR__ . '/.env';
if (!file_exists(\$envFile)) {
    echo 'Error: .env file not found' . PHP_EOL;
    exit(1);
}

\$env = [];
foreach (file(\$envFile) as \$line) {
    \$line = trim(\$line);
    if (empty(\$line) || \$line[0] === '#') continue;
    if (strpos(\$line, '=') === false) continue;
    list(\$key, \$value) = explode('=', \$line, 2);
    \$key = trim(\$key);
    \$value = trim(\$value);
    // Remove quotes if present
    if ((substr(\$value, 0, 1) === '\"' && substr(\$value, -1) === '\"') || 
        (substr(\$value, 0, 1) === \"'\" && substr(\$value, -1) === \"'\")) {
        \$value = substr(\$value, 1, -1);
    }
    \$env[\$key] = \$value;
}

\$host = \$env['DB_HOST'] ?? '127.0.0.1';
\$port = \$env['DB_PORT'] ?? '3306';
\$database = \$env['DB_DATABASE'] ?? '';
\$username = \$env['DB_USERNAME'] ?? 'root';
\$password = \$env['DB_PASSWORD'] ?? '';

if (empty(\$database)) {
    echo 'Error: DB_DATABASE not set in .env file' . PHP_EOL;
    exit(1);
}

try {
    \$dsn = 'mysql:host=' . \$host . ';port=' . \$port . ';dbname=' . \$database;
    \$pdo = new PDO(\$dsn, \$username, \$password);
    \$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    // Test the connection
    \$pdo->query('SELECT 1');
    echo 'Database connection successful' . PHP_EOL;
    exit(0);
} catch (Exception \$e) {
    echo 'Database connection failed: ' . \$e->getMessage() . PHP_EOL;
    exit(1);
}
" || {
    echo "Database connection failed"
    exit 1
}

# Step six: run migrations
echo "Running migrations"
php artisan migrate

# Step seven: clear caches
echo "Clearing caches"
php artisan optimize:clear

# Step eight: storage and permissions setup
echo "Fixing storage and cache permissions"

mkdir -p storage/framework/cache
mkdir -p storage/framework/sessions
mkdir -p storage/framework/views

chmod -R 775 storage
chmod -R 775 bootstrap/cache

echo "Permissions updated"

# Step nine: start Laravel development server
echo "Starting server at http://localhost:8000"
php artisan serve
