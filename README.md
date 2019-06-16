# Terraform Google Cloud DNS Module

This module makes it easy to create Google Cloud DNS zones of different types, and manage their records. It supports creating public, private, forwarding, and peering zones.

The resources/services/activations/deletions that this module will create/trigger are:

- One `google_dns_managed_zone` for the zone
- Zero or more `google_dns_record_set` for the zone records

## Usage

Basic usage of this module for a private zone is as follows:

```hcl
module "dns-zone-foo" {
  source     = "terraform-google-modules/cloud-dns/google"
  version    = "~> 0.1"
  project_id = "my-project"
  zone_type  = "private"
  name       = "Foo zone."
  dns_name   = "foo.local."
  private_visibility_config = [{
    networks = [{
      network_url = "my-vpc"
    }]
  }]
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

[^]: (autogen_docs_start)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| dns\_name | Zone DNS name. | string | n/a | yes |
| name | Zone name. | string | n/a | yes |
| private\_visibility\_config | List of private visibility config maps, not used for public zones. | list | `<list>` | no |
| project\_id | Project id for the zone. | string | n/a | yes |
| record\_data | List of maps with type, rrdatas and optional ttl for static zone records. | list | `<list>` | no |
| record\_names | List of record names for static zones. | list | `<list>` | no |
| target\_name\_servers | List of target name servers for forwarding zone. | list | `<list>` | no |
| target\_network | Peering network. | string | `""` | no |
| zone\_type | Type of zone to create, valid values are 'public', 'private', 'forwarding', 'peering'. | string | `"private"` | no |

## Outputs

| Name | Description |
|------|-------------|
| domain | The DNS zone domain. |
| name | The DNS zone name. |
| name\_servers | The DNS zone name servers. |
| zone\_type | The DNS zone type. |

[^]: (autogen_docs_end)

## Requirements

These sections describe requirements for using this module.

### Software

The following dependencies must be available:

- [Terraform][terraform] v0.11
- [Terraform Provider for GCP][terraform-provider-gcp] plugin v2.0

### Service Account

User or service account credentials with the following roles must be used to provision the resources of this module:

- Storage Admin: `roles/storage.admin`

The [Project Factory module][project-factory-module] and the
[IAM module][iam-module] may be used in combination to provision a
service account with the necessary roles applied.

### APIs

A project with the following APIs enabled must be used to host the
resources of this module:

- Google Cloud Storage JSON API: `storage-api.googleapis.com`

The [Project Factory module][project-factory-module] can be used to
provision a project with the necessary APIs enabled.

## Contributing

Refer to the [contribution guidelines](./CONTRIBUTING.md) for
information on contributing to this module.

[iam-module]: https://registry.terraform.io/modules/terraform-google-modules/iam/google
[project-factory-module]: https://registry.terraform.io/modules/terraform-google-modules/project-factory/google
[terraform-provider-gcp]: https://www.terraform.io/docs/providers/google/index.html
[terraform]: https://www.terraform.io/downloads.html
