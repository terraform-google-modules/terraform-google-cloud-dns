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

variable "project_id" {
  description = "The project ID to deploy to"
}

variable "region" {
  description = "The region to deploy to"
}

variable "name" {
  description = "A unique name for the resource, required by GCE. Changing this forces a new resource to be created."
  default     = "TEST"
}

variable "environment" {
  description = "Environment for service"
  default     = "STAGE"
}

variable "orchestration" {
  description = "Type of orchestration"
  default     = "Terraform"
}

variable "enable_dns_managed_zone" {
  description = "Enable DNS managed zone"
  default     = "true"
}

variable "description" {
  description = "A textual description field. Defaults to 'Managed by Terraform'."
  default     = ""
}

variable "dns_name" {
  description = "The fully qualified DNS name of this zone, e.g. terraform.io.."
  default     = ""
}

variable "enable_dns_record_set" {
  description = "Enable DNS record set"
  default     = "true"
}

variable "type" {
  description = "The DNS record set type (Ex: A, CNAME, MX, TXT)"
  default     = "A"
}

variable "ttl" {
  description = "The time-to-live of this record set (seconds)."
  default     = 300
}

variable "managed_zone" {
  description = "The name of the zone in which this record set will reside."
  default     = ""
}

variable "rrdatas" {
  description = "The string data for the records in this record set whose meaning depends on the DNS type. For TXT record, if the string data contains spaces, add surrounding \" if you don't want your string to get split on spaces."
  default     = []
}
