## Create Manual Instance

- Resource: VPC
- name:
  - my-vpc-0
  - my-vpc-1

---

## Create tf

```hcl
resource "aws_vpc" "main" {
  count      = 1
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "my-vpc-${count.index}"
  }
}
```

```sh
cd infra
terraform init
terraform fmt && terraform validate

terraform state list
# none
```

### Backup state

```sh
terraform state pull > backup.tfstate
```

### Import resource: CLI

```sh
terraform import aws_vpc.main[0] vpc-09ba80f07e9c0937a
# aws_vpc.main[0]: Importing from ID "vpc-09ba80f07e9c0937a"...
# aws_vpc.main[0]: Import prepared!
#   Prepared aws_vpc for import
# aws_vpc.main[0]: Refreshing state... [id=vpc-09ba80f07e9c0937a]

# Import successful!

# The resources that were imported are shown above. These resources are now in
# your Terraform state and will henceforth be managed by Terraform.

# confirm
terraform state list
# aws_vpc.main[0]

terraform state show aws_vpc.main[0]
# # aws_vpc.main[0]:
# resource "aws_vpc" "main" {
#     arn                                  = "arn:aws:ec2:ca-central-1:099139718958:vpc/vpc-09ba80f07e9c0937a"
#     assign_generated_ipv6_cidr_block     = false
#     cidr_block                           = "10.0.0.0/16"
#     default_network_acl_id               = "acl-096f4418c9d79b9e6"
#     default_route_table_id               = "rtb-0a1e2006617c72a7a"
#     default_security_group_id            = "sg-0095056f9bcd11c67"
#     dhcp_options_id                      = "dopt-077605ecfdd0f617f"
#     enable_dns_hostnames                 = false
#     enable_dns_support                   = true
#     enable_network_address_usage_metrics = false
#     id                                   = "vpc-09ba80f07e9c0937a"
#     instance_tenancy                     = "default"
#     ipv6_association_id                  = null
#     ipv6_cidr_block                      = null
#     ipv6_cidr_block_network_border_group = null
#     ipv6_ipam_pool_id                    = null
#     ipv6_netmask_length                  = 0
#     main_route_table_id                  = "rtb-0a1e2006617c72a7a"
#     owner_id                             = "099139718958"
#     tags                                 = {
#         "Name" = "my-vpc-0"
#     }
#     tags_all                             = {
#         "Name" = "my-vpc-0"
#     }
# }

# confirm: no changes
terraform plan
# aws_vpc.main[0]: Refreshing state... [id=vpc-09ba80f07e9c0937a]

# No changes. Your infrastructure matches the configuration.

# Terraform has compared your real infrastructure against your configuration and found no differences, so no changes are needed.

terraform apply
# aws_vpc.main[0]: Refreshing state... [id=vpc-09ba80f07e9c0937a]

# No changes. Your infrastructure matches the configuration.

# Terraform has compared your real infrastructure against your configuration and found no differences, so no changes are needed.

# Apply complete! Resources: 0 added, 0 changed, 0 destroyed.
```

## Import resource: Import Block

- update count = 2

```hcl
import {
  id = "vpc-03c724534178bc067"
  to = aws_vpc.main[1]
}
```

```sh
# update state file
terraform refresh
# aws_vpc.main[1]: Preparing import... [id=vpc-03c724534178bc067]
# aws_vpc.main[1]: Refreshing state... [id=vpc-03c724534178bc067]
# aws_vpc.main[0]: Refreshing state... [id=vpc-09ba80f07e9c0937a]

# confirm
terraform state list
# aws_vpc.main[0]
# aws_vpc.main[1]

terraform plan
# aws_vpc.main[1]: Refreshing state... [id=vpc-03c724534178bc067]
# aws_vpc.main[0]: Refreshing state... [id=vpc-09ba80f07e9c0937a]

# No changes. Your infrastructure matches the configuration.

# Terraform has compared your real infrastructure against your configuration and found no differences, so no changes are needed.

terraform apply
# aws_vpc.main[1]: Refreshing state... [id=vpc-03c724534178bc067]
# aws_vpc.main[0]: Refreshing state... [id=vpc-09ba80f07e9c0937a]

# No changes. Your infrastructure matches the configuration.

# Terraform has compared your real infrastructure against your configuration and found no differences, so no changes are needed.

# Apply complete! Resources: 0 added, 0 changed, 0 destroyed.
```

---

## Import resource: Auto Generate

- add

```hcl
import {
  id = "vpc-030987a3bede89b90"
  to = aws_vpc.app
}
```

```sh
terraform plan -generate-config-out=generated.tf

terraform refresh
# aws_vpc.app: Preparing import... [id=vpc-030987a3bede89b90]
# aws_vpc.app: Refreshing state... [id=vpc-030987a3bede89b90]
# aws_vpc.main[1]: Refreshing state... [id=vpc-03c724534178bc067]
# aws_vpc.main[0]: Refreshing state... [id=vpc-09ba80f07e9c0937a]

terraform plan
# aws_vpc.main[0]: Refreshing state... [id=vpc-09ba80f07e9c0937a]
# aws_vpc.main[1]: Refreshing state... [id=vpc-03c724534178bc067]
# aws_vpc.app: Refreshing state... [id=vpc-030987a3bede89b90]

# No changes. Your infrastructure matches the configuration.

# Terraform has compared your real infrastructure against your configuration and found no differences, so no changes are needed.
```
