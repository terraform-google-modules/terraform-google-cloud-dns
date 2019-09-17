# Terraform Google Cloud DNS Module

This module makes it easy to create Google Cloud DNS zones of different types, and manage their records. It supports creating public, private, forwarding, and peering zones.

The resources/services/activations/deletions that this module will create/trigger are:

- One `google_dns_managed_zone` for the zone
- Zero or more `google_dns_record_set` for the zone records

## Compatibility

 This module is meant for use with Terraform 0.12. If you haven't [upgraded](https://www.terraform.io/upgrade-guides/0-12.html)
  and need a Terraform 0.11.x-compatible version of this module, the last released version intended for
  Terraform 0.11.x is [0.1.0](https://registry.terraform.io/modules/terraform-google-modules/folders/google/0.1.0).

## Usage

Basic usage of this module for a private zone is as follows:

```hcl
module "dns-private-zone" {
  source     = "../.."
  project_id = var.project_id
  type       = "private"
  name       = var.name
  domain     = var.domain

  private_visibility_config_networks = [var.network_self_link]

  record_names = ["localhost"]
  record_data = [
    {
      rrdatas = "127.0.0.1"
      type    = "A"
    },
  ]
}

```

Functional examples are included in the [examples](./examples/) directory.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| domain | Zone domain, must end with a period. | string | n/a | yes |
| name | Zone name, must be unique within the project. | string | n/a | yes |
| private\_visibility\_config\_networks | List of VPC self links that can see this zone. | list(string) | `<list>` | no |
| project\_id | Project id for the zone. | string | n/a | yes |
| record\_data | List of maps with type, rrdatas and optional ttl for static zone records. | list | `<list>` | no |
| record\_names | List of record names for static zones. | list | `<list>` | no |
| target\_name\_server\_addresses | List of target name servers for forwarding zone. | list(string) | `<list>` | no |
| target\_network | Peering network. | string | `""` | no |
| type | Type of zone to create, valid values are 'public', 'private', 'forwarding', 'peering'. | string | `"private"` | no |

## Outputs

| Name | Description |
|------|-------------|
| domain | The DNS zone domain. |
| name | The DNS zone name. |
| name\_servers | The DNS zone name servers. |
| type | The DNS zone type. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

These sections describe requirements for using this module.

### Software

The following dependencies must be available:

- [Terraform][terraform] v0.12
- [Terraform Provider for GCP][terraform-provider-gcp] plugin v2.14

### Service Account

User or service account credentials with the following roles must be used to provision the resources of this module:

- Storage Admin: `roles/dns.admin`

The [Project Factory module][project-factory-module] and the
[IAM module][iam-module] may be used in combination to provision a
service account with the necessary roles applied.

### APIs

A project with the following APIs enabled must be used to host the
resources of this module:

- Google Cloud DNS API: `dns.googleapis.com`

The [Project Factory module][project-factory-module] can be used to
provision a project with the necessary APIs enabled.

## Contributing

Refer to the [contribution guidelines](./CONTRIBUTING.md) for
information on contributing to this module.

[iam-module]: https://registry.terraform.io/modules/terraform-google-modules/iam/google
[project-factory-module]: https://registry.terraform.io/modules/terraform-google-modules/project-factory/google
[terraform-provider-gcp]: https://www.terraform.io/docs/providers/google/index.html
[terraform]: https://www.terraform.io/downloads.html
