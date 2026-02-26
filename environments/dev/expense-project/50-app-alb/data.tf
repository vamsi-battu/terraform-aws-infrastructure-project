data "aws_ssm_parameter" "vpc_id"{
    name = "/${var.project_name}/${var.environment}/vpc_id"
}

data "aws_ssm_parameter" "private_subnet_ids"{
    name = "/${var.project_name}/${var.environment}/private_subnet_ids"
}

data "aws_ssm_parameter" "app-alb_sg_id" {
  name =   "/${var.project_name}/${var.environment}/app-alb_sg_id"
}
data "aws_route53_zone" "selected" {
  name         = var.zone_name
  private_zone = false
}