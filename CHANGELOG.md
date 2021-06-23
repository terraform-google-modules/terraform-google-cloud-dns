# Changelog

All notable changes to this project will be documented in this file.

The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [4.0.0](https://www.github.com/terraform-google-modules/terraform-google-cloud-dns/compare/v3.1.0...v4.0.0) (2021-06-23)


### ⚠ BREAKING CHANGES

* `target_name_server_addresses` is now a list of objects, allowing setting `forwarding_path` for each address.
* add Terraform 0.13 constraint and module attribution (#22)

### Features

* add force_destroy variable for zones ([#29](https://www.github.com/terraform-google-modules/terraform-google-cloud-dns/issues/29)) ([8bb8746](https://www.github.com/terraform-google-modules/terraform-google-cloud-dns/commit/8bb8746f1d0bccf70fda7af5a946125abb8f03a1))
* add Terraform 0.13 constraint and module attribution ([#22](https://www.github.com/terraform-google-modules/terraform-google-cloud-dns/issues/22)) ([52cd08a](https://www.github.com/terraform-google-modules/terraform-google-cloud-dns/commit/52cd08aa53bb3123412ca09b4a9bc63e011a2393))
* allow setting routing path for `target_name_server_addresses` ([#27](https://www.github.com/terraform-google-modules/terraform-google-cloud-dns/issues/27)) ([53955cb](https://www.github.com/terraform-google-modules/terraform-google-cloud-dns/commit/53955cbbe10ac5e499cd59cc1574c7bf05880eeb))


### Bug Fixes

* Remove deprecated `list()` function ([#28](https://www.github.com/terraform-google-modules/terraform-google-cloud-dns/issues/28)) ([7c9cd40](https://www.github.com/terraform-google-modules/terraform-google-cloud-dns/commit/7c9cd40a277db164e73a99b22810198657bb0e6d))

## [3.1.0](https://www.github.com/terraform-google-modules/terraform-google-cloud-dns/compare/v3.0.2...v3.1.0) (2020-11-22)


### Features

* Add support for specifying labels (with var.labels) ([#15](https://www.github.com/terraform-google-modules/terraform-google-cloud-dns/issues/15)) ([70ee8ee](https://www.github.com/terraform-google-modules/terraform-google-cloud-dns/commit/70ee8ee82391b836f6b36b61b29dc0069d454435))

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
