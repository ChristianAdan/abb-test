resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "main-vpc"
    Owner= "Christian Adan"
  }
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
    Owner= "Christian Adan"
  }
}

resource "aws_internet_gateway" "app-gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "app-gw"
    Owner= "Christian Adan"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app-gw.id
  }

  tags = {
    Name = "public-route-table"
    Owner= "Christian Adan"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "instance" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "instance-security-group"
    Owner = "Christian Adan"
  }
}

resource "aws_instance" "flask_instance" {
  ami           = "ami-00beae93a2d981137"
  instance_type = "t2.micro"
  key_name = "abb-keypair"
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.instance.id]
  subnet_id              = aws_subnet.public.id

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install docker -y
              sudo service docker start
              sudo yum install curl -y
              sudo yum install -y libxcrypt-compat
              sudo curl -L "https://github.com/docker/compose/releases/download/1.29.1/docker-compose-$(uname -s)-$(uname -m)" -o "/usr/local/bin/docker-compose"
              sudo docker-compose up -d
              EOF

  tags = {
    Name = "AppInstance"
    Owner = "Christian Adan"
  }
}