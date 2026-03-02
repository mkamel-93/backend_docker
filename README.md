# Docker Backend Development Environment

A production-ready Docker environment for PHP/Laravel development with static IP networking.

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

- **Docker Desktop** (for Mac/Windows) or **Docker Engine** (for Linux)
- **Docker Compose** (usually included with Docker Desktop)
- **Make utility** (pre-installed on most Unix systems)

### Verify Installation

```bash
# Check Docker version
docker --version
docker-compose --version

# Check Make
make --version
```

## 🚀 Quick Start

```bash
make rebuild-container
```

This command:
- Builds all 7 services (PHP, Nginx, MySQL, phpMyAdmin, Redis, MailHog, Selenium)
- Sets up a static IP network (172.19.10.0/24)
- Maps your user permissions to containers
- Installs dependencies if present

## 🌐 Access Services

Check assigned ports:
```bash
make ps
```

## 🛠️ Common Commands

```bash
make php-bash     # Access PHP container
make web-bash     # Access Nginx/Node.js container  
make up           # Start all services
make down         # Stop all services
make logs         # View all logs
```

## 📚 Documentation

- [**Getting Started**](.docker/docs/getting-started.md) - Complete setup guide
- [**Services Overview**](.docker/docs/services-overview.md) - All 7 services details
- [**Network Configuration**](.docker/docs/network-configuration.md) - Static IP setup
- [**Makefile Commands**](.docker/docs/makefile-commands.md) - All available commands
- [**Troubleshooting**](.docker/docs/troubleshooting.md) - Common issues

---

*Detailed configuration and advanced usage are available in the documentation.*