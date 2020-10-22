# Terraform Google Cloud DNS Module

This module makes it easy to create Google Cloud DNS zones of different types, and manage their records. It supports creating public, private, forwarding, and peering zones.

The resources/services/activations/deletions that this module will create/trigger are:

- One `google_dns_managed_zone` for the zone
- Zero or more `google_dns_record_set` for the zone records

## Compatibility

 This module is meant for use with Terraform 0.12. If you haven't [upgraded](https://www.terraform.io/upgrade-guides/0-12.html) and need a Terraform 0.12.x-compatible version of this module, the last released version intended for Terraform 0.11.x is [1.0.0](https://registry.terraform.io/modules/terraform-google-modules/cloud-dns/google/1.0.0).

## Usage

Basic usage of this module for a private zone is as follows:

```hcl
module "dns-private-zone" {
  source  = "terraform-google-modules/cloud-dns/google"
  version = "3.0.0"
  project_id = "my-project"
  type       = "private"
  name       = "example-com"
  domain     = "example.com."

  private_visibility_config_networks = [
    "https://www.googleapis.com/compute/v1/projects/my-project/global/networks/my-vpc"
  ]

  recordsets = [
    {
      name    = ""
      type    = "NS"
      ttl     = 300
      records = [
        "127.0.0.1",
      ]
    },
    {
      name    = "localhost"
      type    = "A"
      ttl     = 300
      records = [
        "127.0.0.1",
      ]
    },
  ]
}

```

Functional examples are included in the [examples](./examples/) directory.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| default\_key\_specs\_key | Object containing default key signing specifications : algorithm, key_length, key_type, kind. Please see https://www.terraform.io/docs/providers/google/r/dns_managed_zone.html#dnssec_config for futhers details | any | `<map>` | no |
| default\_key\_specs\_zone | Object containing default zone signing specifications : algorithm, key_length, key_type, kind. Please see https://www.terraform.io/docs/providers/google/r/dns_managed_zone.html#dnssec_config for futhers details | any | `<map>` | no |
| description | zone description (shown in console) | string | `"Managed by Terraform"` | no |
| dnssec\_config | Object containing : kind, non_existence, state. Please see https://www.terraform.io/docs/providers/google/r/dns_managed_zone.html#dnssec_config for futhers details | any | `<map>` | no |
| domain | Zone domain, must end with a period. | string | n/a | yes |
| labels | A set of key/value label pairs to assign to this ManagedZone | map | `<map>` | no |
| name | Zone name, must be unique within the project. | string | n/a | yes |
| private\_visibility\_config\_networks | List of VPC self links that can see this zone. | list(string) | `<list>` | no |
| project\_id | Project id for the zone. | string | n/a | yes |
| recordsets | List of DNS record objects to manage, in the standard terraform dns structure. | object | `<list>` | no |
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
