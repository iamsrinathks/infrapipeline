resource "aws_security_group" "sec_group" {
  name        = "sg"
  description = "Security group for webserver ec2"

  dynamic "ingress" {
    for_each = var.SG_RULES_INGRESS
    content {
      from_port   = ingress.value["from_port"]
      to_port     = ingress.value["to_port"]
      cidr_blocks = split(",", ingress.value["cidr_blocks"])
      protocol    = ingress.value["protocol"]
    }
  }

  dynamic "egress" {
    for_each = var.SG_RULES_EGRESS
    content {
      from_port   = egress.value["from_port"]
      to_port     = egress.value["to_port"]
      cidr_blocks = split(",", egress.value["cidr_blocks"])
      protocol    = egress.value["protocol"]
    }
  }

}
