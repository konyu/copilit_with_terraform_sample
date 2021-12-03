variable "project" {
  type    = string
  default = "kon-yu-app"
}

variable "env" {
  type    = string
  default = "production"
}

variable "vpc_cidr" {
  type = map(string)

  default = {
    prd = "10.1.0.0/16"
    production = "10.2.0.0/16"
  }
}

variable "subnet_cidr" {
  type = map(string)

  default = {
    prd_public_a  = "10.1.1.0/24"
    prd_public_c  = "10.1.2.0/24"
    prd_private_a = "10.1.3.0/24"
    prd_private_c = "10.1.4.0/24"
    production_public_a  = "10.2.1.0/24"
    production_public_c  = "10.2.2.0/24"
    production_private_a = "10.2.3.0/24"
    production_private_c = "10.2.4.0/24"
  }
}

# KeyペアはAWSのウェブコンソールのEC2のメニューから作成する
variable "key_pair" {
  type = string
  default = "kon-yu-app-production-key"
}

variable "az" {
  type = map(string)

  default = {
    az_a = "ap-northeast-1a"
    az_c = "ap-northeast-1c"
    az_d = "ap-northeast-1d"
  }
}

variable "rds_master_username" {}
variable "rds_master_password" {}

variable "redis_node_count" {
  type    = number
  default = 2
}
# variable "aws_web_domain" {
#   type    = string
#   default = "konyu.net"
# }
