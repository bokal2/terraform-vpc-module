variable "region" {
  type    = string
  default = "us-east-1"
}

variable "project_name" {
  type = string
}

variable "vpc_config" {
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
