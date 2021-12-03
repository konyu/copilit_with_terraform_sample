# ====================
# VPC
# ====================
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr[var.env]
  enable_dns_hostnames = true

  tags = {
    Name = "${var.env}-${var.project}-vpc"
  }
}

output "aws_vpc_id" {
  value = aws_vpc.vpc.id
}


# ====================
# Public Subnet
# ====================
resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnet_cidr["${var.env}_public_a"]
  availability_zone       = var.az["az_a"]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.env}-${var.project}-public-a-subnet"
  }
}

output "public_subnet_a_id" {
  value = aws_subnet.public_a.id
}

resource "aws_subnet" "public_c" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnet_cidr["${var.env}_public_c"]
  availability_zone       = var.az["az_c"]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.env}-${var.project}-public-c-subnet"
  }
}

output "public_subnet_c_id" {
  value = aws_subnet.public_c.id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.env}-${var.project}-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.env}-${var.project}-public-rtb"
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_c" {
  subnet_id      = aws_subnet.public_c.id
  route_table_id = aws_route_table.public.id
}
# ====================
# Private Subnet
# ====================
resource "aws_subnet" "private_a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnet_cidr["${var.env}_private_a"]
  availability_zone       = var.az["az_a"]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.env}-${var.project}-private-a-subnet"
  }
}

output "private_subnet_a_id" {
  value = aws_subnet.private_a.id
}

resource "aws_subnet" "private_c" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnet_cidr["${var.env}_private_c"]
  availability_zone       = var.az["az_c"]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.env}-${var.project}-private-b-subnet"
  }
}

output "private_subnet_c_id" {
  value = aws_subnet.private_c.id
}
# ====================
# Security Group
# ====================
# Publicサブネット向けのセキュリティグループ
resource "aws_security_group" "public_sg" {
  tags = {
    Name = "${var.env}-${var.project}-public-sg"
  }
  description = "Allow SSH inbound"
  vpc_id = aws_vpc.vpc.id
  # インバウンドルール
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # アウトバウンドルール
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
}

# Privateサブネット向けのセキュリティグループ
resource "aws_security_group" "private_sg" {
  tags = {
    Name = "${var.env}-${var.project}-private-sg"
  }
  description = "Allow MySQL inbound"
  vpc_id = aws_vpc.vpc.id
  # インバウンドルール
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    # 特定のセキュリティグループからの通信のみ受け入れる
    # security_groups = [aws_security_group.public_sg.id]
    cidr_blocks = [
      var.vpc_cidr["${var.env}"]
    ]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "redis_private_sg" {
  tags = {
    Name = "${var.env}-${var.project}-redis-private-sg"
  }
  description = "Allow Redis inbound"
  vpc_id = aws_vpc.vpc.id
  # インバウンドルール
  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = [
      var.vpc_cidr["${var.env}"]
    ]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}