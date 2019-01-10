# terraform-google-cloud-dns

# Module usage examples

```hcl-terraform
# Example A Record

module "cloud_dns" {
	source                              = "../../"
	region 								= "us-central1"
	project_id 							= "${var.project_id}"
	name                                = "TEST"
	# DNS Zone
	enable_dns_managed_zone             = true
	description                         = "cft.example.net"
	dns_name                            = "cft.example.net."
	# DNS record
	enable_dns_record_set               = true
	managed_zone                        = "test-stage"
	rrdatas                             = ["8.8.8.8"]
}

# Example CNAME Record

module "cloud_dns_cname" {
	source                              = "../../"
	region 								= "us-central1"
	project_id 							= "${var.project_id}"
	name                                = "cname-record"
	# DNS Zone
	enable_dns_managed_zone             = false
	dns_name                            = "cft.example.net."
	# DNS record
	enable_dns_record_set               = true
	type								= "CNAME"
	managed_zone                        = "${module.cloud_dns_zone.google_dns_managed_zone_name}"
	rrdatas                             = ["www.google.com."]
}


```


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| description | A textual description field. Defaults to 'Managed by Terraform'. | string | `` | no |
| dns\_name | The fully qualified DNS name of this zone, e.g. terraform.io.. | string | `` | no |
| enable\_dns\_managed\_zone | Enable DNS managed zone | string | `true` | no |
| enable\_dns\_record\_set | Enable DNS record set | string | `true` | no |
| environment | Environment for service | string | `STAGE` | no |
| managed\_zone | The name of the zone in which this record set will reside. | string | `` | no |
| name | A unique name for the resource, required by GCE. Changing this forces a new resource to be created. | string | `TEST` | no |
| orchestration | Type of orchestration | string | `Terraform` | no |
| project\_id | The project ID to deploy to | string | - | yes |
| region | The region to deploy to | string | - | yes |
| rrdatas | The string data for the records in this record set whose meaning depends on the DNS type. For TXT record, if the string data contains spaces, add surrounding " if you don't want your string to get split on spaces. | list | `<list>` | no |
| ttl | The time-to-live of this record set (seconds). | string | `300` | no |
| type | The DNS record set type (Ex: A, CNAME, MX, TXT) | string | `A` | no |


## Outputs

| Name | Description |
|------|-------------|
| google\_dns\_managed\_zone\_id | ID |
| google\_dns\_managed\_zone\_name | Name of google dns managed zone |
| google\_dns\_managed\_zone\_name\_servers | The list of nameservers that will be authoritative for this domain. Use NS records to redirect from your DNS provider to these names, thus making Google Cloud DNS authoritative for this zone. |
| google\_dns\_record\_set\_id | ID |
| google\_dns\_record\_set\_name | Name |