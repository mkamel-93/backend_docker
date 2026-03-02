# Troubleshooting

This document provides solutions to common issues and problems you might encounter with the Docker development environment.

## 🔧 Quick Diagnosis

### First Steps for Any Issue
```bash
# 1. Check service status
make ps

# 2. Check recent logs
make logs

# 3. Verify configuration
make conf

# 4. Check environment sync
make sync-env
```

### Health Check Commands
```bash
# Test individual services
docker-compose exec php php -v
docker-compose exec web nginx -t
docker-compose exec redis redis-cli ping
```

---

## 🚨 Common Issues

### Services Won't Start

#### Issue: Port Already in Use
**Symptoms**:
```
Error: Port 80 is already allocated
```

**Solutions**:
```bash
# 1. Find what's using the port
sudo netstat -tulpn | grep :80
sudo lsof -i :80

# 2. Stop conflicting service
sudo systemctl stop nginx
sudo systemctl stop apache2

# 3. Or change Docker port mapping
# Edit docker-compose.yml and change host port
```

#### Issue: Docker Daemon Not Running
**Symptoms**:
```
Cannot connect to the Docker daemon
```

**Solutions**:
```bash
# Linux
sudo systemctl start docker
sudo systemctl enable docker

# Docker Desktop (Mac/Windows)
# Start Docker Desktop application

# Check Docker status
docker info
docker version
```

#### Issue: Permission Denied
**Symptoms**:
```
permission denied while trying to connect to the Docker daemon socket
```

**Solutions**:
```bash
# Add user to docker group (Linux)
sudo usermod -aG docker $USER
newgrp docker

# Or use sudo for all commands
sudo docker ps
```

### Build Failures

#### Issue: Out of Space
**Symptoms**:
```
no space left on device
```

**Solutions**:
```bash
# Clean Docker system
docker system prune -a
docker volume prune
docker image prune -a

# Check disk space
df -h
docker system df
```

#### Issue: Network Timeout
**Symptoms**:
```
failed to register layer: timeout
```

**Solutions**:
```bash
# Check internet connection
ping google.com

# Use different DNS
# Edit /etc/docker/daemon.json
{
  "dns": ["8.8.8.8", "8.8.4.4"]
}

# Restart Docker
sudo systemctl restart docker
```

#### Issue: User ID Mapping Problems
**Symptoms**:
```
permission denied in container
```

**Solutions**:
```bash
# Check your user ID
id

# Rebuild with correct user ID
make rebuild-container

# Or manually specify
docker-compose build --build-arg USER_ID=$(id -u) --build-arg GROUP_ID=$(id -g)
```

### Container Access Issues

#### Issue: Container Not Found
**Symptoms**:
```
No such container: backend_docker_php
```

**Solutions**:
```bash
# Check running containers
docker ps -a

# Start services
make up

# Rebuild if necessary
make build
```

#### Issue: Command Not Found in Container
**Symptoms**:
```
bash: art: command not found
```

**Solutions**:
```bash
# Check if Laravel is installed
make php-bash
composer show laravel/framework

# Install Laravel if missing
composer require laravel/framework

# Use full command
php artisan migrate
```

### Database Issues

#### Issue: Database Connection Failed
**Symptoms**:
```
SQLSTATE[HY000] [2002] Connection refused
```

**Solutions**:
```bash
# 1. Check database container
docker-compose exec database mysql -u root -p

# 2. Check network connectivity
docker-compose exec php ping database
docker-compose exec php nc -zv database 3306

# 3. Verify environment variables
make conf | grep DB_

# 4. Restart database service
docker-compose restart database
```

#### Issue: Database Import Failed
**Symptoms**:
```
ERROR 1146 (42S02): Table doesn't exist
```

**Solutions**:
```bash
# 1. Check dump file exists
ls -la dump.sql

# 2. Verify database exists
make database-bash
SHOW DATABASES;

# 3. Create database if needed
CREATE DATABASE backend_docker;

# 4. Try import again
make database-import
```

### Performance Issues

#### Issue: Slow Response Times
**Symptoms**:
- Web pages load slowly
- High latency in containers

**Solutions**:
```bash
# 1. Check resource usage
docker stats

# 2. Increase Docker resources (Docker Desktop)
# Settings > Resources > Memory > Increase

# 3. Check disk I/O
iotop
docker system df

# 4. Optimize volumes
# Use bind mounts instead of volumes for development
```

#### Issue: Memory Leaks
**Symptoms**:
- Containers consuming increasing memory
- System becomes unresponsive

**Solutions**:
```bash
# 1. Monitor memory usage
docker stats --no-stream

# 2. Restart services
make restart

# 3. Clear caches
make php-bash
php artisan cache:clear
php artisan config:clear

# 4. Check for runaway processes
docker-compose exec php ps aux
```

---

## 🔍 Debugging Techniques

### Container Inspection
```bash
# Inspect container details
docker inspect backend_docker_php

# Check container processes
docker-compose exec php ps aux

# View container environment
docker-compose exec php env | grep -E "(DB_|REDIS_|APP_)"
```

### Network Debugging
```bash
# Test connectivity between containers
docker-compose exec php ping database
docker-compose exec php ping redis

# Check network configuration
docker network inspect backend_docker

# Trace network routes
docker-compose exec php traceroute database
```

### Volume Debugging
```bash
# List volumes
docker volume ls

# Inspect volume
docker volume inspect backend_docker_db_volume

# Check mount points
docker-compose exec php ls -la /var/www/
```

### Log Analysis
```bash
# Follow logs in real-time
make logs-watch

# Filter logs by service
docker-compose logs php | grep ERROR

# Check recent logs
docker-compose logs --tail=100 php

# Log timestamps
docker-compose logs -t php
```

---

## 🛠️ Environment Reset Procedures

### Soft Reset
```bash
# Restart services
make restart

# Clear caches
make php-bash
php artisan cache:clear
php artisan config:clear
php artisan route:clear
```

### Hard Reset
```bash
# Stop and remove containers
make down

# Remove volumes (data loss!)
docker-compose down -v

# Rebuild from scratch
make build
```

### Complete Reset
```bash
# Destroy everything
make destroy

# Clean Docker system
docker system prune -a

# Rebuild
make build
```

---

## 📱 Service-Specific Issues

### PHP Service

#### Issue: Xdebug Not Working
**Symptoms**:
- IDE not connecting to debugger
- Breakpoints not hitting

**Solutions**:
```bash
# Check Xdebug installation
make php-bash
php -m | grep xdebug

# Check Xdebug configuration
php -i | grep xdebug

# Verify IDE configuration
# Check PhpStorm/VSCode Xdebug settings
# Server name should match: backend_docker_XdebugServer
```

#### Issue: Composer Issues
**Symptoms**:
```
Composer could not find a composer.json file
```

**Solutions**:
```bash
# Check if in correct directory
make php-bash
pwd
ls -la composer.json

# Install Composer dependencies
composer install

# Clear Composer cache
composer clear-cache
```

### Web Service

#### Issue: Nginx Configuration Errors
**Symptoms**:
```
nginx: [emerg] invalid number of arguments
```

**Solutions**:
```bash
# Test Nginx configuration
docker-compose exec web nginx -t

# Check configuration files
docker-compose exec web cat /etc/nginx/conf.d/default.conf

# Reload Nginx
docker-compose exec web nginx -s reload
```

#### Issue: Node.js Build Failures
**Symptoms**:
```
npm ERR! code ENOSPC
npm ERR! syscall mkdir
```

**Solutions**:
```bash
# Clear npm cache
make web-bash
npm cache clean --force

# Increase node memory limit
export NODE_OPTIONS="--max-old-space-size=4096"

# Delete node_modules and reinstall
rm -rf node_modules package-lock.json
npm install
```

### Database Service

#### Issue: MySQL Startup Failures
**Symptoms**:
```
MySQL init process failed.
```

**Solutions**:
```bash
# Check database logs
docker-compose logs database

# Remove corrupted data
docker-compose down -v
docker-compose up -d database

# Rebuild database
docker-compose build --no-cache database
```

### Redis Service

#### Issue: Redis Connection Refused
**Symptoms**:
```
Connection refused [tcp://127.0.0.1:6379]
```

**Solutions**:
```bash
# Test Redis connection
docker-compose exec redis redis-cli ping

# Check Redis logs
docker-compose logs redis

# Restart Redis
docker-compose restart redis
```

---

## 🌐 External Access Issues

### Cannot Access from Host

#### Issue: Services Not Accessible
**Symptoms**:
- Browser shows "Connection refused"
- Services not accessible from host machine

**Solutions**:
```bash
# Check actual port mappings
make ps

# Test with curl using assigned ports
curl -I http://localhost:32768  # Use actual port from make ps

# Check firewall
sudo ufw status
```

#### Issue: Port Changes After Restart
**Symptoms**:
- Ports worked yesterday but different today
- Bookmarks no longer work

**Solutions**:
```bash
# Docker auto-assigns ports - check current mappings
make ps

# Update bookmarks with current ports
# Or consider using fixed port mapping in docker-compose.yml
```

---

## 📞 Getting Help

### Collect Debug Information
```bash
# System information
docker info
docker version
docker-compose version

# Environment status
make ps
make conf

# Recent logs
make logs --tail=50

# Network information
docker network ls
docker network inspect backend_docker
```

### When to Ask for Help
- Issues persist after trying all solutions
- Error messages not covered in this guide
- Performance problems that can't be resolved
- Complex configuration changes needed

### Information to Provide
1. **Error message**: Full error output
2. **Command**: What command caused the issue
3. **Environment**: OS, Docker version
4. **Configuration**: Relevant `.env` variables
5. **Logs**: Recent service logs

---

*For general setup information, see [Getting Started](getting-started.md). For service details, see [Services Overview](services-overview.md).*
