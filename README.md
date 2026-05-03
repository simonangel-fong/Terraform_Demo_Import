# Terraform Import Demo

> Demonstrates how to import existing AWS infrastructure into Terraform state.

**Stack:** Terraform + AWS VPC

---

## Terraform Import

- `Terraform Import`
  - a process to **bring existing infrastructure resources**—created manually or via other tools—under Terraform management.
  - lnks real-world cloud objects to Terraform state
  - track and update them as code without rebuilding them from scratch.

- **Method**

| Method                                        | When to Use                                    |
| --------------------------------------------- | ---------------------------------------------- |
| `resource` block + `terraform import` command | Quick one-off import from the command line     |
| `resource` block + `import {}` block          | Declarative import, tracked in version control |
| `import {}` + `-generate-config-out`          | No resource block yet — auto-generate it       |

---

## Structure

```
infra/
  01_variables.tf       # project name, AWS region
  02_terraform.tf       # provider and backend config
  03_main.tf            # aws_vpc resource definition
  04_main_import.tf     # import block for method 2
docs/
  phase.md              # step-by-step walkthrough with commands and output
```

---

## Key Steps

### `terraform import` Command

Import an existing VPC into state without modifying any `.tf` file.

```sh
cd infra
terraform init
terraform import aws_vpc.main[0] <vpc-id>
terraform state list
terraform plan   # expect: no changes
```

---

### Import Block

Declare the import in code — repeatable and peer-reviewable.

```hcl
import {
  id = "<vpc-id>"
  to = aws_vpc.main[1]
}
```

```sh
terraform refresh
terraform plan   # expect: no changes
terraform apply
```

---

### Auto-Generate Config

Use when no `resource` block exists yet. Terraform generates it.

```hcl
import {
  id = "<vpc-id>"
  to = aws_vpc.app
}
```

```sh
terraform plan -generate-config-out=generated.tf   # creates resource block
terraform refresh
terraform plan   # expect: no changes
```

---
