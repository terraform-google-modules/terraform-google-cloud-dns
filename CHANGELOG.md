# Changelog

All notable changes to this project will be documented in this file.

The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2019-08-18

### Changed

- Updated for Terraform 0.12. [#2]
- **BREAKING** the `zone_type` variable has been renamed to `type` for uniformity with the `name` and `domain` variables
- **BREAKING** list/map variables now leverage 0.12 constructs internally, and have been simplified and renamed accordingly:
  - `private_visibility_config` has been renamed to `private_visibility_config_networks` and is now a simple list of VPC self links
  - `target_name_servers` has been renamed to `target_name_server_addresses` and is now a simple list of addresses


## [1.0.0] - 2019-06-17

### Added

- Initial release. [#2]
