Here’s a **clean, production-ready how-to** you can drop into your documentation.

---

# 🛠️ Proxmox – Kernel Auto-Recovery Configuration

## 🎯 Purpose

Improve host resilience on Proxmox VE by:

* automatically rebooting after kernel crashes
* recovering from CPU lockups (soft lockups)
* reducing false positives under load

---

# ⚙️ Configuration

```bash
kernel.panic = 10
kernel.softlockup_panic = 1
kernel.watchdog_thresh = 60
```

---

# 📖 Parameter Explanation

## `kernel.panic = 10`

* Reboots the system **10 seconds after a kernel panic**
* Defined in Linux kernel sysctl documentation

👉 Purpose:

* Ensures automatic recovery from critical kernel crashes

---

## `kernel.softlockup_panic = 1`

* Triggers a kernel panic if a CPU is stuck (soft lockup)
* Based on Linux kernel watchdog behavior

👉 Purpose:

* Prevents a “frozen but still running” system

---

## `kernel.watchdog_thresh = 60`

* Time (in seconds) before a CPU is considered stuck

👉 Why 60:

* Balanced value
* Reduces false positives under:

    * high CPU load
    * virtualization (VMs)
    * containers

---

# 📂 Setup Steps

## 1. Create a dedicated config file

```bash
nano /etc/sysctl.d/99-proxmox-tuning.conf
```

---

## 2. Add configuration

```bash
kernel.panic = 10
kernel.softlockup_panic = 1
kernel.watchdog_thresh = 60
```

---

## 3. Apply without reboot

```bash
sysctl --system
```

---

## 4. Verify

```bash
sysctl kernel.panic
sysctl kernel.softlockup_panic
sysctl kernel.watchdog_thresh
```

---

# ⚠️ Important Considerations

## 🔁 Host reboot impact

* When the host reboots → **all VMs restart**

---

## 🔄 Potential reboot loop

If a faulty kernel is installed:

* panic → reboot → panic → loop

👉 Mitigation:

```bash
dpkg --list | grep pve-kernel
```

* Keep multiple kernels installed
* Do NOT remove older working kernels

---

## 🖥️ Console access required

In case of failure, you need:

* Proxmox web console
* IPMI / iLO / KVM
* or physical access

---

## 📊 Monitoring (recommended)

Without monitoring, reboots may go unnoticed:

* Gotify
* Uptime Kuma
* Prometheus (optional)

---

# ⚖️ Why This Configuration

| Parameter    | Reason                        |
| ------------ | ----------------------------- |
| panic=10     | automatic recovery without HA |
| softlockup=1 | prevents silent freezes       |
| watchdog=60  | avoids false positives        |

👉 Best suited for:

* small production environments
* homelabs
* single-node setups (no HA cluster)
