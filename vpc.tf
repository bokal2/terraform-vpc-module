
locals {
  public_subnets = { for key, config in var.subnet_config : key => config if config.public }
}

resource "aws_vpc" "this" {
  cidr_block = var.vpc_config.vpc_cidr

  tags = {
    Project = var.project_name
    Name    = var.vpc_config.vpc_name
  }
}


data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "this" {
  for_each          = var.subnet_config
  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.az

  tags = {
    Name = each.key
  }

  lifecycle {
    precondition {
      condition     = contains(data.aws_availability_zones.available.names, each.value.az)
      error_message = <<-EOT
      Subnet key: "${each.key}"
      Error Message: Invalid Availability Zone
      Available zones: ${join(", ", data.aws_availability_zones.available.names)}
      EOT
    }
  }
}

resource "aws_internet_gateway" "this" {
  count  = length(local.public_subnets) > 0 ? 1 : 0
  vpc_id = aws_vpc.this.id
}

resource "aws_route_table" "public_rtb" {
  count  = length(local.public_subnets) > 0 ? 1 : 0
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this[0].id
  }

}

resource "aws_route_table_association" "public" {
  for_each = local.public_subnets

  subnet_id      = aws_subnet.this[each.key].id
  route_table_id = aws_route_table.public_rtb[0].id
}
