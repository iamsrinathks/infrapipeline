resource "aws_key_pair" "aws_key" {
 key_name   = "mykey"
}


resource "aws_instance" "webserver" {
  ami           = var.AMIS[var.AWS_REGION]
  instance_type = var.INSTANCE_TYPE
  key_name               = aws_key_pair.aws_key.key_name
  vpc_security_group_ids = [aws_security_group.sec_group.id]
  user_data              = data.cloudinit_config.config.rendered
  tags                   = { for k, v in var.TAGS : k => upper(v) }
}
