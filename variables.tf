variable "region" {
  type    = string
  default = "eu-west-2"
}

variable "amis" {
  type = map(string)
  default = {
    eu-west-2 = "ami-0758d98b134137d18"
  }
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "vpc_name" {
  type    = string
  default = "assessment-vpc"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "private_subnets" {
  type    = list
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnets" {
  type    = list
  default = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "tags" {
  type = map(any)
  default = {
    "name" = "assessment"
  }
}
