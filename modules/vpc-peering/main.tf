# resource "aws_vpc_peering_connection" "peer" {
#     vpc_id = aws_vpc.main.id
#     peer_vpc_id = data.aws_vpc.default.id
#     auto_accept = true

#     tags = merge(
#         var.common_tags,
        
#         {
#         Name = "${local.name_prefix}-vpc-to-default-vpc"
#         }
#     )
# }

# resource "aws_route" "public_peering" {
#     route_table_id = aws_route_table.public.id
#     destination_cidr_block = data.aws_vpc.default.cidr_block
#     vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
# }
# resource "aws_route" "private_peering" {
#     route_table_id = aws_route_table.private.id
#     destination_cidr_block = data.aws_vpc.default.cidr_block
#     vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
# }
# resource "aws_route" "database_peering" {
#     route_table_id = aws_route_table.database.id
#     destination_cidr_block = data.aws_vpc.default.cidr_block
#     vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
# }
# resource "aws_route" "default_to_main" {
#   route_table_id              = data.aws_vpc.default.main_route_table_id
#   destination_cidr_block      = aws_vpc.main.cidr_block
#   vpc_peering_connection_id   = aws_vpc_peering_connection.peer.id
# }