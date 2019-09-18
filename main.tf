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

locals {
  is_static_zone = var.type == "public" || var.type == "private"
}

resource "google_dns_managed_zone" "peering" {
  count       = var.type == "peering" ? 1 : 0
  provider    = google-beta
  project     = var.project_id
  name        = var.name
  dns_name    = var.domain
  description = "Terraform-managed zone."
  visibility  = "private"

  private_visibility_config {
    dynamic "networks" {
      for_each = var.private_visibility_config_networks
      content {
        network_url = networks.value
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
  count       = var.type == "forwarding" ? 1 : 0
  provider    = google-beta
  project     = var.project_id
  name        = var.name
  dns_name    = var.domain
  description = "Terraform-managed zone."
  visibility  = "private"

  private_visibility_config {
    dynamic "networks" {
      for_each = var.private_visibility_config_networks
      content {
        network_url = networks.value
      }
    }
  }

  forwarding_config {
    dynamic "target_name_servers" {
      for_each = var.target_name_server_addresses
      content {
        ipv4_address = target_name_servers.value
      }
    }
  }
}

resource "google_dns_managed_zone" "private" {
  count       = var.type == "private" ? 1 : 0
  project     = var.project_id
  name        = var.name
  dns_name    = var.domain
  description = "Terraform-managed zone."
  visibility  = "private"

  private_visibility_config {
    dynamic "networks" {
      for_each = var.private_visibility_config_networks
      content {
        network_url = networks.value
      }
    }
  }
}

resource "google_dns_managed_zone" "public" {
  count       = var.type == "public" ? 1 : 0
  project     = var.project_id
  name        = var.name
  dns_name    = var.domain
  description = "Terraform-managed zone."
  visibility  = "public"
}

resource "google_dns_record_set" "cloud-static-records" {
  count        = local.is_static_zone ? length(var.record_names) : 0
  project      = var.project_id
  managed_zone = var.name
  name         = "${element(var.record_names, count.index)}.${var.domain}"
  type         = var.record_data[count.index]["type"]
  ttl          = lookup(var.record_data[count.index], "ttl", 300)

  rrdatas = split(",", var.record_data[count.index]["rrdatas"])

  depends_on = [
    google_dns_managed_zone.private,
    google_dns_managed_zone.public,
  ]
}
