output "vpc_id" {
    value = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = values(aws_subnet.public)[*].id
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = values(aws_subnet.private)[*].id
}

output "database_subnet_ids" {
  description = "List of database subnet IDs"
  value       = values(aws_subnet.database)[*].id
}

output "database_subnet_group" {
  value = aws_db_subnet_group.main.name
}
