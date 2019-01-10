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


resource "google_dns_managed_zone" "dns_managed_zone" {
  count       = "${var.enable_dns_managed_zone && length(var.dns_name) >0 && length(var.description) >0 ? 1 : 0}"

  name        = "${lower(var.name)}-${lower(var.environment)}"
  description = "${var.description}"
  project     = "${var.project_id}"
  dns_name    = "${var.dns_name}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_dns_record_set" "dns_record_set" {
  count           = "${var.enable_dns_record_set && length(var.type) >0 && length(var.managed_zone) >0 && length(var.rrdatas) >0 ? 1 : 0}"

  name            = "${lower(var.name)}.${lower(var.dns_name)}"
  project         = "${var.project_id}"
  type            = "${var.type}"
  ttl             = "${var.ttl}"

  managed_zone    = "${var.managed_zone}"

  rrdatas         = ["${var.rrdatas}"]

  lifecycle {
    create_before_destroy = true
  }

  depends_on = ["google_dns_managed_zone.dns_managed_zone"]
}
