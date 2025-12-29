/**
 * Copyright 2018 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

resource "google_dns_managed_zone" "peering" {
  count         = var.type == "peering" ? 1 : 0
  project       = var.project_id
  name          = var.name
  dns_name      = var.domain
  description   = var.description
  labels        = var.labels
  visibility    = "private"
  force_destroy = var.force_destroy

  dynamic "private_visibility_config" {
    for_each = length(var.private_visibility_config_networks) > 0 ? [1] : []
    content {
      dynamic "networks" {
        for_each = var.private_visibility_config_networks
        content {
          network_url = networks.value
        }
      }
    }
  }

  peering_config {
    target_network {
      network_url = var.target_network
    }
  }
}

resource "google_dns_managed_zone" "forwarding" {
  count         = var.type == "forwarding" ? 1 : 0
  project       = var.project_id
  name          = var.name
  dns_name      = var.domain
  description   = var.description
  labels        = var.labels
  visibility    = "private"
  force_destroy = var.force_destroy

  dynamic "private_visibility_config" {
    for_each = length(var.private_visibility_config_networks) > 0 ? [1] : []
    content {
      dynamic "networks" {
        for_each = var.private_visibility_config_networks
        content {
          network_url = networks.value
        }
      }
    }
  }

  forwarding_config {
    dynamic "target_name_servers" {
      for_each = var.target_name_server_addresses
      content {
        ipv4_address    = target_name_servers.value.ipv4_address
        forwarding_path = lookup(target_name_servers.value, "forwarding_path", "default")
      }
    }
  }
}

resource "google_dns_managed_zone" "private" {
  count         = var.type == "private" ? 1 : 0
  project       = var.project_id
  name          = var.name
  dns_name      = var.domain
  description   = var.description
  labels        = var.labels
  visibility    = "private"
  force_destroy = var.force_destroy

  dynamic "private_visibility_config" {
    for_each = length(var.private_visibility_config_networks) > 0 ? [1] : []
    content {
      dynamic "networks" {
        for_each = var.private_visibility_config_networks
        content {
          network_url = networks.value
        }
      }
    }
  }
}

resource "google_dns_managed_zone" "public" {
  count         = var.type == "public" ? 1 : 0
  project       = var.project_id
  name          = var.name
  dns_name      = var.domain
  description   = var.description
  labels        = var.labels
  visibility    = "public"
  force_destroy = var.force_destroy

  dynamic "dnssec_config" {
    for_each = length(var.dnssec_config) == 0 ? [] : [var.dnssec_config]
    iterator = config
    content {
      kind          = lookup(config.value, "kind", "dns#managedZoneDnsSecConfig")
      non_existence = lookup(config.value, "non_existence", "nsec3")
      state         = lookup(config.value, "state", "off")

      default_key_specs {
        algorithm  = lookup(var.default_key_specs_key, "algorithm", "rsasha256")
        key_length = lookup(var.default_key_specs_key, "key_length", 2048)
        key_type   = lookup(var.default_key_specs_key, "key_type", "keySigning")
        kind       = lookup(var.default_key_specs_key, "kind", "dns#dnsKeySpec")
      }
      default_key_specs {
        algorithm  = lookup(var.default_key_specs_zone, "algorithm", "rsasha256")
        key_length = lookup(var.default_key_specs_zone, "key_length", 1024)
        key_type   = lookup(var.default_key_specs_zone, "key_type", "zoneSigning")
        kind       = lookup(var.default_key_specs_zone, "kind", "dns#dnsKeySpec")
      }
    }
  }

  cloud_logging_config {
    enable_logging = var.enable_logging
  }
}

# "reverse_lookup" is only available in google-beta
resource "google_dns_managed_zone" "reverse_lookup" {
  count          = var.type == "reverse_lookup" ? 1 : 0
  provider       = google-beta
  project        = var.project_id
  name           = var.name
  dns_name       = var.domain
  description    = var.description
  labels         = var.labels
  visibility     = "private"
  force_destroy  = var.force_destroy
  reverse_lookup = true

  dynamic "private_visibility_config" {
    for_each = length(var.private_visibility_config_networks) > 0 ? [1] : []
    content {
      dynamic "networks" {
        for_each = var.private_visibility_config_networks
        content {
          network_url = networks.value
        }
      }
    }
  }
}

# "service_directory_config" is only available in google-beta
resource "google_dns_managed_zone" "service_directory" {
  count         = var.type == "service_directory" ? 1 : 0
  provider      = google-beta
  project       = var.project_id
  name          = var.name
  dns_name      = var.domain
  description   = var.description
  labels        = var.labels
  visibility    = "private"
  force_destroy = var.force_destroy

  private_visibility_config {
    dynamic "networks" {
      for_each = var.private_visibility_config_networks
      content {
        network_url = networks.value
      }
    }
  }

  service_directory_config {
    namespace {
      namespace_url = var.service_namespace_url
    }
  }
}

resource "google_dns_record_set" "cloud-static-records" {
  project      = var.project_id
  managed_zone = var.name

  for_each = { for record in var.recordsets : join("/", [record.name, record.type]) => record }
  name = (
    each.value.name != "" ?
    "${each.value.name}.${var.domain}" :
    var.domain
  )
  type = each.value.type
  ttl  = each.value.ttl

  rrdatas = each.value.records

  dynamic "routing_policy" {
    for_each = toset(each.value.routing_policy != null ? ["create"] : [])
    content {
      enable_geo_fencing = each.value.routing_policy.enable_geo_fencing
      health_check       = each.value.routing_policy.health_check

      dynamic "wrr" {
        for_each = each.value.routing_policy.wrr
        iterator = wrr
        content {
          weight  = wrr.value.weight
          rrdatas = wrr.value.records
        }
      }

      dynamic "geo" {
        for_each = each.value.routing_policy.geo
        iterator = geo
        content {
          location = geo.value.location
          rrdatas  = geo.value.records
        }
      }

      dynamic "primary_backup" {
        for_each = each.value.routing_policy.primary_backup != null ? [each.value.routing_policy.primary_backup] : []
        content {
          enable_geo_fencing_for_backups = primary_backup.value.enable_geo_fencing_for_backups
          trickle_ratio                  = primary_backup.value.trickle_ratio

          primary {
            dynamic "internal_load_balancers" {
              for_each = primary_backup.value.primary.internal_load_balancers
              content {
                load_balancer_type = internal_load_balancers.value.load_balancer_type
                ip_address         = internal_load_balancers.value.ip_address
                port               = internal_load_balancers.value.port
                ip_protocol        = internal_load_balancers.value.ip_protocol
                network_url        = internal_load_balancers.value.network_url
                project            = internal_load_balancers.value.project
                region             = internal_load_balancers.value.region
              }
            }
            external_endpoints = primary_backup.value.primary.external_endpoints
          }

          dynamic "backup_geo" {
            for_each = primary_backup.value.backup_geo
            content {
              location = backup_geo.value.location
              rrdatas  = backup_geo.value.rrdatas

              dynamic "health_checked_targets" {
                for_each = backup_geo.value.health_checked_targets != null ? [backup_geo.value.health_checked_targets] : []
                content {
                  dynamic "internal_load_balancers" {
                    for_each = health_checked_targets.value.internal_load_balancers
                    content {
                      load_balancer_type = internal_load_balancers.value.load_balancer_type
                      ip_address         = internal_load_balancers.value.ip_address
                      port               = internal_load_balancers.value.port
                      ip_protocol        = internal_load_balancers.value.ip_protocol
                      network_url        = internal_load_balancers.value.network_url
                      project            = internal_load_balancers.value.project
                      region             = internal_load_balancers.value.region
                    }
                  }
                  external_endpoints = health_checked_targets.value.external_endpoints
                }
              }
            }
          }
        }
      }
    }
  }

  depends_on = [
    google_dns_managed_zone.private,
    google_dns_managed_zone.public,
  ]
}
