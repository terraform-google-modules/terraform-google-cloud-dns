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

provider "google" {
  credentials = "${file(var.credentials_path)}"
  region      = "${var.region}"
}

# Example A Record

module "cloud_dns_zone" {
	source                              = "../../"
	region 								= "us-central1"
	project_id 							= "${var.project_id}"
	name                                = "TEST"
	# DNS Zone
	enable_dns_managed_zone             = true
	description                         = "cft.example.net"
	dns_name                            = "cft.example.net."
	# DNS record
	enable_dns_record_set               = false
}

module "cloud_dns_a" {
	source                              = "../../"
	region 								= "us-central1"
	project_id 							= "${var.project_id}"
	name                                = "TEST"
	# DNS Zone
	enable_dns_managed_zone             = false
	dns_name                            = "cft.example.net."
	# DNS record
	enable_dns_record_set               = true
	managed_zone                        = "${module.cloud_dns_zone.google_dns_managed_zone_name}"
	rrdatas                             = ["8.8.8.8"]
}


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
