# Backend Docker - PHP Development Environment

A production-ready Docker Compose template for PHP development featuring PHP 8.2-FPM, Nginx 1.26, MariaDB 10.6, Redis 5.0, phpMyAdmin, MailHog, and Selenium Chrome - fully configured with security headers, performance optimizations, and development tools.

**Key Features:**
- Zero-configuration quick start (clone, build, code)
- 7 integrated services with isolated network architecture
- Pre-configured development tools (Composer, PHPUnit, PHPStan, PHP CS Fixer, Xdebug)
- Security hardening (headers, network isolation, file access controls)
- Performance optimizations (long timeouts, large uploads, Redis caching)
- Database management UI (phpMyAdmin)
- Email testing (MailHog)

**Repository:** https://github.com/coder0010/backend_docker

---

## Table of Contents

- [Quick Start](#quick-start)
- [Tech Stack](#tech-stack)
- [Features](#features)
- [Services](#services)
- [Network Architecture](#network-architecture)
- [Security Features](#security-features)
- [Performance Optimizations](#performance-optimizations)
- [Makefile Commands](#makefile-commands)
- [Configuration](#configuration)
- [Development Tools](#development-tools)
- [Troubleshooting](#troubleshooting)
- [Project Structure](#project-structure)
- [Additional Resources](#additional-resources)

---

## Quick Start

### Prerequisites

- **Docker Desktop** 4.0+ (includes Docker Engine 20.10+ and Docker Compose v2)
- **Git** 2.25+
- **4GB RAM** minimum (8GB recommended)
- **10GB** free disk space

### Setup Steps

**1. Clone Repository**

```bash
git clone git@github.com:coder0010/backend_docker
# or
git clone https://github.com/coder0010/backend_docker

cd backend_docker
```

**2. Configure Environment**

```bash
cp .env.docker .env
```

**3. Build and Start**

```bash
make build
# or if make is not available:
docker-compose up -d --build
```

**4. Access Services**

- **Web Application:** http://localhost:8011
- **phpMyAdmin:** http://localhost:8012
- **MailHog UI:** http://localhost:8013
- **Selenium Hub:** http://localhost:4443
- **Vite Dev Server:** http://localhost:5172
- **MariaDB:** localhost:3306 (user: root, password: P@ssw0rd)
- **Redis:** localhost:6379 (password: P@ssw0rd)

---

## Tech Stack

- **PHP 8.2-FPM** - Application runtime with FastCGI Process Manager
- **Nginx 1.26** - High-performance web server and reverse proxy with Node.js 20.19.0
- **MariaDB 10.6** - Relational database with persistent storage
- **Redis 5.0** - In-memory cache and session store
- **phpMyAdmin** - Web-based database management interface
- **MailHog** - Email testing tool with SMTP server and web UI
- **Selenium Chrome** - Browser automation for testing
- **Docker & Docker Compose** - Container orchestration

---

## Features

### Security
- Security headers (X-Frame-Options, X-XSS-Protection, X-Content-Type-Options)
- Server version information hidden (`server_tokens off`)
- Network isolation (custom Docker bridge network)
- File access controls (hidden files blocked)
- Database and Redis password protection
- Non-root container users where applicable

### Performance
- Extended timeouts (600s for long-running operations)
- Large file upload support (1024MB)
- High memory limits (1024MB for PHP)
- Unix socket communication (PHP-FPM ↔ Nginx)
- Redis available for caching and sessions
- Static file serving optimized

### Developer Experience
- Pre-installed tools: Composer, PHPUnit, PHPStan, PHP CS Fixer
- Xdebug support for debugging and profiling
- MailHog for email testing (no real emails sent)
- Make commands for common operations
- phpMyAdmin for database management
- Comprehensive logging to stdout/stderr

---

## Services

### Services Overview

| Service | Version | Port(s) | IP Address | Purpose |
|---------|---------|---------|------------|---------|
| **PHP-FPM** | 8.2.30 | Internal (socket) | 172.16.11.11 | PHP application runtime |
| **Nginx** | 1.26 | 8011, 5172 | 172.16.11.12 | Web server & reverse proxy |
| **MariaDB** | 10.6 | 3306 | 172.16.11.13 | Relational database |
| **phpMyAdmin** | Latest | 8012 | 172.16.11.14 | Database management UI |
| **MailHog** | Latest | 8013, 1025 | 172.16.11.15 | Email testing (UI & SMTP) |
| **Redis** | 5.0.3 | 6379 | 172.16.11.16 | Cache & session store |
| **Selenium** | Chrome 144.0 | 4443, 5901 | 172.16.11.17 | Browser automation |

### PHP-FPM Container

**What it includes:**
- PHP 8.2.30 with FastCGI Process Manager
- **Extensions:** PDO (MySQL, SQLite), MySQLi, mbstring, intl, zip, bcmath, cURL, ctype, LDAP, GD (FreeType, JPEG, PNG), Imagick, Xdebug
- **Tools:** Composer 2.8.12, Git, cURL, unzip
- **Configuration:** 1024MB memory limit, 3000s execution time, 1024MB uploads

**Access:**
```bash
make php-bash
```

### Nginx Container

**What it includes:**
- Nginx 1.26 on Alpine Linux
- Node.js 20.19.0 (for frontend asset building)
- Security headers pre-configured
- 600-second timeouts for long operations

**Access:**
```bash
make web-bash
```

### MariaDB Container

**What it includes:**
- MariaDB 10.6 with UTF-8 support
- Persistent data storage (named volume)
- Slow query logging enabled
- General query logging for development

**Access:**
```bash
make database-bash
# or from host:
mysql -h localhost -P 3306 -u root -p
```

### Redis Container

**What it includes:**
- Redis 5.0.3 with Alpine Linux
- Password protection enabled
- Persistent data storage (named volume)
- Ready for sessions and caching

**Access:**
```bash
make php-bash
redis-cli -h redis -p 6379 -a P@ssw0rd
```

### phpMyAdmin Container

**What it provides:**
- Web-based MySQL management
- No additional configuration needed
- Connected to MySQL service automatically

**Access:** http://localhost:8012
- Server: `database`
- Username: `root`
- Password: `P@ssw0rd` (from .env)

### MailHog Container

**What it provides:**
- SMTP server on port 1025
- Web UI on port 8013
- Catches all outbound emails (development safe)
- Inspect emails, headers, and raw data

**Access:** http://localhost:8013

**Configure in your application:**
```env
MAIL_HOST=mailhog
MAIL_PORT=1025
```

### Selenium Chrome Container

**What it provides:**
- Chrome browser automation for testing
- Selenium Hub on port 4443
- VNC preview on port 5901
- Ready for Dusk or other browser testing frameworks

**Access:** 
- **Selenium Hub:** http://localhost:4443
- **VNC Preview:** vnc://localhost:5901

**Configure in your application:**
```env
DUSK_DRIVER_URL="http://selenium:4444/wd/hub"
```

---

## Network Architecture

All services run on a custom Docker bridge network with static IP addresses for consistent communication.

```
┌──────────────────────────────────────────────────────────────┐
│                    HOST MACHINE                              │
│                                                              │
│  Port 8011 → Nginx (Web)                                     │
│  Port 8012 → phpMyAdmin (DB UI)                              │
│  Port 8013 → MailHog (Email UI)                              │
│  Port 4443 → Selenium (Hub)                                  │
│  Port 5901 → Selenium (VNC Preview)                          │
│  Port 5172 → Vite Dev Server                                 │
│  Port 3306 → MariaDB (Direct DB access)                      │
│  Port 6379 → Redis (Direct cache access)                     │
│  Port 1025 → MailHog SMTP                                    │
│                                                              │
└────────────────────┬─────────────────────────────────────────┘
                     │
        ┌────────────┴──────────────────────────────┐
        │  Docker Bridge Network: backend_docker    │
        │  Subnet: 172.16.11.0/24                   │
        └────────────┬──────────────────────────────┘
                     │
    ┌────────────────┴─────────────────────────────────────────┐
    │                                                          │
    │  ┌─────────────────────────────────┐                     │
    │  │ Nginx (172.16.11.12:80)         │                     │
    │  │ - Security headers              │                     │
    │  │ - 600s timeouts                 │                     │
    │  └──────────┬──────────────────────┘                     │
    │             │ (Unix Socket)                              │
    │             v                                            │
    │  ┌─────────────────────────────────┐                     │
    │  │ PHP-FPM (172.16.11.11)          │                     │
    │  │ - 1024MB memory                 │                     │
    │  │ - 3000s execution               │                     │
    │  └──────────┬──────────────────────┘                     │
    │             │                                            │
    │  ┌──────────┴──────────┬─────────────┬────────────┐      │
    │  │                     │             │            │      │
    │  v                     v             v            v      │
    │  ┌─────────┐  ┌─────────────┐  ┌────────┐  ┌──────────┐  │
    │  │ MariaDB │  │ phpMyAdmin  │  │ Redis  │  │ MailHog  │  │
    │  │ (.13)   │  │ (.14)       │  │ (.16)  │  │ (.15)    │  │
    │  │ 3306    │  │ Port 80     │  │ 6379   │  │ 1025/8025│  │
    │  └─────────┘  └─────────────┘  └────────┘  └──────────┘  │
    │                                                          │
    │                                          ┌─────────────┐ │
    │                                          │ Selenium    │ │
    │                                          │ (.17)       │ │
    │                                          │ 4444/5900   │ │
    │                                          └─────────────┘ │
    │                                                          │
    └──────────────────────────────────────────────────────────┘
```

### Network Details

- **Network Name:** `backend_docker`
- **Subnet:** `172.16.11.0/24`
- **Gateway:** `172.16.11.1`
- **Driver:** Bridge (isolated from other Docker networks)

### Service Discovery

Services can communicate using **service names** as hostnames:

```php
// From PHP application
$db_host = 'database';      // Resolves to 172.16.11.13
$redis_host = 'redis';      // Resolves to 172.16.11.16
$mail_host = 'mailhog';     // Resolves to 172.16.11.15
$selenium_host = 'selenium'; // Resolves to 172.16.11.17
```

### Communication Patterns

- **Nginx ↔ PHP-FPM:** Unix socket (`/var/run/php-fpm/php-fpm.sock`) - High performance, no network overhead
- **PHP ↔ MariaDB:** TCP on custom network (internal only)
- **PHP ↔ Redis:** TCP on custom network (internal only)
- **PHP ↔ MailHog:** SMTP TCP on custom network
- **PHP ↔ Selenium:** WebDriver TCP on custom network
- **Host ↔ Services:** Port mappings on Docker bridge

---

## Security Features

### Network-Level Security

- **Custom Bridge Network:** Services isolated from other Docker networks
- **Static IP Assignment:** Prevents IP conflicts and ensures consistency
- **No Unnecessary Port Exposure:** MySQL and Redis only exposed to host when needed
- **Service Discovery:** Internal DNS prevents hardcoded IPs

### HTTP Security Headers

Configured in Nginx (`domain.conf`):

| Header | Value | Purpose |
|--------|-------|---------|
| `X-Frame-Options` | SAMEORIGIN | Prevents clickjacking attacks |
| `X-XSS-Protection` | 1; mode=block | Enables browser XSS protection |
| `X-Content-Type-Options` | nosniff | Prevents MIME type sniffing |
| `server_tokens` | off | Hides Nginx version information |

### File Access Controls

- **Hidden Files Blocked:** `location ~ /\.(?!well-known).* { deny all; }`
- **Favicon/Robots Excluded:** Reduces access log noise
- **PHP Execution Limited:** Only designated directories can execute PHP

### Authentication & Passwords

- **MySQL:** Password-protected (configurable in `.env`)
- **Redis:** Password authentication enabled (`REDIS_PASSWORD`)
- **phpMyAdmin:** Requires MySQL credentials

### Production Recommendations

For production deployments:
1. Use strong passwords (not default `P@ssw0rd`)
2. Enable HTTPS with SSL/TLS certificates
3. Remove or restrict phpMyAdmin access
4. Use environment variable secrets management (Docker secrets, Vault)
5. Enable firewall rules
6. Regular security updates for base images

---

## Performance Optimizations

### PHP Configuration

| Setting | Value | Purpose |
|---------|-------|---------|
| `max_execution_time` | 3000s | Allows long-running scripts (data imports, batch jobs) |
| `memory_limit` | 1024M | Sufficient for complex operations |
| `upload_max_filesize` | 1024M | Large file upload support |
| `post_max_size` | 1024M | Large POST request handling |
| `max_input_vars` | 1000 | Complex form handling |

### Nginx Configuration

| Setting | Value | Purpose |
|---------|-------|---------|
| `proxy_connect_timeout` | 600s | Wait for PHP-FPM response |
| `proxy_send_timeout` | 600s | Allow long upload times |
| `proxy_read_timeout` | 600s | Long processing time support |
| `send_timeout` | 600s | Extended client timeout |
| `access_log` | off | Reduces disk I/O (errors still logged) |

### PHP-FPM Optimization

- **Unix Socket:** Faster than TCP (no network overhead)
- **Access Logging:** Enabled to stdout for monitoring
- **User/Group:** `www-data` for proper permissions

### Caching Strategy

- **Redis Available:** Pre-configured for sessions and application caching
- **Static Files:** Served directly by Nginx (bypasses PHP)
- **OPcache:** Can be configured in `php.ini` for bytecode caching

### Resource Management

Containers are configured for development workloads. For production:
- Add memory limits in `docker-compose.yml`
- Configure CPU limits
- Enable swap limits if needed
- Monitor with `docker stats`

---

## Makefile Commands

The Makefile provides convenient shortcuts for common Docker operations.

### Container Lifecycle

#### `make build`
Build images and start all containers.

```bash
make build
```

**Use when:**
- First time setup
- After changing Dockerfiles
- Need fresh build

#### `make rebuild-container`
Complete rebuild (destroys everything).

```bash
make rebuild-container
```

**WARNING:** Destroys all containers, images, and volumes (data loss!)

**Use when:**
- Complete reset needed
- Major configuration changes
- Troubleshooting persistent issues

#### `make up`
Start existing containers (no rebuild).

```bash
make up
```

**Use when:**
- Containers already built
- Quick restart after `make down`

#### `make down`
Stop and remove containers (keeps volumes/images).

```bash
make down
```

**Use when:**
- Done working for the day
- Need to free up resources
- Want to stop services temporarily

#### `make restart`
Stop and restart all containers.

```bash
make restart
```

**Use when:**
- Applied configuration changes
- Services behaving oddly
- Need fresh state without full rebuild

#### `make destroy`
Remove containers, images, and volumes.

```bash
make destroy
```

**WARNING:** Deletes all data including database!

**Use when:**
- Completely removing the project
- Absolute certainty to reset everything

### Service Access

#### `make php-bash`
Access PHP container shell.

```bash
make php-bash
```

Once inside, you can run:
```bash
php -v                    # Check PHP version
composer install          # Install dependencies
vendor/bin/phpunit        # Run tests
vendor/bin/phpstan        # Static analysis
```

#### `make web-bash`
Access Nginx container shell.

```bash
make web-bash
```

Once inside:
```bash
nginx -t                  # Test configuration
cat /etc/nginx/conf.d/domain.conf  # View config
```

#### `make database-bash`
Access MariaDB interactive shell.

```bash
make database-bash
```

Automatically connects with credentials from `.env`. Run SQL queries directly:
```sql
SHOW DATABASES;
USE backend_docker;
SHOW TABLES;
```

### Database Management

#### `make database-import`
Import SQL dump file into database.

```bash
make database-import
```

**Prerequisites:**
- File named `dump.sql` must exist in project root
- Database specified in `.env` will be used

### Monitoring & Logs

#### `make logs`
Display logs from all services.

```bash
make logs
```

**Shows:** Historical logs from all containers

#### `make logs-watch`
Stream logs in real-time.

```bash
make logs-watch
```

**Shows:** Live log output from all services
**Exit:** Press `Ctrl+C`

#### `make log-php`
Display only PHP container logs.

```bash
make log-php
```

**Use when:** Debugging PHP-specific issues

### Utilities

#### `make ps`
Show running containers and exposed ports.

```bash
make ps
```

**Output:** Table showing container images and port mappings

#### `make conf`
Display resolved docker-compose configuration.

```bash
make conf
```

**Shows:** Final configuration after environment variable substitution

**Use when:** Debugging configuration issues

### Quick Reference

| Task | Command | Data Loss Risk |
|------|---------|----------------|
| Start project | `make build` | None |
| Stop project | `make down` | None |
| Restart services | `make restart` | None |
| PHP shell | `make php-bash` | None |
| View logs | `make logs-watch` | None |
| Complete reset | `make rebuild-container` | **YES - All data** |
| Remove everything | `make destroy` | **YES - All data** |

---

## Configuration

### Environment Variables

The `.env` file controls all service configuration. Copy from `.env.docker` template:

```bash
cp .env.docker .env
```

### Key Configuration Sections

#### Application Settings

```env
APP_NAME=backend_docker          # Used in container naming and database name
```

#### Network Configuration

```env
DOCKER_NETWORK_SUBNET=172.16.11.0/24              # Custom bridge subnet
DOCKER_PHP_NETWORK_IP_ADDRESS=172.16.11.11        # PHP-FPM static IP
DOCKER_WEB_NETWORK_IP_ADDRESS=172.16.11.12        # Nginx static IP
DOCKER_DATABASE_NETWORK_IP_ADDRESS=172.16.11.13    # MariaDB static IP
# ... (other service IPs)
```

#### Port Mappings

```env
DOCKER_WEB_NETWORK_PORT=8011              # Web application port
DOCKER_WEB_VITE_NETWORK_PORT=5172          # Vite dev server port
DOCKER_PHPMYADMIN_NETWORK_PORT=8012        # phpMyAdmin UI port
DOCKER_MAILHOG_NETWORK_PORT=8013           # MailHog UI port
DOCKER_SELENIUM_HUB_NETWORK_PORT=4443      # Selenium Hub port
DOCKER_SELENIUM_PREVIEW_NETWORK_PORT=5901  # Selenium VNC port
```

#### Database Configuration

```env
DB_CONNECTION=mysql
DB_HOST=database                # Service name (internal DNS)
DB_PORT=3306
DB_DATABASE=backend_docker     # Database name (matches APP_NAME)
DB_USERNAME=root
DB_PASSWORD=P@ssw0rd          # CHANGE THIS for production!
```

#### Redis Configuration

```env
REDIS_HOST=redis                 # Service name (internal DNS)
REDIS_PASSWORD=P@ssw0rd          # CHANGE THIS for production!
REDIS_PORT=6379
```

#### Email Configuration (MailHog)

```env
MAIL_MAILER=smtp
MAIL_HOST=mailhog                # Service name (internal DNS)
MAIL_PORT=1025                   # MailHog SMTP port
```

### Docker Configuration Files

| File | Purpose |
|------|---------|
| `docker-compose.yml` | Service orchestration and container definitions |
| `.docker/services/php/Dockerfile` | PHP-FPM image build instructions |
| `.docker/services/php/php.ini` | PHP configuration (memory, timeouts, uploads) |
| `.docker/services/php/php-fpm.d/zzz-www.conf` | PHP-FPM pool configuration |
| `.docker/services/nginx/Dockerfile` | Nginx image build instructions |
| `.docker/services/nginx/conf.d/domain.conf` | Nginx virtual host configuration |
| `.docker/services/database/Dockerfile` | MariaDB image (uses defaults) |
| `.docker/services/redis/Dockerfile` | Redis image with password config |
| `.docker/services/selenium/Dockerfile` | Selenium Chrome image |
| `.docker/services/phpmyadmin/Dockerfile` | phpMyAdmin image |
| `.docker/services/mailhog/Dockerfile` | MailHog image |

### Common Customizations

#### Change Web Port (from 8011 to 9000)

Edit `.env`:
```env
DOCKER_WEB_NETWORK_PORT=9000
```

Then restart:
```bash
make restart
```

Access at: http://localhost:9000

#### Change Database Password

Edit `.env`:
```env
DB_PASSWORD=MySecurePassword123
```

**Important:** Must also update in `docker-compose.yml` under MariaDB environment:
```yaml
MYSQL_PASSWORD: MySecurePassword123
```

Then rebuild:
```bash
make rebuild-container
```

#### Change Application Name

Edit `.env`:
```env
APP_NAME=my_project
```

This affects:
- Container names
- Default database name
- Volume names

Then rebuild:
```bash
make rebuild-container
```

---

## Development Tools

### Pre-installed Tools in PHP Container

#### Composer (Dependency Manager)

```bash
make php-bash
composer --version           # Check version
composer install             # Install from composer.lock
composer update              # Update dependencies
composer require vendor/package
```

#### PHPUnit (Testing Framework)

```bash
make php-bash
vendor/bin/phpunit tests/                    # Run all tests
vendor/bin/phpunit tests/Unit/MyTest.php     # Run specific test
vendor/bin/phpunit --coverage-html coverage  # Generate coverage
```

#### PHPStan (Static Analysis)

```bash
make php-bash
vendor/bin/phpstan analyse app/
vendor/bin/phpstan --level=5 app/    # Levels 0-9
```

#### PHP CS Fixer (Code Formatting)

```bash
make php-bash
vendor/bin/php-cs-fixer fix app/           # Fix all files
vendor/bin/php-cs-fixer fix --dry-run      # Preview changes
```

#### Xdebug (Debugging)

Xdebug is pre-installed. Configure your IDE:

**VS Code:** Create `.vscode/launch.json`:
```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Listen for Xdebug",
            "type": "php",
            "request": "launch",
            "port": 9003,
            "pathMappings": {
                "/var/www": "${workspaceFolder}"
            }
        }
    ]
}
```

**PhpStorm:**
1. Settings → PHP → Servers
2. Add Server: Name = `backend_docker_XdebugServer`, Host = `localhost`, Port = `8001`
3. Set path mapping: `/var/www` → your project folder

#### Git (Version Control)

```bash
make php-bash
git status
git log --oneline
git diff
```

### Development Workflow

**Daily Start:**
```bash
make up                      # Start containers
```

**Run Tests:**
```bash
make php-bash
vendor/bin/phpunit
```

**Code Quality Checks:**
```bash
make php-bash
vendor/bin/phpstan analyse app/
vendor/bin/php-cs-fixer fix
```

**View Logs:**
```bash
make logs-watch              # Monitor in real-time
```

**Daily End:**
```bash
make down                    # Stop containers
```

---

## Troubleshooting

### Port Already in Use

**Problem:** `Error: bind: address already in use`

**Solution 1 - Find and kill the process:**
```bash
# Windows
netstat -ano | findstr :8011
taskkill /PID <PID> /F

# Linux/Mac
lsof -i :8011
kill -9 <PID>
```

**Solution 2 - Change port in .env:**
```env
DOCKER_WEB_NETWORK_PORT=8080
```
Then: `make restart`

### Container Won't Start

**Problem:** Container exits immediately or won't start

**Diagnosis:**
```bash
docker ps -a                 # Check stopped containers
make logs                    # View error logs
docker logs <container_name> # Detailed logs
```

**Common causes:**
- **Port conflict:** See "Port Already in Use" above
- **Invalid configuration:** Run `make conf` to verify
- **Disk space full:** Run `docker system prune -a`
- **Mount permission issue:** Check file ownership

**Solution:**
```bash
make rebuild-container       # Full rebuild
```

### Database Connection Failed

**Problem:** `SQLSTATE[HY000] [2002] Connection refused` or similar

**Diagnosis Steps:**

**1. Verify MariaDB is running:**
```bash
make ps
# MariaDB should be listed
```

**2. Test connection from PHP container:**
```bash
make php-bash
mysql -h database -u root -p
# Enter password from .env
```

**3. Check network connectivity:**
```bash
make php-bash
ping database
# Should resolve to 172.16.11.13
```

**4. Verify credentials in .env:**
```bash
cat .env | grep DB_
cat .env | grep MYSQL_
# Ensure they match
```

**Solution:**
```bash
make restart                 # Restart all services
# Wait 10 seconds for MySQL to be ready
```

### Nginx 502 Bad Gateway

**Problem:** `502 Bad Gateway` when accessing http://localhost:8011

**Causes:**
- PHP-FPM not running
- Socket not accessible
- PHP-FPM crashed

**Diagnosis:**

**1. Check PHP-FPM status:**
```bash
make ps                      # Verify PHP container is running
make log-php                 # Check for PHP errors
```

**2. Verify socket exists:**
```bash
make web-bash
ls -la /var/run/php-fpm/
# Should see php-fpm.sock
```

**3. Test Nginx configuration:**
```bash
make web-bash
nginx -t
```

**Solution:**
```bash
docker-compose restart php   # Restart PHP-FPM
# or
make restart                 # Restart all
```

### MailHog Not Receiving Emails

**Problem:** Emails don't appear in MailHog UI

**Diagnosis:**

**1. Verify MailHog is running:**
```bash
make ps
# MailHog should be listed
```

**2. Access web UI:**
http://localhost:8003

**3. Check configuration in .env:**
```env
MAIL_HOST=mailhog
MAIL_PORT=1025
```

**4. Test SMTP connection:**
```bash
make php-bash
telnet mailhog 1025
# Should connect successfully
```

**5. Check MailHog logs:**
```bash
docker-compose logs mailhog
```

**Solution:** Verify your application is configured to use MailHog SMTP settings.

### Xdebug Not Working

**Problem:** Breakpoints not triggering in IDE

**Diagnosis:**

**1. Verify Xdebug is installed:**
```bash
make php-bash
php -m | grep xdebug
# Should show "xdebug"
```

**2. Check Xdebug configuration:**
```bash
make php-bash
php -i | grep xdebug
```

**3. Verify IDE is listening:**
- VS Code: Check status bar for "Listening for Xdebug"
- PhpStorm: Debug icon should be green

**4. Check firewall:**
- Ensure IDE can listen on port 9003
- Allow Docker network through firewall

**Solution:**
```bash
make restart                 # Restart containers
# Configure IDE with server name: backend_docker_XdebugServer
# Try debugging again
```

### Slow Performance

**Problem:** Application or containers are very slow

**Causes & Solutions:**

**1. Xdebug overhead (3x slower):**
```bash
# Disable Xdebug in .env:
DEBUG=0
make restart
```

**2. Check resource allocation:**
```bash
docker stats                 # Monitor CPU/Memory usage
```

If resources are maxed:
- Increase Docker Desktop resource limits
- Close other applications

**3. Windows file system (WSL2 recommended):**
- Use WSL2 backend in Docker Desktop
- Store project files in WSL2 filesystem

**4. Database optimization:**
```bash
make mysql-bash
ANALYZE TABLE table_name;
OPTIMIZE TABLE table_name;
```

### Permission Errors

**Problem:** `Permission denied` when accessing files

**Solution:**

**From host:**
```bash
chmod -R 755 storage/
chmod -R 775 storage/logs/
```

**From container:**
```bash
make php-bash
chown -R www-data:www-data /var/www/storage/
chmod -R 755 /var/www/storage/
```

### Cannot Import Database

**Problem:** `make mysql-import` fails

**Prerequisites:**
- File must be named `dump.sql`
- File must be in project root directory
- Database must exist (specified in `.env`)

**Manual import:**
```bash
make mysql-bash
source /path/to/dump.sql;
```

**Or from host:**
```bash
cat dump.sql | docker exec -i <mysql_container> mysql -uroot -p<password> <database>
```

### Disk Space Issues

**Problem:** `no space left on device`

**Check usage:**
```bash
docker system df             # Check Docker disk usage
```

**Clean up:**
```bash
docker system prune -a       # Remove unused images, containers, volumes
# WARNING: Removes all unused Docker data
```

**Increase Docker Desktop disk:**
- Docker Desktop → Settings → Resources
- Increase "Disk image size"

---

## Project Structure

```
backend_docker/
├── .docker/                          # Docker configuration
│   └── services/
│       ├── php/
│       │   ├── Dockerfile           # PHP 8.2-FPM image definition
│       │   ├── php.ini              # PHP configuration
│       │   └── php-fpm.d/
│       │       └── zzz-www.conf     # PHP-FPM pool config
│       ├── nginx/
│       │   ├── Dockerfile           # Nginx 1.20 image definition
│       │   └── conf.d/
│       │       └── domain.conf      # Virtual host configuration
│       ├── mysql/
│       │   └── Dockerfile           # MySQL 8.0 image
│       ├── redis/
│       │   └── Dockerfile           # Redis image
│       ├── phpmyadmin/
│       │   └── Dockerfile           # phpMyAdmin image
│       └── mailhog/
│           └── Dockerfile           # MailHog image
│
├── app/                              # Application code (empty template)
│   └── Http/
│       └── Controllers/              # Controllers go here
│
├── bootstrap/                        # Application bootstrap files (empty)
├── public/                           # Web-accessible directory (empty)
├── routes/                           # Route definitions (empty)
│
├── storage/                          # Application storage
│   └── logs/                        # Application and Nginx logs
│
├── docker-compose.yml                # Service orchestration configuration
├── Makefile                          # Convenient make commands
├── .env                              # Environment variables (gitignored)
├── .env.docker                       # Environment template (committed)
├── .dockerignore                     # Docker build context exclusions
├── .gitignore                        # Git ignore rules
├── index.php                         # Entry point (phpinfo for testing)
└── README.md                         # This file
```

### Directory Explanations

- **.docker/services/** - Docker configuration for each service (Dockerfiles, config files)
- **app/** - Your PHP application code goes here
- **public/** - Web root directory (static files, entry point)
- **routes/** - Application routing definitions
- **storage/logs/** - Log files from Nginx and application
- **docker-compose.yml** - Defines all services, networks, volumes
- **Makefile** - Shortcuts for docker-compose commands
- **.env** - Local environment configuration (not in version control)

---

## Additional Resources

### Official Documentation

- **Docker:** https://docs.docker.com
- **Docker Compose:** https://docs.docker.com/compose
- **PHP 8.2:** https://www.php.net/docs.php
- **Nginx:** https://nginx.org/en/docs/
- **MySQL 8.0:** https://dev.mysql.com/doc/
- **Redis:** https://redis.io/documentation
- **Composer:** https://getcomposer.org/doc/

### Next Steps

This is a template/starting point. To build an application:

**Option 1: Add Laravel Framework**
```bash
make php-bash
composer create-project laravel/laravel .
# Configure database in .env
# Access: http://localhost:8011
```

**Option 2: Add Symfony Framework**
```bash
make php-bash
composer create-project symfony/skeleton .
# Configure database
# Access: http://localhost:8011
```

**Option 3: Custom PHP Application**
- Add your code to `app/` directory
- Define routes in `routes/` directory
- Use `public/` for web-accessible files
- Configure database connection using .env variables

### Development Best Practices

1. **Security:**
   - Never commit `.env` file
   - Use strong passwords (not defaults)
   - Rotate credentials regularly
   - Use `.env.docker` as template only

2. **Database:**
   - Regular backups: `mysqldump`
   - Use migrations for schema changes
   - Test backups periodically

3. **Code Quality:**
   - Run PHPStan before commits
   - Use PHP CS Fixer for consistent style
   - Write PHPUnit tests
   - Consider pre-commit hooks

4. **Performance:**
   - Monitor logs: `make logs-watch`
   - Use Redis for sessions/cache
   - Profile with Xdebug when needed
   - Disable Xdebug when not debugging

5. **Logging:**
   - Configure application logging
   - Monitor: `docker-compose logs <service>`
   - Archive logs regularly

### Common Customizations

**Add Cron Jobs:**
- Create supervisor config in `.docker/services/php/`
- Configure cron tasks
- Update Dockerfile to install supervisor

**Add PHP Extensions:**
- Edit `.docker/services/php/Dockerfile`
- Add: `RUN docker-php-ext-install <extension>`
- Rebuild: `make rebuild-container`

**Change Timezone:**
- Update `.env` with `TZ=America/New_York`
- Or modify Dockerfile ENV directives

**Add Custom Nginx Locations:**
- Edit `.docker/services/nginx/conf.d/domain.conf`
- Add location blocks as needed
- Restart: `make restart`

### Support

For issues and questions:
- **GitHub Issues:** https://github.com/coder0010/backend_docker/issues
- **Docker Community:** https://www.docker.com/community
- **Stack Overflow:** Tag [docker], [php], [nginx], [mysql]

---

**Happy Coding!**
