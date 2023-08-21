/**
 * Copyright 2023 Google LLC
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

/**
Cloud DNS private zones let you create a single response policy per network that
modifies resolver behavior according to the policy created.
*/
resource "google_dns_response_policy" "this" {
  project              = var.project_id
  response_policy_name = var.policy_name
  description          = var.description
  dynamic "networks" {
    for_each = var.network_self_links
    content {
      network_url = networks.value
    }
  }
}

/**
Response policy rules can be created under a response policy to alter results for
selected query names or trigger passthru behavior that bypasses the response policy.
*/
resource "google_dns_response_policy_rule" "this" {
  for_each        = toset(keys(var.rules))
  provider        = google-beta
  project         = var.project_id
  rule_name       = each.key
  dns_name        = lookup(var.rules[each.key], "dns_name")
  response_policy = google_dns_response_policy.this.response_policy_name
  behavior        = lookup(var.rules[each.key], "rule_behavior", null)

  dynamic "local_data" {
    for_each = lookup(var.rules[each.key], "rule_behavior", "") == "bypassResponsePolicy" ? [] : [1]
    content {
      dynamic "local_datas" {
        for_each = lookup(var.rules[each.key], "rule_local_datas")
        content {
          name    = lookup(var.rules[each.key], "dns_name")
          rrdatas = local_datas.value.rrdatas
          ttl     = local_datas.value.ttl
          type    = local_datas.key # Only one local data allowed for each type.
        }
      }
    }
  }
}
