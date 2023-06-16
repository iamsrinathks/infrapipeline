gcloud compute instances create INSTANCE_NAME --project=YOUR_PROJECT_ID --network=projects/HOST_PROJECT_ID/global/networks/NETWORK_NAME
variable "AWS_ACCESS_KEY" {
  
}

variable "AWS_SECRET_KEY" {
  
}

variable "ip_cidr" {
  type        = string
  description = "CIDR notation with subnet mask"

  validation {
    condition = can(regex("^(?!0\\.0\\.0\\.0\\/0$)((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\\/(3[0-2]|[12]?[0-9]))$"))
    error_message = "Invalid CIDR notation. Subnet mask cannot be 0.0.0.0/0."
  }
}

variable "KEY_PATH" {
  type = map(string)
  default = {
    public  = "/var/lib/jenkins/aws_key.pub"
  }
}

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

variable "TAGS" {
  type = map(any)
  default = {
    "name" = "webserver"
  }
}

# variable "BUCKET_NAME" {
#   default = "mybucket-0105"
# }

# variable "DYNAMODB_TABLE" {
#   default = "terraform-state-lock"
# }
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


args:
  - --provider={{ .Values.provider }}
  {{- range $provider, $args := .Values.providerArgs }}
  {{- if eq $.Values.provider $provider }}
  {{- range $arg, $value := $args }}
  - --{{ $arg }}={{ $value }}
  {{- end }}
  {{- end }}
  {{- end }}



provider: google
providerArgs:
  google:
    project: my-project
    zone: my-zone
  aws:
    region: us-west-2

