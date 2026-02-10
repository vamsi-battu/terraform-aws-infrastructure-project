resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr
    enable_dns_support = true
    enable_dns_hostnames = true

    tags = merge(
        var.common_tags,
        var.vpc_tags,
        {
        Name = local.name_prefix
        }
    )
}

resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id
    tags = merge(
        var.common_tags,
        var.igw_tags,
        {
        Name = local.name_prefix
        }
    )
}

resource "aws_subnet" "public" {
    for_each = {
        for index, az in var.azs :
        az => var.public_subnet_cidrs[index]
    }
    availability_zone = each.key
    cidr_block = each.value
    vpc_id = aws_vpc.main.id
    map_public_ip_on_launch = true

    tags = merge(
        var.common_tags,
        {
        Name = "${local.name_prefix}-public-${each.key}"
        tier = "public"
        }
    )
}

resource "aws_subnet" "private" {
    for_each = {
        for index, az in var.azs :
        az => var.private_subnet_cidrs[index]
    }
    availability_zone = each.key
    cidr_block = each.value
    vpc_id = aws_vpc.main.id

    tags = merge(
        var.common_tags,
        {
        Name = "${local.name_prefix}-private-${each.key}"
        tier = "private"
        }
    )
}

resource "aws_subnet" "database" {
    for_each = {
        for index, az in var.azs :
        az => var.database_subnet_cidrs[index]
    }
    availability_zone = each.key
    cidr_block = each.value
    vpc_id = aws_vpc.main.id

    tags = merge(
        var.common_tags,
        {
        Name = "${local.name_prefix}-database-${each.key}"
        tier = "database"
        }
    )
}

resource "aws_db_subnet_group" "main" {
    name  = local.name_prefix
    subnet_ids = [
        for subnet in aws_subnet.database : subnet.id
    ]

    tags = merge(
        var.common_tags,
        {
        Name = "${local.name_prefix}-db-subnet-group"
        tier = "database"
        }
    )
}

resource "aws_eip" "main" {
    domain = "vpc"
}

resource "aws_nat_gateway" "main" {
    allocation_id = aws_eip.main.id
    subnet_id = values(aws_subnet.public)[0].id
    depends_on = [aws_internet_gateway.main]

    tags = merge(
        var.common_tags,
        {
        Name = "${local.name_prefix}-Nat-gateway"
        }
    )
}

# Public Route Table
# Used by ALB / Bastion / Internet-facing resources
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    {
      Name = "${local.name_prefix}-public-route-table"
    }
  )
}

# Route: Public subnet → Internet Gateway
resource "aws_route" "public_to_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

# Associate all public subnets with public route table
resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# Private Route Table
# Used by application servers
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    {
      Name = "${local.name_prefix}-private-route-table"
    }
  )
}

# Route: Private subnet → NAT Gateway
resource "aws_route" "private_to_nat" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main.id
}

# Associate all private subnets with private route table
resource "aws_route_table_association" "private" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}

# Database Route Table
# No internet access (no IGW / NAT routes)
resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    {
      Name = "${local.name_prefix}-database-route-table"
    }
  )
}

# Associate all database subnets with database route table
resource "aws_route_table_association" "database" {
  for_each       = aws_subnet.database
  subnet_id      = each.value.id
  route_table_id = aws_route_table.database.id
}