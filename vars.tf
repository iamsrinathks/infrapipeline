variable "AWS_REGION" {
  default = "eu-west-2"
}

variable "AMIS" {
  type = map(string)
  default = {
    eu-west-2 = "ami-0758d98b134137d18"
  }
}

variable "INSTANCE_TYPE" {
  type    = string
  default = "t2.micro"
}

variable "VPC_CIDR_BLOCK" {
  type    = string
  default = "10.1.0.0/16"
}

variable "SUBNET_CIDR_BLOCK" {
  type    = string
  default = "10.1.1.0/24"
}

variable "SUBNET_AVAILABILITY_ZONE" {
  type    = string
  default = "eu-west-2a"
}

variable "TAGS" {
  type = map(any)
  default = {
    "name" = "assessment"
  }
}

variable "SG_RULES_INGRESS" {
  type = list(object({
    from_port   = number,
    to_port     = number,
    cidr_blocks = string,
    protocol    = string,
    description = string
  }))
  default = [
    {
      from_port   = 22
      to_port     = 22
      cidr_blocks = "0.0.0.0/0"
      protocol    = "tcp"
      description = "Allow SSH"
    },
    {
      from_port   = 80
      to_port     = 80
      cidr_blocks = "0.0.0.0/0"
      protocol    = "tcp"
      description = "Allow port 80"
    },
    {
      from_port   = 443
      to_port     = 443
      cidr_blocks = "0.0.0.0/0"
      protocol    = "tcp"
      description = "Allow port 443"
    }
  ]
}

variable "SG_RULES_EGRESS" {
  type = list(object({
    from_port   = number,
    to_port     = number,
    cidr_blocks = string,
    protocol    = string,
    description = string
  }))
  default = [
    {
      from_port   = 0
      to_port     = 0
      cidr_blocks = "0.0.0.0/0"
      protocol    = "-1"
      description = "Allow All Traffic"
    }
  ]
}

variable "NACL_RULES_INGRESS" {
  type = list(object({
    protocol   = number
    rule_no    = number
    action     = string
    cidr_block = string
    from_port  = number
    to_port    = number
  }))
  default = [
    {
      protocol   = -1
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 0
      to_port    = 0
    }
  ]
}

variable "NACL_RULES_EGRESS" {
  type = list(object({
    protocol   = number
    rule_no    = number
    action     = string
    cidr_block = string
    from_port  = number
    to_port    = number
  }))
  default = [
    {
      protocol   = -1
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 0
      to_port    = 0
    }
  ]
}
