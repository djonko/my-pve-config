# Pihole & Stubby

### how to fix address already in use
>stubby  | [06:02:40.191079] STUBBY: Read config from file /usr/local/etc/stubby/stubby.yml[06:02:40.193175] STUBBY: Stubby version: Stubby 0.4.3
stubby  | [06:02:40.193534] STUBBY: DNSSEC Validation is ON
stubby  | [06:02:40.193716] STUBBY: Transport list is:
stubby  | [06:02:40.193904] STUBBY:   - TLS
stubby  | [06:02:40.194103] STUBBY: Privacy Usage Profile is Strict (Authentication required)
stubby  | [06:02:40.194271] STUBBY: (NOTE a Strict Profile only applies when TLS is the ONLY transport!!)
stubby  | [06:02:40.194439] STUBBY: Starting DAEMON....
Error response from daemon: driver failed programming external connectivity on endpoint pihole (6e853387b0a196ad06b4ce9c92050619e7c6418569adda26d8cc5db706c0d7a5): Error starting userland proxy: listen tcp4 0.0.0.0:53: bind: address already in use
> 

```bash
sudo systemctl disable systemd-resolved.service
sudo systemctl stop systemd-resolved
```

[Pi-hole port 53 “address already in use” (Portainer/Docker)](https://aaronfisher.net/2022/04/pi-hole-port-53-address-already-in-use-portainer-docker/)