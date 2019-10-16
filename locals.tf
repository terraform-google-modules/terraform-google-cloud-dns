locals {
  dnssec_config = merge({}, var.dnssec_config)
}

locals {
  default_key_specs_key = merge({}, var.default_key_specs_key)
}

locals {
  default_key_specs_zone = merge({}, var.default_key_specs_zone)
}
