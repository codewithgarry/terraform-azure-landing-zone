# Module: linux-vm

An Ubuntu 24.04 VM with secure defaults:

- **No public IP.** The NIC is private only.
- **SSH key login only.** Password authentication is disabled.
- **System-assigned managed identity** for access to other Azure resources without secrets.
- **Managed boot diagnostics** for troubleshooting boot failures.

| Output | Description |
|---|---|
| `id` | VM resource ID |
| `private_ip` | Private IP address |
| `principal_id` | Managed identity object ID, for role assignments |
