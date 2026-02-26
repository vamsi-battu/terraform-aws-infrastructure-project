locals {
    public_subnet_ids = split(",", data.aws_ssm_parameter.public_subnet_ids.value)
}

locals {
    security_group_id = data.aws_ssm_parameter.vpn_sg_id.value
}

locals {
    name_prefix = "${var.project_name}-${var.environment}"
}

locals {
    ami = data.aws_ami.ami.id
}