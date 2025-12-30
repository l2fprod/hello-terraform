# PostgreSQL Cluster Module

This Terraform module provisions a simple, opinionated PostgreSQL cluster. It's intended as an example/starting point for infrastructure that requires a small multi-node Postgres setup with automated credentials and a basic backup policy.

## Features

- Create a configurable number of Postgres nodes
- Generate strong administrative credentials
- Configure storage size and instance type per node
- Expose a single cluster endpoint and per-node endpoints
- Provide a simple backup retention policy output

## Requirements

- Terraform 1.0+
- Providers: none required explicitly in the module (the module is intentionally provider-agnostic and returns logical outputs). You may adapt the resources to your cloud provider of choice.

## Inputs

- `cluster_name` (string, optional) — Name of the PostgreSQL cluster. Default: `pg-cluster`.
- `node_count` (number, optional) — Number of nodes in the cluster. Default: `3`.
- `node_instance_type` (string, optional) — Instance type for each node. Default: `db.m5.large`.
- `storage_size_gb` (number, optional) — Storage size in GB for each node. Default: `100`.
- `backup_retention_days` (number, optional) — Backup retention days. Default: `7`.

These inputs are defined in `main.tf` inside the module and can be overridden by the caller.

## Outputs

- `cluster_endpoint` — The logical DNS name for the cluster (e.g. `${cluster_name}.example.com`).
- `node_endpoints` — A list of logical endpoints for individual nodes (useful for monitoring or direct node access).
- `storage_info` — Object containing storage size and type used by nodes.
- `backup_policy` — Object with backup retention days and a default window.
- `credentials` (sensitive) — Object with `username` and `password` generated for the cluster admin. The `password` is generated using `random_password` and marked sensitive.

Note: The module intentionally returns logical endpoint values (example.com) so that it is easy to adapt to different cloud provider resources in the calling configuration.

## Example Usage

Basic example (in the root module):

```hcl
module "postgres" {
  source             = "./modules/postgresql-cluster"
  cluster_name       = "my-prod-db"
  node_count         = 3
  node_instance_type = "db.m5.large"
  storage_size_gb    = 200
  backup_retention_days = 14
}

output "pg_endpoint" {
  value = module.postgres.cluster_endpoint
}

output "pg_credentials" {
  value     = module.postgres.credentials
  sensitive = true
}
```

## Notes and Best Practices

- This module is intentionally lightweight and returns logical outputs rather than tying to a specific cloud provider's managed service resources. In production, replace the placeholder endpoint logic with your cloud provider's resource attributes (RDS/Azure Database/Cloud SQL, etc.).
- Treat the `credentials` output as sensitive. Avoid printing passwords in CI logs.
- Consider integrating automated snapshots/backups using your cloud provider's native features rather than relying on this module's simple policy output.
- Use secure network controls (private subnets, security groups) to limit access to Postgres nodes.

## Testing

- You can run `terraform init` and `terraform plan` in a temporary environment that sources this module to validate input combinations.
- For provider-specific implementations add unit/integration tests with tools like `terratest` or `kitchen-terraform`.

## Contributing

If you extend this module to target a specific provider, please:

- Add inputs to configure provider-specific settings.
- Add examples demonstrating provider-specific usage.
- Document and test backup/restore procedures.

## Authors

- Maintained by the infrastructure team.

## License

See the repository LICENSE file for licensing terms.

---

Module source: `modules/postgres-cluster`
# Postgres Cluster Module