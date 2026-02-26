locals {
    ami = data.aws_ami.ami.id
}
locals {
    name_prefix = "${var.project_name}-${var.environment}"
}
locals {
    backend_sg_id = data.aws_ssm_parameter.backend_sg_id.value
}

locals {
    private_subnet_id = split(",", data.aws_ssm_parameter.private_subnet_ids.value)[0]
}