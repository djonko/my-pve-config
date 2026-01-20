# Install Auto-cpufreq as battery power saving manager

1) Disable and mask default gnome power manager `power-profiles-daemon`
```bash
# Stop and disable the daemon
sudo systemctl disable --now power-profiles-daemon

# Prevent it from being re-enabled by other packages
sudo systemctl mask power-profiles-daemo
```

> How to unmask it later
>```bash
>sudo systemctl unmask power-profiles-daemon
>sudo systemctl enable --now power-profiles-daemon
>```

2) install auto-cpu-freq
```bash
git clone https://github.com/AdnanHodzic/auto-cpufreq.git
cd auto-cpufreq && sudo ./auto-cpufreq-installer
```

3) Configure auto-cpufreq by adjusing the `/etc/auto-cpufreq.conf`
copy [auto-cpufreq.conf file](./auto-cpufreq.conf) to /etc/auto-cpufreq.conf
