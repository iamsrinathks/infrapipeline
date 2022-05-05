data "aws_key_pair" "assessment_key" {
  key_name = "assessment_kp"
}

resource "aws_instance" "webserver" {
  ami                    = var.AMIS[var.AWS_REGION]
  instance_type          = var.INSTANCE_TYPE
  key_name               = data.aws_key_pair.assessment_key.key_name
  vpc_security_group_ids = [aws_security_group.assessment_sg.id]
  user_data              = data.cloudinit_config.assessment_config.rendered
  tags                   = { for k, v in var.TAGS : k => lower(v) }
}
