# Secure OpenSSH Isolation Guide
**Target System:** DevOps & AI Inference Server / Debian 13 (Trixie) LXC
**Goal:** Harden SSH access against brute-force attacks and isolate modifications to prevent system package update conflicts.

---

## 1. Create the Isolated Configuration File

OpenSSH on modern Linux distributions automatically processes all files ending in `.conf` inside the `/etc/ssh/sshd_config.d/` directory **before** reading the primary layout file.

The `99-` prefix ensures this file loads last, successfully overriding any default system parameters.

Run this command inside your terminal to create the configuration profile:
```bash
nano /etc/ssh/sshd_config.d/99-security-hardening.conf
```

---

## 2. Hardening Profile Contents

Copy and paste the exact configuration rules below into the file:

```text
# =====================================================================
# SYSTEM HARDENING: SECURE OPENSSH ISOLATED CONFIGURATION PROFILE
# =====================================================================

# 1. Root User Restrictions
# Force Root user to authenticate ONLY via SSH Keys (Blocks all password attempts)
PermitRootLogin prohibit-password

# 2. Authentication Protocol Safety
# Disable password authentication globally for all accounts (Enforces SSH Keys)
PasswordAuthentication no
# Absolute ban on empty user passwords
PermitEmptyPasswords no
# Disable weak legacy host-based trust authentication mechanisms
HostbasedAuthentication no

# 3. Defensive Countermeasures
# Validate file ownership and permissions of public keys before granting entry
StrictModes yes
# Disconnect connection attempts after 3 failed tries (Defeats automated brute-force scripts)
MaxAuthTries 3
# Maximum window allowed to complete authentication successfully (in seconds)
LoginGraceTime 30

# 4. Session Environment Tuning
# Automatically terminate orphaned, dead, or inactive connections after 30 minutes
ClientAliveInterval 300
ClientAliveCountMax 6
# Disable graphical X11 forwarding (Unnecessary overhead for remote development servers)
X11Forwarding no
```

---

## 3. Safety Verification & Service Reload

Before applying these changes, you must explicitly confirm that your public key is added to the system and that your file syntax contains zero formatting mistakes. Failing to do this could permanently lock you out of the server.

### Step A: Confirm SSH Key Presence
Ensure your client machine's cryptographic public key is securely registered inside the root home folder. The following command printout must **not** be empty:
```bash
cat /root/.ssh/authorized_keys
```

### Step B: Validate Configuration Syntax
Test your isolated rules against the OpenSSH engine parser. If this utility outputs no error messages, your file configuration is structurally safe:
```bash
/usr/sbin/sshd -t
```

### Step C: Restart the Daemon
Apply your security rules instantly by cycling the daemon service runtime state:
```bash
systemctl restart ssh
```

> ⚠️ **CRITICAL SECURITY NOTE:** Keep your active terminal session window wide open. Launch a completely separate terminal window on your workspace machine and test the connection loop (`ssh root@your_lxc_ip`) to verify your keys pass through properly before disconnecting your primary administrator session.
