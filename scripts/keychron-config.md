# How to setup keychron keyboard on fedora

1. Add Current user to input group:
```bash
sudo usermod -aG input $USER
```

2. get the device vendor Id
```bash
lsusb
```

> ID <idVendor>:<idProduct>
> Bus 003 Device 002: ID 3434:0120 Keychron Keychron V6

3. add keychron udev rules:
```bash
sudo nano /etc/udev/rules.d/99-keychron.rules
```
Add the following lines to the file:
```text
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", MODE="0660", GROUP="input"
```
4. Reload udev rules:
```bash
sudo udevadm control --reload-rules
sudo udevadm trigger
```