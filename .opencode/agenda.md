# OpenCode Agenda – my-pve-config

## Scope
Root: `/run/media/sabadam/HOME_LINUX/sabadam/Projects/my-pve-config`
A collection of homelab quick-starters: Docker stacks, Ansible, Proxmox, Kubernetes, scripts, and docs.

## Agents

### docker-agent
Purpose: Manage Docker Compose stacks under `docker/` and `docker/apps/`.
Responsibilities:
- Read/merge compose files (`docker-compose.yml`, `docker-compose.*.yml`)
- Validate compose config (`docker compose config`)
- Generate scaffolds for new services following existing structure
- Inspect images, networks, and volumes
Globs:
- `docker/**/*.yml`
- `docker/**/**.md`
- `docker/apps/**/docker-compose*.yml`

### ansible-agent
Purpose: Maintain Ansible playbooks and inventories.
Responsibilities:
- Read `ansible/**/*.yml` and `ansible/**/*.j2`
- Lint with `ansible-lint` (when available)
- Generate playbooks for Proxmox / host provisioning
Globs:
- `ansible/**/*.yml`
- `ansible/**/*.j2`
- `ansible/**/*.md`

### search-agent
Purpose: Find setup instructions for open-source projects.
Responsibilities:
- Search web for official docs and Docker Compose examples
- Retrieve Context7 documentation for frameworks
- Summarize required env vars, ports, volumes
Globs: none – uses websearch / Context7.

### linux-executor
Purpose: Execute local shell and Docker commands, SSH to remote hosts.
Responsibilities:
- Run `shell`, `docker`, `docker compose` commands
- SSH to Proxmox nodes (via SSH config)
- Inspect filesystem, logs, and process status
Permissions: requires user confirmation for destructive ops.

### verifier-agent
Purpose: Verify tasks and ensure correctness.
Responsibilities:
- Validate configs (`docker compose config`, `ansible-playbook --syntax-check`)
- Compare against repo patterns, flag regressions
- Report PASS/FAIL with remediation

### architect-agent
Purpose: Main orchestrator / architect.
Responsibilities:
- Best-practice guidance for Docker, Ansible, Linux, Kubernetes, self-hosting, Proxmox
- Coordinate specialized agents
- Design architecture and enforce conventions

## Workflows
1. New Docker app: docker-agent scaffolds a compose file following existing patterns (`services/`, volumes at `/opt/data-docker/...`, `ai_network` when relevant)
2. Ansible changes: ansible-agent validates playbooks and runs dry-run
3. Research new open-source tool: search-agent finds repo/README and official compose example, then docker-agent adapts it
4. Deploy: linux-executor runs `docker compose up -d`, `ansible-playbook`, or SSH commands

## Notes
- Repo uses JetBrains `.idea/` metadata; no OpenCode config existed before.
- Keep existing directory conventions; do not rename folders.
- Secrets: avoid committing secrets; use `.env` files referenced by compose.
