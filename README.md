# Usage

**Pulling files using Git:** `git clone --recursive https://github.com/draconiandeveloper/gladiatus-docker gladiatus`

**Building PHP:** `docker-compose build`

**Running (with local edits):** `docker-compose watch`

# Local IP addresses

- PostgreSQL: `172.20.0.3`
- Nginx: `172.20.0.2`

# Creating my own SSL certificate

`openssl req -new -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out ssl/gladiatus_lan.crt -keyout ssl/gladiatus_lan.key`

`openssl dhparam -out ssl/dhparam.pem 4096`

# Directory Structure

```
app: The website contents (including backend)

cfg: The Nginx and Redis configuration files

docker: The PHP build Docker file

env: The PostgreSQL environment variables

ssl: Where the SSL certificates are stored
```

# Plans

- [ ] Modernize the source from PHP 5.4 to PHP 8.4.5

- [ ] Minify and reformat the database structure

- [X] Incorporate Redis

- [ ] Create an API

- [ ] Document the API

- [ ] Create an "installer" to support multiple DBMS types

