# Makefile Commands

This document provides a comprehensive reference for all available Makefile commands in the Docker development environment.

---

## 🔧 Setup & Configuration

### `make init-env`
**Purpose**: Initialize environment files  
**Usage**: First-time setup or when `.env` is missing

```bash
make init-env
```

**What it does**:
- Creates `.env` from `.env.example` (if available)
- Sets up Docker configuration section in root `.env`
- Prepares environment for Docker services

### `make sync-env`
**Purpose**: Sync Docker configuration to root `.env`  
**Usage**: Automatic with most commands, can be run manually

```bash
make sync-env
```

**What it does**:
- Updates Docker section in root `.env` from `.docker/.env.docker`
- Removes old configuration between markers
- Inserts updated variables
- Ensures consistency across environment files

### `make link-compose`
**Purpose**: Create symbolic link to docker-compose.yml  
**Usage**: Optional convenience for root-level access

```bash
make link-compose
```

**What it does**:
- Creates `docker-compose.yml` symlink in project root
- Points to `.docker/docker-compose.yml`
- Only creates if link doesn't exist

### `make conf`
**Purpose**: Display Docker Compose configuration  
**Usage**: Debugging and configuration verification

```bash
make conf
```

**What it does**:
- Shows resolved Docker Compose configuration
- Displays environment variable substitutions
- Useful for debugging configuration issues

---

## 🚀 Service Management

### `make build`
**Purpose**: Build and start all services  
**Usage**: Initial setup or major changes

```bash
make build
```

**What it does**:
- Syncs environment configuration
- Builds all Docker images with user ID/GID
- Starts all services in detached mode
- Creates volumes and networks

### `make destroy`
**Purpose**: Complete cleanup of Docker environment  
**Usage**: Fresh start or troubleshooting

```bash
make destroy
```

**What it does**:
- Stops all services
- Removes all containers, images, volumes
- Removes orphaned containers
- Complete environment reset

### `make up`
**Purpose**: Start all services  
**Usage**: Daily development workflow

```bash
make up
```

**What it does**:
- Syncs environment configuration
- Starts all existing services
- Uses existing images (no rebuild)

### `make down`
**Purpose**: Stop all services  
**Usage**: End development session

```bash
make down
```

**What it does**:
- Stops all services
- Removes orphaned containers
- Preserves volumes and networks

### `make restart`
**Purpose**: Restart all services  
**Usage**: Apply configuration changes

```bash
make restart
```

**What it does**:
- Stops all services
- Starts all services
- Equivalent to `make down && make up`

### `make rebuild-container`
**Purpose**: Complete environment rebuild  
**Usage**: First-time setup or major changes

```bash
make rebuild-container
```

**What it does**:
- Runs `make destroy` (removes all containers, images, volumes)
- Runs `make build` (builds images with your user ID/GID)
- Starts all 7 services with static IP network
- Complete fresh environment setup

**When to use**:
- First-time setup
- After Docker configuration changes
- When troubleshooting corruption issues
- After major dependency updates

---

## 💻 Container Access

### `make php-bash`
**Purpose**: Access PHP container shell  
**Usage**: Laravel commands, Composer operations

```bash
make php-bash
```

**What it does**:
- Opens bash shell in PHP container
- Runs as `www-data` user
- Sets up environment for Laravel development

**Common commands inside container**:
```bash
art migrate        # Run Laravel migrations
art tinker         # Laravel REPL
composer install   # Install PHP dependencies
php -v             # Check PHP version
```

### `make web-bash`
**Purpose**: Access web container shell  
**Usage**: Node.js operations, NPM commands

```bash
make web-bash
```

**What it does**:
- Opens bash shell in web/Nginx container
- Runs as `nginx` user
- Sets up Node.js environment

**Common commands inside container**:
```bash
npm install        # Install Node dependencies
npm run build      # Build frontend assets
npm run dev        # Start development server
node -v            # Check Node version
```

### `make database-bash`
**Purpose**: Access database shell  
**Usage**: Direct database operations

```bash
make database-bash
```

**What it does**:
- Opens MySQL shell in database container
- Uses environment credentials
- Connects to configured database

**Common commands inside shell**:
```sql
SHOW DATABASES;      # List databases
SHOW TABLES;         # List tables
SELECT * FROM users; # Query data
```

---

## 📊 Monitoring & Logs

### `make ps`
**Purpose**: Display running containers  
**Usage**: Quick status check

```bash
make ps
```

**What it does**:
- Shows running Docker containers
- Displays image names and port mappings
- Formatted output for readability

### `make logs`
**Purpose**: Display all service logs  
**Usage**: Overview of all services

```bash
make logs
```

**What it does**:
- Shows logs from all services
- Displays recent log entries
- Useful for general troubleshooting

### `make logs-watch`
**Purpose**: Watch logs in real-time  
**Usage**: Monitoring active development

```bash
make logs-watch
```

**What it does**:
- Follows logs in real-time
- Updates as new logs are generated
- Press Ctrl+C to stop watching

### `make log-php`
**Purpose**: Display PHP service logs  
**Usage**: PHP-specific troubleshooting

```bash
make log-php
```

**What it does**:
- Shows only PHP container logs
- Useful for application debugging
- PHP errors, FPM logs, etc.

---

## 🗄️ Database Operations

### `make database-import`
**Purpose**: Import database from SQL file  
**Usage**: Restore database or import data

```bash
make database-import
```

**What it does**:
- Imports `dump.sql` file into database
- Uses environment credentials
- Creates tables and inserts data

**Prerequisites**:
- Place `dump.sql` in project root
- Ensure database service is running

---

## 🧪 Testing & Quality

### `make test`
**Purpose**: Run full test suite  
**Usage**: Comprehensive testing

```bash
make test
```

**What it does**:
- Runs composer script `full:test`
- Executes all configured tests
- Uses PHP container for testing

### `make test-pint`
**Purpose**: Run PHP code style checks  
**Usage**: Code quality verification

```bash
make test-pint
```

**What it does**:
- Runs Laravel Pint for code formatting
- Checks PSR-12 compliance
- Uses PHP container

### `make test-phpstan`
**Purpose**: Run static analysis  
**Usage**: Code quality and error detection

```bash
make test-phpstan
```

**What it does**:
- Runs PHPStan static analysis
- Detects potential issues
- Uses PHP container

### `make test-phpunit-coverage`
**Purpose**: Run tests with coverage report  
**Usage**: Test coverage analysis

```bash
make test-phpunit-coverage
```

**What it does**:
- Runs PHPUnit with coverage
- Generates coverage reports
- Uses PHP container

---

## 🛠️ Development Tools

### `make build-project`
**Purpose**: Build project dependencies  
**Usage**: After initial setup or dependency changes

```bash
make build-project
```

**What it does**:
- Runs `reset:backend` composer script
- Runs `reset:data` composer script
- Installs and builds Node.js dependencies
- Sets up complete project environment

### `make reset-ide-helper`
**Purpose**: Reset IDE helper files  
**Usage**: After dependency updates

```bash
make reset-ide-helper
```

**What it does**:
- Regenerates IDE helper files
- Updates autocompletion
- Uses PHP container

### `make reset-data`
**Purpose**: Reset application data  
**Usage**: Data refresh or testing

```bash
make reset-data
```

**What it does**:
- Runs `reset:data` composer script
- Clears and resets application data
- Uses PHP container

### `make fix-pint-and-blade`
**Purpose**: Auto-fix code formatting  
**Usage**: Code style compliance

```bash
make fix-pint-and-blade
```

**What it does**:
- Runs Pint to fix PHP formatting
- Runs Blade formatter for templates
- Uses both PHP and web containers

---

## 🔄 Command Dependencies

Most commands automatically run `sync-env` to ensure environment consistency:

```bash
# These commands automatically sync environment:
make build
make up
make down
make restart
make conf
make ps
make php-bash
make web-bash
make database-bash
make database-import
make logs
make logs-watch
make log-php
make test
make test-pint
make test-phpstan
make test-phpunit-coverage
make reset-ide-helper
make reset-data
make fix-pint-and-blade
make build-project
```

**Note**: `make init-env` and `make sync-env` do not call themselves (to avoid infinite recursion). `make destroy` and `make link-compose` also do not call `sync-env`.

## 🛡️ Safety Features

### User ID Mapping
Build commands automatically map your user ID/GID:
```bash
# Prevents permission issues
make build  # Uses your local user ID
```

### Environment Validation
Commands check for required files and configuration:
```bash
make init-env  # Creates missing .env
make sync-env  # Validates configuration
```

### Service Dependencies
Commands respect service dependencies:
```bash
make up     # Starts services in correct order
make build  # Builds with dependency awareness
```

## 📝 Custom Commands

You can extend the Makefile with custom commands:

```makefile
# Custom command example
custom-command: sync-env
	$(COMPOSE_CMD) exec php php artisan custom:command
```

## 🔍 Troubleshooting Commands

### Check Environment
```bash
make conf      # Verify configuration
make ps        # Check running services
make logs      # Check for errors
```

### Reset Environment
```bash
make down      # Stop services
make destroy   # Complete cleanup
make build     # Fresh start
```

### Debug Specific Issues
```bash
make log-php   # PHP-specific logs
make php-bash  # Access container directly
make database-bash  # Check database
```

---

*For service-specific information, see [Services Overview](services-overview.md). For network configuration, see [Network Configuration](network-configuration.md).*
