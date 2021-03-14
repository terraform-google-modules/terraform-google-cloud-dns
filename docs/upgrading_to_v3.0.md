# Upgrading to v3.0

The v5.0 release of *cloud-dns* is a backwards incompatible
release in respect to DNS records.

## Migration Instructions

The number and format of the variables used for specifying DNS records has changed since v3.0. The old format used two list variables, one for record names and one for record data, as in this example for a single `A` record:

```hcl
record_names = ["localhost"]
record_data = [
  {
    rrdatas = "127.0.0.1"
    type    = "A"
  }
]
```

Starting from v3.0, records are specified using a single variable with a clearly defined type. This is the example above, migrated to the new syntax:

```hcl
recordsets = [
  {
    name    = "localhost"
    type    = "A"
    ttl     = 300
    records = [
      "127.0.0.1",
    ]
  },
]
```

The `recordsets` variable is a single list of objects each corresponding to one DNS record, where the `name` key corresponds to the value that used to be in the `record_names` variable, and the `type` and `records` keys map to the values that used to be in the `record_data` variables.

There's no simple way of migrating record resources from the old to the new format, so once you upgrade the module to the new version and combine record attributes in the new `recordsets` attribute, all existing records will be dropped and recreated once you run `terraform apply`.
