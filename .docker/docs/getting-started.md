# Getting Started

This guide will help you set up and start using the Docker backend development environment.

## 🚀 Initial Setup

### 1. Clone the Repository

```bash
git clone <repository-url>
cd backend_docker
```

### 2. Build and Start Services

```bash
# Build all services and start them
make build
```

This command:
- Automatically syncs environment configuration
- Builds all Docker images with your user ID/GID
- Starts all services in detached mode
- Creates necessary volumes and networks

## 🔧 First Run Verification

### Check Service Status

```bash
# View running containers
make ps

# View service logs
make logs
```

### Access Services

```bash
# Access PHP container (as www-data user)
make php-bash

# Access web/Nginx container (as nginx user)
make web-bash

# Access database shell
make database-bash
```

## 📁 Project Structure

```
backend_docker/
├── .docker/
│   ├── docker-compose.yml     # Main Docker Compose configuration
│   ├── .env.docker            # Docker-specific environment variables
│   ├── services/              # Individual service Dockerfiles
│   │   ├── php/
│   │   ├── web/
│   │   ├── database/
│   │   ├── redis/
│   │   ├── phpmyadmin/
│   │   ├── mailhog/
│   │   └── selenium/
│   └── docs/                  # Documentation files
├── .env                       # Root environment file (auto-synced)
├── .dockerignore              # Docker ignore rules
├── Makefile                   # Management commands
└── README.md                  # Main documentation
```

## 🛠️ Common Development Tasks

### Starting/Stopping Services

```bash
# Start all services
make up

# Stop all services
make down

# Restart all services call down then up
make restart

# View running containers
make ps
```

### Working with Containers

```bash
# PHP container (Laravel commands)
make php-bash
# Inside container: art migrate, art tinker, etc.

# Web container (Node.js/NPM commands)
make web-bash
# Inside container: npm install, npm run build, etc.

# Database container
make database-bash
# Inside container: MySQL shell
```

### Import Database

```bash
# Import database from dump.sql file
make database-import
```

## 🔄 Environment Configuration

### Understanding Environment Files

1. **`.docker/.env.docker`** - Docker-specific configuration
   - Network IP addresses (172.21.0.0/24)
   - Docker paths

2. **`.env`** - Root environment file
   - Auto-synced from `.docker/.env.docker`
   - Application-specific variables
   - Database credentials

### Syncing Configuration

The `sync-env` command automatically updates the root `.env` file eveytime with any command:

```bash
make sync-env
```

This happens automatically when you run most Make commands.

## 🐛 Common First Issues

### Permission Issues

If you encounter permission errors, ensure your user ID/GID are correctly set:

```bash
# Check your user ID and group ID
id
```

The Docker containers are built to match your local user permissions.

### Network Issues

If services can't communicate, check the network configuration:

```bash
# View Docker networks
docker network ls

# Inspect app network
docker network inspect backend_docker
```

## 📚 Next Steps

After successful setup:

1. Read the [Services Overview](services-overview.md) to understand each service
2. Check [Network Configuration](network-configuration.md) for advanced networking
3. Review [Makefile Commands](makefile-commands.md) for all available commands
4. Visit [Troubleshooting](troubleshooting.md) if you encounter issues

## 🆘 Getting Help

If you encounter issues:

1. Check service logs: `make logs`
2. Verify service status: `make ps`
3. Review the [Troubleshooting](troubleshooting.md) guide
4. Check Docker Desktop logs for system-level issues

---

*Ready to start development! Check the other documentation files for detailed information about each service and advanced configuration options.*
