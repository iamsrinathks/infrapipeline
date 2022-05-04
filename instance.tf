resource "aws_instance" "webserver" {
  ami           = var.AMIS[var.AWS_REGION]
  instance_type = var.INSTANCE_TYPE
  key_name               = "mykey"
  vpc_security_group_ids = [aws_security_group.sec_group.id]
  user_data              = data.cloudinit_config.config.rendered
  tags                   = { for k, v in var.TAGS : k => upper(v) }
}
