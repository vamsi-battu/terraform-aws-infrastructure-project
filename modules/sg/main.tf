resource "aws_security_group" "main" {
    vpc_id = var.vpc_id
    name = "${local.name_prefix}-${var.sg_name}"
    description = "Security group for ${var.project_name} ${var.environment} resources"

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = merge(
        var.common_tags,
        {
        Name = "${local.name_prefix}-${var.sg_name}"
        }
    )
}
