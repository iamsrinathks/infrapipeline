data "aws_key_pair" "assessment_key" {
  key_name = "assessment_kp"
}

data "cloudinit_config" "assessment_config" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.script.rendered
  }
}

data "template_file" "script" {
  template = file("scripts/nginx.sh")
}


module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway = true
  enable_vpn_gateway = false

  tags = { for k, v in var.tags : k => lower(v) }
}



module "assessment_webapp_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "assessment-webapp-sg"
  description = "Security group for EC2 instance"
  vpc_id      = module.vpc.vpc_id

  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "http-80-tcp"
      source_security_group_id = module.assessment_alb_sg.security_group_id
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 1
  egress_cidr_blocks      = ["0.0.0.0/0"]
  egress_rules = ["all-all"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH for Jenkins agents"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}


module "assessment_alb_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "assessment-alb-sg"
  description = "Security group for ALB"
  vpc_id      = module.vpc.vpc_id


  ingress_cidr_blocks      = ["0.0.0.0/0"]
  ingress_rules            = ["https-443-tcp"]

  computed_egress_with_source_security_group_id = [
    {
      rule                     = "http-80-tcp"
      source_security_group_id = module.assessment_webapp_sg.security_group_id
    }
  ]
  number_of_computed_egress_with_source_security_group_id = 1
}


module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "webapp_assessment"

  ami                    = var.amis[var.region]
  instance_type          = var.instance_type
  key_name                    = data.aws_key_pair.assessment_key.key_name
  monitoring                  = true
  associate_public_ip_address = true
  vpc_security_group_ids = [module.assessment_webapp_sg.security_group_id]
  subnet_id              = module.vpc.public_subnets[0]
  user_data = data.cloudinit_config.assessment_config.rendered
  iam_instance_profile = "ec2-test"
  tags = { for k, v in var.tags : k => lower(v) }
}

resource "aws_eip" "assessment_web_eip" {
  vpc = true
}
resource "aws_eip_association" "eip_assoc" {
  instance_id   = module.ec2_instance.id
  allocation_id = aws_eip.assessment_web_eip.id
}
