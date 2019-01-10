# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.




title 'Cloud DNS Terraform GCP Test Suite'

gcp_project_id = attribute('gcp_project_id')

control 'spinnaker-vm' do
  impact 1.0
  title 'Test Cloud DNS Zone was created'
  describe google_dns_managed_zones(project: gcp_project_id) do
    its('zone_names') { should include "test-stage" }
  end
end