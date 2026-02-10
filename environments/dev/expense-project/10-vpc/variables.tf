variable "project_name" {
  default = "expense"
  type    = string
}
variable "environment" {
  default = "dev"
  type    = string
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "common_tags" {
  default = {
    Project     = "Expense"
    Environment = "Dev"
    Terraform   = "True"
  }
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets (one per AZ)"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets (one per AZ)"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "database_subnet_cidrs" {
  description = "List of CIDR blocks for database subnets (one per AZ)"
  type        = list(string)
  default     = ["10.0.21.0/24", "10.0.22.0/24"]
}