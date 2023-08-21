// Copyright 2023 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package dnsResponsePolicyTest

import (
	"fmt"
	"testing"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/gcloud"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/stretchr/testify/assert"
)

func TestDNSResponsePolicy(t *testing.T) {
	drp := tft.NewTFBlueprintTest(t)
	drp.DefineVerify(
		func(assert *assert.Assertions) {
			drp.DefaultVerify(assert)
			projectID := drp.GetStringOutput("project_id")
			gcOpts := gcloud.WithCommonArgs([]string{"--project", projectID, "--format", "json"})

			policyName := gcloud.Run(t, "dns response-policies list", gcOpts).Array()[0].Get("responsePolicyName").String()
			assert.Equal(policyName, "dns-response-policy-test", "Test DNS response policy is created")
			policyRules := gcloud.Run(t, fmt.Sprintf("dns response-policies rules list %s", policyName), gcOpts).Array()
			assert.Equal(3, len(policyRules), "3 response policy rules are created.")
			validRules := []string{"override-withgoogle-com", "bypass-google-account-domain", "override-google-com"}
			for _, rule := range policyRules {
				assert.Contains(validRules, rule.Get("ruleName").String(), "Rules are created with correct names")
			}
		})
	drp.Test()
}
