# Copyright 2023 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

control "gcp" do
    title "GCP Resources"

    describe command("gcloud dns response-policies describe #{input('policy_name')} --project=#{input('project_id')}") do
      its(:exit_status) { should eq 0 }
    end

    describe command("gcloud dns response-policies rules list #{input('policy_name')} --project=#{input('project_id')}") do
        let!(:rules) do
            if subject.exit_status == 0
                JSON.parse(subject.stdout)
            else
                {}
            end
        end
        describe "rules are created" do
          it "match one rule name" do
            rule_names = []
            rules.each do |rule|
              rule_names << rule["ruleName"]
            end
            expect(rule_names.sort).to eq(input('response_policy_rule_names').sort)
          end
        end
    end
end
