data "aws_subnet" "selected" {
  count = length(var.subnet_ids) > 0 ? 1 : 0
  id    = var.subnet_ids[0]
}

resource "aws_security_group" "lambda" {
  count       = length(var.subnet_ids) > 0 ? 1 : 0
  name        = "${var.prefix}lambda_alb_logs_to_elasticsearch"
  description = "${var.prefix}lambda_alb_logs_to_elasticsearch"
  vpc_id      = data.aws_subnet.selected[0].vpc_id

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
            var.tags,
            tomap({"Scope" = "${var.prefix}lambda_function_to_elasticsearch"}),
            )
}
