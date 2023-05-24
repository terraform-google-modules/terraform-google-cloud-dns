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


output "project_id" {
  description = "Name of the DNS response policy."
  value       = var.project_id
}

output "policy_name" {
  description = "Name of the DNS response policy."
  value       = var.policy_name
}

output "response_policy_rule_names" {
  description = "List of response rules with format projects/{{project}}/responsePolicies/{{response_policy}}/rules/{{rule_name}}."
  value       = [for rule_name in module.example_response_policy.response_policy_rule_ids : reverse(split("/", rule_name))[0]]
}
