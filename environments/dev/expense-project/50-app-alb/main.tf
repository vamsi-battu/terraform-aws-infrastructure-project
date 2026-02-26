module "app-alb" {
    source = "terraform-aws-modules/alb/aws"
    
    name = "${local.name_prefix}-app-alb"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    subnets = local.private_subnet_ids
    security_groups = [data.aws_ssm_parameter.app-alb_sg_id.value]
    internal = true
    create_security_group = false
    enable_deletion_protection = false
    
    tags = var.common_tags
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = module.app-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "fixed-response"

    fixed_response {
        content_type = "text/html"
        message_body = "<h1>Hello, I am from app alb<h1>"
        status_code = "200"
        
    }
  }
}




resource "aws_route53_record" "app_alb" {
  zone_id = data.aws_route53_zone.selected.zone_id

  name = "*.app-${var.environment}.${var.zone_name}"
  type = "A"

  alias {
    name                   = module.app-alb.dns_name
    zone_id                = module.app-alb.zone_id
    evaluate_target_health = true
  }

  allow_overwrite = true
}

