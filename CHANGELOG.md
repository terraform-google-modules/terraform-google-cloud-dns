# Changelog

All notable changes to this project will be documented in this file.

The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [3.0.2] - 2020-06-01

### Fixed

- Ensured description is properly passed through to zones.

## [3.0.1] - 2020-03-04

### Fixed

- Fix item lookup in dynamic dnssec block. [#6]

## [3.0.0] - 2019-10-24

### Added

- DNSSEC support. [#4]

### Changed

- **BREAKING**  The `record_names` and `record_data` variables have been combined into `recordsets`, and have switched to using `for_each`. Upgrading instructions are in the [v3.0 migration guide](docs/upgrading_to_v3.0.md). [#4]

## [2.0.0] - 2019-08-18

### Changed

- Updated for Terraform 0.12. [#3]
- **BREAKING** the `zone_type` variable has been renamed to `type` for uniformity with the `name` and `domain` variables
- **BREAKING** list/map variables now leverage 0.12 constructs internally, and have been simplified and renamed accordingly:
  - `private_visibility_config` has been renamed to `private_visibility_config_networks` and is now a simple list of VPC self links
  - `target_name_servers` has been renamed to `target_name_server_addresses` and is now a simple list of addresses


## [1.0.0] - 2019-06-17

### Added

- Initial release. [#2]

[3.0.2]: https://github.com/terraform-google-modules/terraform-google-cloud-dns/compare/v3.0.1...v3.0.2
[3.0.1]: https://github.com/terraform-google-modules/terraform-google-cloud-dns/compare/v3.0.0...v3.0.1
[3.0.0]: https://github.com/terraform-google-modules/terraform-google-cloud-dns/compare/v2.0.0...v3.0.0
[2.0.0]: https://github.com/terraform-google-modules/terraform-google-cloud-dns/compare/v1.0.0...v2.0.0
[2.0.0]: https://github.com/terraform-google-modules/terraform-google-cloud-dns/compare/v1.0.0...v2.0.0
[1.0.0]: https://github.com/terraform-google-modules/terraform-google-cloud-dns/releases/tag/v1.0.0

[#6]: https://github.com/terraform-google-modules/terraform-google-cloud-dns/pull/6
[#4]: https://github.com/terraform-google-modules/terraform-google-cloud-dns/pull/4
[#3]: https://github.com/terraform-google-modules/terraform-google-cloud-dns/pull/3
[#2]: https://github.com/terraform-google-modules/terraform-google-cloud-dns/pull/2
