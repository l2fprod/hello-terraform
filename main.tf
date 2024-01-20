variable "string_count" {
  default = 1
}

resource "random_string" "random" {
  count = var.string_count

  length           = 16
  special          = true
  override_special = "/@£$"
}

output "result" {
  value = [ for r in random_string.random: r.result ]
}
