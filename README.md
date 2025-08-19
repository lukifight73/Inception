## Inception - 42

# Description:
Inception is a project about containerization and service orchestration using Docker and docker-compose. The goal is to set up a small infrastructure composed of multiple services, each running in its own container. The project requires deploying and configuring a stack with an Nginx web server (with TLS), a MariaDB database, and a WordPress website, all interconnected within a custom Docker network. The challenge lies in ensuring isolation, persistence, automation, and security while maintaining a reproducible and scalable environment.

# Context:
Part of 42 Common Core.

# Main Technologies / Skills Used:
- **Programming / Configuration**: Shell scripting, Docker, docker-compose, Makefile
- **Containerization**: Building and managing isolated environments with Docker
- **Orchestration**: Defining and managing multi-service applications with docker-compose
- **Networking**: Configuring Docker networks to allow communication between containers

# Services:

- **Nginx** (web server with TLS/SSL)
- **WordPress** (CMS deployed with PHP-FPM)
- **MariaDB** (relational database)
- **Volumes & Persistence**: Storing database data and WordPress files with Docker volumes
- **Security**: Enabling HTTPS with self-signed SSL certificates
- **Automation**: Automated setup and deployment with Makefile and initialization scripts
- **System Administration**: Understanding service management and interaction in a containerized environment

# Installation and compilation
1. Clone this repository into your virtual machine:
```bash
git clone git@github.com:lukifight73/Inception.git
```
2. Run the following command to build and start the containers:
```bash
make
```
3. Access your WordPress website through:
```bash
https://42.login42.fr
```
