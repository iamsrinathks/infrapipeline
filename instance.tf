resource "aws_key_pair" "aws_key" {
 key_name   = "mykey"
 public_key = file(var.KEY_PATH["public"])
}


resource "aws_instance" "webserver" {
  ami           = var.AMIS[var.AWS_REGION]
  instance_type = var.INSTANCE_TYPE
  key_name               = aws_key_pair.aws_key.key_name
  vpc_security_group_ids = [aws_security_group.sec_group.id]
  user_data              = data.cloudinit_config.config.rendered
  tags                   = { for k, v in var.TAGS : k => upper(v) }
  connection {
   host        = self.public_ip
   type        = "ssh"
   user        = "ubuntu"
   private_key = file(var.KEY_PATH["private"])
   }

  #  provisioner "remote-exec" {
  #   inline = [ "sudo apt update",
	# "sudo apt install nginx -y",
	# "systemctl enable nginx",
	# "systemctl start nginx",
  # "sudo service ufw stop",
	# "touch /home/ubuntu/check.txt"
  #     ]
  #  }

   provisioner "local-exec" {
    on_failure = continue
    command = "echo ${aws_instance.webserver.public_ip} >> /Users/srinathksrinivasan/digital/terraform/learn/assessment/ip.txt"
  }
}
