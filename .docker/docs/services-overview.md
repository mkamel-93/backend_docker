# Services Overview

## 🏗️ Service Architecture

| Service | IP Address          | Purpose |
|---------|---------------------|---------|
| PHP | `172.19.10.11`      | Application server |
| Web (Nginx) | `172.19.10.12`      | Web server |
| Database (MySQL) | `172.19.10.13`      | Database server |
| phpMyAdmin | `172.19.10.14`      | Database admin |
| MailHog | `172.19.10.15`      | Email testing |
| Redis | `172.19.10.16`      | Cache/Session store |
| Selenium | `172.19.10.17:4444` | Browser automation |

## 🐘 PHP Service
- **Image**: `php:8.2.30-fpm-alpine`
- **Features**: Xdebug, Composer, Laravel tools, user permission mapping
- **Access**: `make php-bash`

## 🌐 Web Service
- **Image**: `nginx:1.26-alpine` + `node:20.19.0-alpine`
- **Features**: Nginx + Node.js 20, frontend builds
- **Access**: `make web-bash`

## 🗄️ Database Service
- **Image**: Custom MySQL build
- **Features**: Persistent storage, custom network
- **Access**: `make database-bash`, `make database-import`

## 🔧 Supporting Services
- **phpMyAdmin**: Web database admin (Port 80)
- **MailHog**: Email testing (Ports 1025, 8025)
- **Redis**: Cache/sessions (Port 6379)
- **Selenium**: Browser automation (Ports 4444, 5900)

---
*For detailed configuration, see [Network Configuration](network-configuration.md).*