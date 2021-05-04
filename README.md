# Dockerized Openresty for OIDC
Docker image with support for OIDC setup using Openresty

## Usage

### Build & run
```shell
docker-compose up --build
```

### Enter container
```shell
docker run -it --entrypoint=/bin/bash ucyo/nginx-oidc
```
