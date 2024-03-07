# How to run crowdsec 

## files:
- [docker-compose](docker-compose.yml)
- [.env](config.nginx.env)

1) check if crowdsec is running well with command 
```bash
docker exec -it crowdsec cscli metrics
```
2) Create an api-key for the bouncers (nginx-proxy)
```bash
docker exec -it crowdsec cscli bouncers add nginx-proxy
```
3) add the generated bouncers in 