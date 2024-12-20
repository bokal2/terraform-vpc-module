variable "region" {
  description = "Region of the AWS account for resource deployment"
  type        = string
  default     = "us-east-1"
}

variable "vpc_config" {
  description = "VPC Configurations. Required details are vpc_name and vpc_cidr"
  type = object({
    vpc_name = string
    vpc_cidr = string
  })

  validation {
    condition     = can(cidrnetmask(var.vpc_config.vpc_cidr))
    error_message = "Invalid CIDR block"
  }
}


variable "subnet_config" {
  description = "Subnet configurations. Required details: cidr_block, public(indicating whether the subnet is public or private) and availability zone"
  type = map(object({
    cidr_block = string
    public     = optional(bool, false)
    az         = string
  }))

  validation {
    condition     = alltrue([for config in values(var.subnet_config) : can(cidrnetmask(config.cidr_block))])
    error_message = "The provided subnet CIDR block is invalid!"
  }
}
