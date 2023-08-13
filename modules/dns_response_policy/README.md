# gcp_dns_response_policy

This module is used to create DNS response policy and rules to the corresponding response policy.

Cloud DNS private zones let you create a single response policy per network that modifies resolver behavior according to the policy created.

You can create multiple rules within one response policy with following behaviors:

- **Default / Unspecified**: Alter results for selected query names (including wildcards) by providing specific resource records.
- **Bypass**: Trigger [passthru](https://datatracker.ietf.org/doc/id/draft-vixie-dnsop-dns-rpz-00.html#rfc.section.3.3) behavior that bypasses the response policy, exempting names that would otherwise match.

Reference: https://cloud.google.com/dns/docs/zones/manage-response-policies

## Usage

Basic usage of this module for a DNS response policy is as follows:

```hcl
module "dns_response_policy" {
  source             = "terraform-google-modules/cloud-dns/google//modules/dns_response_policy"
  project_id         = "example-project-id"
  policy_name        = "example-policy-name"
  network_self_links = ["projects/example-project-id/global/networks/default"]
  description        = "Example DNS response policy created by terraform module."
  rules = {
    "override-google-com" = {
      dns_name = "*.google.com."
      rule_local_datas = {
        "A" = { # Record type.
          rrdatas = ["192.0.2.91"]
          ttl     = 300
        },
        "AAAA" = {
          rrdatas = ["2001:db8::8bd:1002"]
          ttl     = 300
        }
      }
    },
    "override-withgoogle-com" = {
      dns_name = "withgoogle.com."
      rule_local_datas = {
        "A" = {
          rrdatas = ["193.0.2.93"]
          ttl     = 300
        }
      }
    },
    "bypass-google-account-domain" = {
      dns_name      = "account.google.com."
      rule_behavior = "bypassResponsePolicy"
    }
  }
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| description | The description of the response policy. | `string` | n/a | yes |
| network\_self\_links | The self links of the network to which the dns response policy needs to be applied. Note that only one response policy can be applied on a network. | `list(string)` | `[]` | no |
| policy\_name | Name of the DNS response policy. | `string` | n/a | yes |
| project\_id | The ID of the project in which the DNS response policy needs to be created. | `string` | n/a | yes |
| rules | A Response Policy Rule is a selector that applies its behavior to queries that match the selector.<br>  Selectors are DNS names, which may be wildcards or exact matches.<br>  Takes a map as input where the key is the name of the rule. The map contains following attributes:<br>  Key - Name of the rule<br>  Value - Object of following attributes:<br>    * dns\_name - DNS name where policy will be applied.<br>    * rule\_behavior - Whether to override or passthru. Use value bypassResponsePolicy for passthru rules and skip this key for overriding rules.<br>    * rule\_local\_datas - When the rule behavior is override, policy will answer this matched DNS name directly with this DNS data. These resource record sets override any other DNS behavior for the matched name.<br>      * Each local datas object can contain following attributes:<br>        Key - One of the valid DNS resource type.<br>        Value - Object of following attributes:<br>           - ttl -  Number of seconds that this ResourceRecordSet can be cached by resolvers.<br>           - rrdatas - As defined in RFC 1035 (section 5) and RFC 1034 (section 3.6.1) | <pre>map(object({<br>    dns_name      = string<br>    rule_behavior = optional(string)<br>    rule_local_datas = optional(map(object({<br>      ttl     = string<br>      rrdatas = list(string)<br>    })))<br>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| response\_policy\_id | An identifier for the resource with format projects/{{project}}/responsePolicies/{{response\_policy\_name}}. |
| response\_policy\_rule\_ids | List of response rules with format projects/{{project}}/responsePolicies/{{response\_policy}}/rules/{{rule\_name}}. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google-beta"></a> [google-beta](#provider\_google-beta) | ~> 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google-beta_google_dns_response_policy.this](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_dns_response_policy) | resource |
| [google-beta_google_dns_response_policy_rule.this](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_dns_response_policy_rule) | resource |
