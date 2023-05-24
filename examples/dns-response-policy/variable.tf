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

variable "project_id" {
  type        = string
  description = "The ID of the project in which the DNS response policy needs to be created."
}

variable "network_self_links" {
  type        = list(string)
  description = "The self link of the network to which the dns response policy needs to be applied. Note that only one response policy can be applied on a network."
  default     = []
}

variable "policy_name" {
  type        = string
  description = "Name of the DNS response policy."
}

variable "description" {
  type        = string
  description = "The description of the response policy."
  default     = "Example DNS response policy created by terraform module."
}
