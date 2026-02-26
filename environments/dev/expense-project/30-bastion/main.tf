resource "aws_instance" "bastion" {
    ami = var.ami
    instance_type = var.instance_type
    vpc_security_group_ids = [data.aws_ssm_parameter.bastion_sg_id.value]
    subnet_id = local.public_subnet_ids[0]
    tags = merge(
        
        var.common_tags,
        {
            Name = "${local.name_prefix}-bastion"
        }
    )
}