# The Easy EC2 Config

No subnet, no having to get the routing right, but still locked-down ports.

The configurable parts are mostly in `vars.tf` and `terraform.tf`

Note that the AMI id is dependent on the region and the instance architecture.
