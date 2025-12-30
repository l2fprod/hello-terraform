variable "cluster_name" {
  description = "The name of the PostgreSQL cluster"
  type        = string
  default     = "pg-cluster"
}

variable "node_count" {
  description = "Number of nodes in the PostgreSQL cluster"
  type        = number
  default     = 3
}

variable "node_instance_type" {
  description = "Instance type for each PostgreSQL node"
  type        = string
  default     = "db.m5.large"
}

variable "storage_size_gb" {
  description = "Storage size in GB for each PostgreSQL node"
  type        = number
  default     = 100
}

variable "backup_retention_days" {
  description = "Number of days to retain backups"
  type        = number
  default     = 7
}

resource "random_password" "pg_password" {
  length           = 20
  special          = true
  override_special = "!@#$%&*()-_"
}

output "cluster_endpoint" {
  description = "The endpoint of the PostgreSQL cluster"
  value       = "${var.cluster_name}.example.com"
}

output "node_endpoints" {
  description = "The endpoints of the PostgreSQL nodes"
  value       = [for i in range(var.node_count) : "${var.cluster_name}-node-${i + 1}.example.com"]
}

output "storage_info" {
  description = "Storage information for each PostgreSQL node"
  value = {
    size_gb = var.storage_size_gb
    type    = "gp2"
  }
}

output "backup_policy" {
  description = "Backup policy details"
  value = {
    retention_days = var.backup_retention_days
    window         = "00:00-02:00"
  }
}

output "credentials" {
  description = "Credentials for accessing the PostgreSQL cluster"
  value = {
    username = "admin"
    password = random_password.pg_password.result
  }
  sensitive = true
}
