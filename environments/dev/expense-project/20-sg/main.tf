module "mysql_sg" {
  source       = "../../../../modules/sg"
  vpc_id       = data.aws_ssm_parameter.vpc_id.value
  project_name = var.project_name
  environment  = var.environment
  sg_name = "mysql-sg"
}

module "backend_sg" {
  source       = "../../../../modules/sg"
  vpc_id       = data.aws_ssm_parameter.vpc_id.value
  project_name = var.project_name
  environment  = var.environment
  sg_name = "backend-sg"
}

module "frontend_sg" {
  source       = "../../../../modules/sg"
  vpc_id       = data.aws_ssm_parameter.vpc_id.value
  project_name = var.project_name
  environment  = var.environment
  sg_name = "frontend-sg"
}
# module "bastion_sg" {
#   source       = "../../../../modules/sg"
#   vpc_id       = data.aws_ssm_parameter.vpc_id.value
#   project_name = var.project_name
#   environment  = var.environment
#   sg_name = "bastion-sg"
# }

#Security_Group Rules
resource "aws_security_group_rule" "backend_to_mysql" {
    type = "ingress"
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    source_security_group_id = module.backend_sg.id
    security_group_id = module.mysql_sg.id
    description              = "Allow MySQL access from backend SG to MySQL SG"
}

resource "aws_security_group_rule" "frontend_to_backend" {
    type = "ingress"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    source_security_group_id = module.frontend_sg.id
    security_group_id = module.backend_sg.id
    description              = "Allow access from frontend SG to backend SG"
}

resource "aws_security_group_rule" "public_to_frontend" {
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = module.frontend_sg.id
    description              = "Allow access from public to frontend SG"
}

# resource "aws_security_group_rule" "bastion_to_mysql" {
#     type = "ingress"
#     from_port = 22
#     to_port = 22
#     protocol = "tcp"
#     source_security_group_id = module.bastion_sg.id
#     security_group_id = module.mysql_sg.id    
# }

# resource "aws_security_group_rule" "bastion_to_backend" {
#     type = "ingress"
#     from_port = 22
#     to_port = 22
#     protocol = "tcp"
#     source_security_group_id = module.bastion_sg.id
#     security_group_id = module.backend_sg.id
# }

# resource "aws_security_group_rule" "bastion_to_frontend" {
#     type = "ingress"
#     from_port = 22
#     to_port = 22
#     protocol = "tcp"
#     source_security_group_id = module.bastion_sg.id
#     security_group_id = module.frontend_sg.id
# }








