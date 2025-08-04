# 8. Outputs Values
# Output dos IDs dos recursos
output "vpc_id" {
  value = aws_vpc.dataeng_vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.dataeng_public_subnet.id
}

output "private_subnet_id" {
  value = aws_subnet.dataeng_private_subnet.id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.dataeng_igw.id
}

