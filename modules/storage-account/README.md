# Module: storage-account

A StorageV2 account hardened by default:

- HTTPS only, TLS 1.2 minimum, no anonymous blob access.
- Firewall set to **Deny**, allowing only listed subnets (via service endpoints), IPs and trusted Azure services.
- Blob versioning plus soft delete for blobs and containers.
- Private containers created through the management plane.

| Output | Description |
|---|---|
| `id` / `name` | The storage account |
| `primary_blob_endpoint` | Blob endpoint URL |
