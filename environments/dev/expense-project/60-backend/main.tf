module "backend" {
  source = "terraform-aws-modules/ec2-instance/aws"

  ami                    = local.ami
  name                   = "${local.name_prefix}-backend"
  instance_type          = var.instance_type
  vpc_security_group_ids = [local.backend_sg_id]
  subnet_id              = local.private_subnet_id

  tags = merge(
    var.common_tags,
    
    {
      Name = "${local.name_prefix}-backend"
    }
  )
}

