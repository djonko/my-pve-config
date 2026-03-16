1. Create the authentication file
```bash
docker run --rm --entrypoint htpasswd httpd:2 -Bbn registryuser 'StrongPassword' > auth/htpasswd
```
2. Traefik security config
```
# middlewares
- traefik.http.routers.registry.middlewares=registry-ip,registry-ratelimit,registry-secure

# IP allowlist (adjust)
- traefik.http.middlewares.registry-ip.ipallowlist.sourcerange=1.2.3.4/32,10.0.0.0/8

# rate limit
- traefik.http.middlewares.registry-ratelimit.ratelimit.average=100
- traefik.http.middlewares.registry-ratelimit.ratelimit.burst=50

# security headers
- traefik.http.middlewares.registry-secure.headers.stsSeconds=31536000
- traefik.http.middlewares.registry-secure.headers.stsIncludeSubdomains=true
- traefik.http.middlewares.registry-secure.headers.stsPreload=true
- traefik.http.middlewares.registry-secure.headers.frameDeny=true
- traefik.http.middlewares.registry-secure.headers.contentTypeNosniff=true
- traefik.http.middlewares.registry-secure.headers.browserXssFilter=true

```