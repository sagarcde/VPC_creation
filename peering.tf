resource "aws_vpc_peering_connection" "peering" {
  count = var.is_peering_required ? 1 : 0
  vpc_id = aws_vpc.main.id
  peer_vpc_id = data.aws_vpc.default.id
  auto_accept = true
  accepter {
    allow_remote_vpc_dns_resolution = true
  }
  requester {
    allow_remote_vpc_dns_resolution = true
  }
  tags = merge(
    var.peering_tags,
    local.common_tags,
    {
      Name = "${local.common_name}-peering"
    }
  )
}

resource "aws_route" "public_peering" {
  count = var.is_peering_required ? 1 : 0
  route_table_id = aws_route_table.public.id
  destination_cidr_block = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[count.index].id
  
 }
 resource "aws_route" "private_peering" {
  count = var.is_peering_required ? 1 : 0
  route_table_id = aws_route_table.private.id
  destination_cidr_block = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[count.index].id
 }
 resource "aws_route" "database_peering" {
  count = var.is_peering_required ? 1 : 0
  route_table_id = aws_route_table.database.id
  destination_cidr_block = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[count.index].id
 }

resource "aws_route" "default_peering" {
  count = var.is_peering_required ? 1 : 0
  route_table_id = data.aws_vpc.default.main_route_table_id
  destination_cidr_block = aws_vpc.main.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[count.index].id
}