output "public_subnets" {
  value = local.public_subnets
}

output "vpc_id" {
  value = aws_vpc.this.id
}
