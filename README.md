# my-pve-config
Configs of my local stuff

# Portainer Templates Apps
### [Official template](https://raw.githubusercontent.com/portainer/templates/master/templates-2.0.json)
### [SelfHostedPro template v2](https://raw.githubusercontent.com/SelfhostedPro/selfhosted_templates/master/Template/portainer-v2.json)
### [My template(merge of both)](./portainer/template.json)


# How to enable docker remote connexion ?
1) Open file `nano /lib/systemd/system/docker.service`
2) Edit it by replacing line `ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock`
with `ExecStart=/usr/bin/dockerd -H fd:// -H=tcp://0.0.0.0:2375`
3) `systemctl daemon-reload`
4) ```sudo service docker restart```

# How to generate a random password in linux 
-> 32 : represent the password size  
```date +%s | sha256sum | base64 | head -c 32 ; echo```
