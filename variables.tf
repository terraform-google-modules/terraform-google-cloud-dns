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
  description = "Project id for the zone."
  type        = "string"
}

variable "name" {
  description = "Zone name, must be unique within the project."
  type        = "string"
}

variable "domain" {
  description = "Zone domain, must end with a period."
  type        = "string"
}

variable "private_visibility_config" {
  description = "List of private visibility config maps, not used for public zones."
  default     = []
}

variable "target_network" {
  description = "Peering network."
  default     = ""
}

variable "target_name_servers" {
  description = "List of target name servers for forwarding zone."
  default     = []
}

variable "record_names" {
  description = "List of record names for static zones."
  default     = []
}

variable "record_data" {
  description = "List of maps with type, rrdatas and optional ttl for static zone records."
  default     = []
}

variable "zone_type" {
  description = "Type of zone to create, valid values are 'public', 'private', 'forwarding', 'peering'."
  default     = "private"
}
