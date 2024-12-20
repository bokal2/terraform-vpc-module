## Terraform VPC Module

A Terraform Networking module that can be used to scaffold VPC resources.

### Example usage

```hcl
module "vpc" {
    source = "modules/networking"

    vpc_config = {
        vpc_cidr = "10.0.0.0/16"
        vpc_name = "test-vpc"
    }

    subnet_config = {
        cidr_block = "10.0.0.0/24"
        public = true # false by default
        az = "us-east-1a"
    }
}
```
