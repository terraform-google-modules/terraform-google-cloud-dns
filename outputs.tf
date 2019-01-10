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

output "google_dns_managed_zone_name" {
  description = "Name of google dns managed zone"
  value       = "${google_dns_managed_zone.dns_managed_zone.name}"
}

output "google_dns_managed_zone_name_servers" {
  description = "The list of nameservers that will be authoritative for this domain. Use NS records to redirect from your DNS provider to these names, thus making Google Cloud DNS authoritative for this zone."
  value       = "${google_dns_managed_zone.dns_managed_zone.*.name_servers}"
}

output "google_dns_managed_zone_id" {
  description = "ID"
  value       = "${google_dns_managed_zone.dns_managed_zone.*.id}"
}

output "google_dns_record_set_name" {
  description = "Name"
  value       = "${google_dns_record_set.dns_record_set.*.name}"
}

output "google_dns_record_set_id" {
  description = "ID"
  value       = "${google_dns_record_set.dns_record_set.*.id}"
}

