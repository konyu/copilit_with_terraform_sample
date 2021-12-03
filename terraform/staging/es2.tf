
# ====================
# AMI
# ====================
# 最新版のAmazonLinux2のAMI情報取得する
# ref https://qiita.com/kou_pg_0131/items/45cdde3d27bd75f1bfd5
data "aws_ami" "ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "block-device-mapping.volume-type"
    values = ["gp2"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

# Amazon linuxのamiを取得するシンプルな方法
# https://dev.classmethod.jp/articles/launch-ec2-from-latest-amazon-linux2-ami-by-terraform/
# data aws_ssm_parameter amzn2_ami {
#   name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
# }
# このように指定する
# ami =data.aws_ssm_parameter.amzn2_ami.value

# ====================
# EC2 Instance
# ====================
resource "aws_instance" "ec2" {
  ami           = data.aws_ami.ami.image_id
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public_a.id
  root_block_device {
    volume_type = "gp2"
    volume_size = "30"
  }
  vpc_security_group_ids = [aws_security_group.public_sg.id]
  key_name = var.key_pair
  tags = {
    Name = "${var.env}-${var.project}-ec2"
  }
}

# ====================
# Elastic IP
# ====================
resource "aws_eip" "ip" {
  instance = aws_instance.ec2.id
  vpc      = true
}

output "ec2_eip" {
  value = aws_eip.ip.public_ip
}