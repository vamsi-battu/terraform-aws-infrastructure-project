locals {
    name_prefix = "${var.project_name}-${var.environment}"
}

locals {
    private_subnet_ids = split(",", data.aws_ssm_parameter.private_subnet_ids.value)
}