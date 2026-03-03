# Network Configuration

This document explains the static IP network architecture used in the Docker development environment.

## 🌐 Network Architecture

The environment uses a custom bridge network with **fixed IP addresses** for reliable service communication.

### Network Details
- **Name**: `backend_docker` ( configurable via `DOCKER_APP_NAME`)
- **Type**: Bridge network
- **Subnet**: `172.21.0.0/24`
- **Driver**: Bridge
- **IP Assignment**: Static (fixed) for all services

### IP Address Allocation

| Service | Container                   | IP Address | Access          |
|---------|-----------------------------|----------|-----------------|
| PHP/App | `backend_docker_php`        | `172.19.10.11` | Port 9000       |
| Web/Nginx | `backend_docker_web`        | `172.19.10.12` | Port 80, 5173   |
| MySQL | `backend_docker_database`   | `172.19.10.13` | Port 3306       |
| phpMyAdmin | `backend_docker_phpmyadmin` | `172.19.10.14` | Port 80         |
| MailHog | `backend_docker_mailhog`    | `172.19.10.15` | Port 8025       |
| Redis | `backend_docker_redis`      | `172.19.10.16` | Port 6379       |
| Selenium | `backend_docker_selenium`   | `172.19.10.17` | Port 4444, 5900 |

**Key Benefits of Static IPs:**
- Predictable service communication
- No DNS resolution delays
- Reliable configuration
- Easy debugging


## 📝 Configuration Files

### `.docker/.env.docker`
```bash
# Network Name
DOCKER_APP_NAME=backend_docker

# Network Configuration
DOCKER_NETWORK_SUBNET=172.21.0.0/24

# Service IP Addresses
DOCKER_PHP_NETWORK_IP_ADDRESS=172.21.0.11
DOCKER_WEB_NETWORK_IP_ADDRESS=172.21.0.12
DOCKER_DATABASE_NETWORK_IP_ADDRESS=172.21.0.13
DOCKER_PHPMYADMIN_NETWORK_IP_ADDRESS=172.21.0.14
DOCKER_MAILHOG_NETWORK_IP_ADDRESS=172.21.0.15
DOCKER_REDIS_NETWORK_IP_ADDRESS=172.21.0.16
DOCKER_SELENIUM_NETWORK_IP_ADDRESS=172.21.0.17
```

### Docker Compose Network Definition
```yaml
networks:
  app_subnet:
    name: ${DOCKER_APP_NAME}
    driver: bridge
    ipam:
      driver: default
      config:
        - subnet: ${DOCKER_NETWORK_SUBNET}
```

## 🔗 Service Communication

### Internal Communication (Static IPs)
Services communicate using fixed internal IP addresses:

```yaml
# PHP connecting to database
DB_HOST: 172.21.0.13

# PHP connecting to Redis
REDIS_HOST: 172.21.0.16

# PHP connecting to Selenium
DUSK_DRIVER_URL: http://172.21.0.17:4444/wd/hub
```

### External Access (Auto-assigned Ports)
Services are accessible from the host machine via **auto-assigned ports**:

```bash
# Check actual port mappings
make ps

# Example output:
# backend_docker_web        -> 0.0.0.0:32768->80/tcp
# backend_docker_phpmyadmin -> 0.0.0.0:32769->80/tcp
```

**Important:** Host ports are automatically assigned by Docker and may change each restart.

## 🔧 Custom Network Configuration

### Changing the Subnet
If you need to use a different subnet:

1. **Update `.docker/.env.docker`**:
   ```bash
   DOCKER_NETWORK_SUBNET=172.20.20.0/24
   ```

2. **Update all service IP addresses**:
   ```bash
   DOCKER_PHP_NETWORK_IP_ADDRESS=172.20.20.11
   DOCKER_WEB_NETWORK_IP_ADDRESS=172.20.20.12
   # ... etc for all services
   ```

3. **Rebuild the environment**:
   ```bash
   make rebuild-container
   ```

### Changing Service Names
To customize the application name:

1. **Update `.docker/.env.docker`**:
   ```bash
   DOCKER_APP_NAME=my-app
   ```

2. **Rebuild**:
   ```bash
   make rebuild-container
   ```

## 🌍 Host Access Configuration

### Docker Desktop (Mac/Windows)
Docker Desktop automatically handles port forwarding to localhost.

### Docker Engine (Linux)
Ensure the Docker daemon is configured to expose ports:

```bash
# Check Docker daemon status
sudo systemctl status docker
```

### Firewall Configuration
If services are not accessible, check firewall settings:

```bash
# Ubuntu/Debian
sudo ufw status
sudo ufw allow 80
sudo ufw allow 8080

# CentOS/RHEL
sudo firewall-cmd --list-ports
sudo firewall-cmd --add-port=80/tcp --permanent
sudo firewall-cmd --add-port=8080/tcp --permanent
sudo firewall-cmd --reload
```

## 🔍 Network Troubleshooting

### Check Network Status
```bash
# List all Docker networks
docker network ls

# Inspect app network
docker network inspect backend_docker (DOCKER_APP_NAME)

# Check container network settings
docker inspect backend_docker_php | grep NetworkMode
```

### Test Service Connectivity
```bash
# From PHP container, test database connection
docker compose exec php ping 172.19.10.13
docker compose exec php nc -zv 172.19.10.13 3306
```

### Common Network Issues

#### Port Conflicts
```bash
# Check if ports are in use
netstat -tulpn | grep :80
netstat -tulpn | grep :3306

# Solution: Change port mappings in docker-compose.yml
```

#### IP Address Conflicts
```bash
# Check if IPs are available
ping -c 1 172.19.10.11

# Solution: Use different subnet or IP addresses
```

#### DNS Resolution
```bash
# Test DNS from container
docker-compose exec php nslookup google.com

# Check Docker DNS settings
docker info | grep DNS
```

## 🚀 Advanced Network Features

### Service Discovery
Services can discover each other by name:
```bash
# From PHP container
docker-compose exec php ping database
docker-compose exec php ping redis
```

### Extra Hosts
PHP container includes host gateway access:
```yaml
extra_hosts:
  - "host.docker.internal:host-gateway"
```

This allows the container to access services running on the host machine.

### Volume Sharing
Services communicate through shared volumes:
- **php-fpm-socket**: PHP-FPM communication between PHP and Nginx
- **Project mount**: Shared codebase across all services

## 🔐 Security Considerations

### Network Isolation
- Services are isolated from other Docker networks
- Only exposed ports are accessible from the host
- Internal communication uses private IP range

### Database Security
- Database is not exposed to the host by default
- Only accessible from within the Docker network
- phpMyAdmin provides web access when needed

### Development vs Production
This network configuration is optimized for development:
- Fixed IPs simplify configuration
- Port mappings provide easy access
- Debugging features are enabled

For production, consider:
- Removing port mappings
- Using environment-specific configurations
- Implementing proper firewall rules

---

*For management commands, see [Makefile Commands](makefile-commands.md).*
