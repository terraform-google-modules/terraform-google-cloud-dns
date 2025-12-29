# Terraform Google Cloud DNS Module

This module makes it easy to create Google Cloud DNS zones of different types, and manage their records. It supports creating public, private, forwarding, peering, reverse_lookup and service directory zones.

The resources/services/activations/deletions that this module will create/trigger are:

- One `google_dns_managed_zone` for the zone
- Zero or more `google_dns_record_set` for the zone records

## Compatibility
This module is meant for use with Terraform 0.13+ and tested using Terraform 1.0+. If you find incompatibilities using Terraform >=0.13, please open an issue.
 If you haven't
[upgraded](https://www.terraform.io/upgrade-guides/0-13.html) and need a Terraform
0.12.x-compatible version of this module, the last released version
intended for Terraform 0.12.x is [v3.1.0](https://registry.terraform.io/modules/terraform-google-modules/-cloud-dns/google/v3.1.0).

## Usage

Basic usage of this module for a private zone is as follows:

```hcl
module "dns-private-zone" {
  source  = "terraform-google-modules/cloud-dns/google"
  version = "4.0"
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

## Routing Policies

This module supports multiple routing policies for DNS records:

### Weighted Round Robin (WRR)
Distributes traffic across multiple resources based on assigned weights.

```hcl
recordsets = [
  {
    name    = "www"
    type    = "A"
    ttl     = 300
    records = null
    routing_policy = {
      wrr = [
        {
          weight  = 0.7
          records = ["192.168.1.1"]
        },
        {
          weight  = 0.3
          records = ["192.168.1.2"]
        }
      ]
      geo = []
    }
  }
]
```

### Geolocation (GEO)
Routes traffic based on the geographic location of the query source.

```hcl
recordsets = [
  {
    name    = "www"
    type    = "A"
    ttl     = 300
    records = null
    routing_policy = {
      wrr = []
      geo = [
        {
          location = "us-east1"
          records  = ["10.1.0.1"]
        },
        {
          location = "europe-west1"
          records  = ["10.2.0.1"]
        }
      ]
    }
  }
]
```

### Primary Backup (Failover)
Defines primary resources with automatic failover to backup resources based on health checks.

```hcl
recordsets = [
  {
    name    = "api"
    type    = "A"
    ttl     = 300
    records = null
    routing_policy = {
      wrr                = []
      geo                = []
      enable_geo_fencing = false
      health_check       = "https://www.googleapis.com/compute/v1/projects/PROJECT_ID/global/healthChecks/my-health-check"
      
      primary_backup = {
        enable_geo_fencing_for_backups = false
        trickle_ratio                  = 0.1
        
        primary = {
          internal_load_balancers = []
          external_endpoints      = ["10.0.0.1", "10.0.0.2"]
        }
        
        backup_geo = [
          {
            location               = "us-east1"
            rrdatas                = []
            health_checked_targets = {
              internal_load_balancers = []
              external_endpoints      = ["10.1.0.1"]
            }
          }
        ]
      }
    }
  }
]
```

**Primary Backup Parameters:**
- `enable_geo_fencing` (bool): Enables geo-fencing for the routing policy (root level)
- `enable_geo_fencing_for_backups` (bool): Restricts backups to specific geographic locations
- `trickle_ratio` (number): Percentage of traffic sent to backups during failover (0.0 to 1.0)
- `primary` (object): Primary resources configuration
  - `internal_load_balancers`: List of internal load balancers (regionalL4ilb, regionalL7ilb, globalL7ilb)
  - `external_endpoints`: List of external IPs
- `backup_geo` (list): List of geographic backups
  - `location`: GCP region (e.g., us-east1, europe-west1)
  - `rrdatas`: Static IPs (for backups without health check)
  - `health_checked_targets`: Targets with health monitoring
- `health_check` (string): URL of the health check resource (root level)

See the [primary_backup_routing example](./examples/primary_backup_routing/) for a complete implementation.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| default\_key\_specs\_key | Object containing default key signing specifications : algorithm, key\_length, key\_type, kind. Please see https://www.terraform.io/docs/providers/google/r/dns_managed_zone#dnssec_config for futhers details | `any` | `{}` | no |
| default\_key\_specs\_zone | Object containing default zone signing specifications : algorithm, key\_length, key\_type, kind. Please see https://www.terraform.io/docs/providers/google/r/dns_managed_zone#dnssec_config for futhers details | `any` | `{}` | no |
| description | zone description (shown in console) | `string` | `"Managed by Terraform"` | no |
| dnssec\_config | Object containing : kind, non\_existence, state. Please see https://www.terraform.io/docs/providers/google/r/dns_managed_zone#dnssec_config for futhers details | `any` | `{}` | no |
| domain | Zone domain, must end with a period. | `string` | n/a | yes |
| enable\_logging | Enable query logging for this ManagedZone | `bool` | `false` | no |
| force\_destroy | Set this true to delete all records in the zone. | `bool` | `false` | no |
| labels | A set of key/value label pairs to assign to this ManagedZone | `map(any)` | `{}` | no |
| name | Zone name, must be unique within the project. | `string` | n/a | yes |
| private\_visibility\_config\_networks | List of VPC self links that can see this zone. | `list(string)` | `[]` | no |
| project\_id | Project id for the zone. | `string` | n/a | yes |
| recordsets | List of DNS record objects to manage, in the standard terraform dns structure. Supports simple records and advanced routing policies (WRR, GEO, Primary Backup). | <pre>list(object({<br>    name    = string<br>    type    = string<br>    ttl     = number<br>    records = optional(list(string), null)<br><br>    routing_policy = optional(object({<br>      wrr = optional(list(object({<br>        weight  = number<br>        records = list(string)<br>      })), [])<br>      geo = optional(list(object({<br>        location = string<br>        records  = list(string)<br>      })), [])<br>      enable_geo_fencing = optional(bool, false)<br>      health_check       = optional(string)<br>      primary_backup = optional(object({<br>        enable_geo_fencing_for_backups = optional(bool, false)<br>        primary = object({<br>          internal_load_balancers = optional(list(object({<br>            load_balancer_type = string<br>            ip_address         = string<br>            port               = string<br>            ip_protocol        = string<br>            network_url        = string<br>            project            = string<br>            region             = optional(string)<br>          })), [])<br>          external_endpoints = optional(list(string), [])<br>        })<br>        backup_geo = list(object({<br>          location = string<br>          rrdatas  = optional(list(string), [])<br>          health_checked_targets = optional(object({<br>            internal_load_balancers = optional(list(object({<br>              load_balancer_type = string<br>              ip_address         = string<br>              port               = string<br>              ip_protocol        = string<br>              network_url        = string<br>              project            = string<br>              region             = optional(string)<br>            })), [])<br>            external_endpoints = optional(list(string), [])<br>          }))<br>        }))<br>        trickle_ratio = optional(number, 0.0)<br>      }))<br>    }))<br>  }))</pre> | `[]` | no |
| service\_namespace\_url | The fully qualified or partial URL of the service directory namespace that should be associated with the zone. This should be formatted like https://servicedirectory.googleapis.com/v1/projects/{project}/locations/{location}/namespaces/{namespace_id} or simply projects/{project}/locations/{location}/namespaces/{namespace\_id}. | `string` | `""` | no |
| target\_name\_server\_addresses | List of target name servers for forwarding zone. | `list(map(any))` | `[]` | no |
| target\_network | Peering network. | `string` | `""` | no |
| type | Type of zone to create, valid values are 'public', 'private', 'forwarding', 'peering', 'reverse\_lookup' and 'service\_directory'. | `string` | `"private"` | no |

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

- [Terraform](https://www.terraform.io/downloads.html) >= 0.13.0
- [Terraform Provider for GCP][terraform-provider-gcp] plugin >= v4.40

### Service Account

User or service account credentials with the following roles must be used to provision the resources of this module:

- DNS Administrator: `roles/dns.admin`

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
