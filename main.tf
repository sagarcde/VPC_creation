resource "aws_vpc" "main" {
  cidr_block = var.cidr_vpc
  enable_dns_hostnames = true
  instance_tenancy = "default"
  tags = merge(
    local.common_tags, 
        var.VPC_tags
    )  
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    local.common_tags,
    var.IGW_tags)
}
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)
  vpc_id = aws_vpc.main.id
  cidr_block = var.public_subnet_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone = local.az_names[count.index]
  tags = merge(
    var.public_subnet_tags,
    local.common_tags,
    {
      Name = "${local.common_name}-public-${split("-", local.az_names[count.index])[2]}"
    }
  )
}

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.main.id
  cidr_block = var.private_subnet_cidrs[count.index]
  map_public_ip_on_launch = false
  availability_zone = local.az_names[count.index]
  tags = merge(
    var.private_subnet_tags,
    local.common_tags,
    {
      Name = "${local.common_name}-private-${split("-", local.az_names[count.index])[2]}"
    }
  )
  
}

resource "aws_subnet" "database" {
  count = length(var.database_subnet_cidrs)
  vpc_id = aws_vpc.main.id
  cidr_block = var.database_subnet_cidrs[count.index]
  map_public_ip_on_launch = false
  availability_zone = local.az_names[count.index]
  tags = merge(
    var.database_subnet_tags,
    local.common_tags,
    {
      Name = "${local.common_name}-database-${split("-", local.az_names[count.index])[2]}"
    }
  )
  
}
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    var.public_route_table_tags,
    local.common_tags,
    {
      Name = "${local.common_name}-public"
    }
  )
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    var.private_route_table_tags,
    local.common_tags,
    {
      Name = "${local.common_name}-private"
    }
  )
}

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    var.database_route_table_tags,
    local.common_tags,
    {
      Name = "${local.common_name}-database"
    }
  )
}
resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidrs)
  subnet_id = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidrs)
  subnet_id = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
resource "aws_route_table_association" "database" {
  count = length(var.database_subnet_cidrs)
  subnet_id = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database.id
}
resource "aws_eip" "nat" {
  domain = "vpc"
  tags = merge(
    var.nat_eip_tags,
    local.common_tags,
    {
      Name = "${local.common_name}-nat"
    }
  )
}
resource "aws_nat_gateway" "main" {
  #count = length(var.public_subnet_cidrs)
  allocation_id = aws_eip.nat.id
  subnet_id = aws_subnet.public[0].id
  tags = merge(
    var.nat_gateway_tags,
    local.common_tags,
    {
      Name = "${local.common_name}-nat"
    }
  )
  depends_on = [aws_internet_gateway.main]
}
resource "aws_route" "public_internet_access" {
  route_table_id = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main.id
}
resource "aws_route" "private_nat_access" {
  route_table_id = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.main.id
}
resource "aws_route" "database_nat_access" {
  route_table_id = aws_route_table.database.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.main.id
}     