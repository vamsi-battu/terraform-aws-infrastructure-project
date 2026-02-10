variable "project_name" {
    default = {}
}
variable "environment" {
    default = {}
}

variable "vpc_cidr" {
    type = string
}
variable "vpc_tags" {
    type = map(string)
    default = {}
}
variable "igw_tags" {
    type = map(string)
    default = {}
}
variable "common_tags" {
    type = map(string)
    default = {}
}
variable "azs" {
  description = "List of availability zones"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets (one per AZ)"
  type        = list(string)
  validation {
    condition     = length(var.public_subnet_cidrs) == length(var.azs)
    error_message = "Number of public subnet CIDRs must match number of AZs."
  }
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets (one per AZ)"
  type        = list(string)
  validation {
    condition     = length(var.private_subnet_cidrs) == length(var.azs)
    error_message = "Number of private subnet CIDRs must match number of AZs."
  }
}

variable "database_subnet_cidrs" {
  description = "List of CIDR blocks for database subnets (one per AZ)"
  type        = list(string)
  validation {
    condition     = length(var.database_subnet_cidrs) == length(var.azs)
    error_message = "Number of database subnet CIDRs must match number of AZs."
  }
}

