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

variable "description" {
  type        = string
  description = "The description of the response policy."
}

variable "network_self_links" {
  type        = list(string)
  description = "The self links of the network to which the dns response policy needs to be applied. Note that only one response policy can be applied on a network."
  default     = []
}

variable "rules" {
  type = map(object({
    dns_name      = string
    rule_behavior = optional(string)
    rule_local_datas = optional(map(object({
      ttl     = string
      rrdatas = list(string)
    })))
  }))
  description = <<EOF
  A Response Policy Rule is a selector that applies its behavior to queries that match the selector.
  Selectors are DNS names, which may be wildcards or exact matches.
  Takes a map as input where the key is the name of the rule. The map contains following attributes:
  Key - Name of the rule
  Value - Object of following attributes:
    * dns_name - DNS name where policy will be applied.
    * rule_behavior - Whether to override or passthru. Use value bypassResponsePolicy for passthru rules and skip this key for overriding rules.
    * rule_local_datas - When the rule behavior is override, policy will answer this matched DNS name directly with this DNS data. These resource record sets override any other DNS behavior for the matched name.
      * Each local datas object can contain following attributes:
        Key - One of the valid DNS resource type.
        Value - Object of following attributes:
           - ttl -  Number of seconds that this ResourceRecordSet can be cached by resolvers.
           - rrdatas - As defined in RFC 1035 (section 5) and RFC 1034 (section 3.6.1)
  EOF
}

variable "policy_name" {
  type        = string
  description = "Name of the DNS response policy."
}
