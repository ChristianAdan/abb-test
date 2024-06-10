resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "subnet1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "subnet2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
}

resource "aws_db_subnet_group" "example" {
  name       = "my-db-subnet-group"
  subnet_ids = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
}


resource "aws_security_group" "allow_all" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "app-gateway"
  }
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "route-table-gw"
  }
}

resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.main.id
}

resource "aws_eip" "main" {
  vpc = true

  tags = {
    Name = "elastic-ip-app"
  }
}

resource "aws_instance" "flask_instance" {
  ami           = "ami-00beae93a2d981137"
  instance_type = "t2.micro"

  key_name = "abb-keypair"

  vpc_security_group_ids = [aws_security_group.allow_all.id]
  subnet_id              = aws_subnet.subnet1.id

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install docker -y
              sudo service docker start
              sudo docker run -d -p 5000:5000 -e DATABASE_URL=postgresql://${var.db_username}:${var.db_password}@${aws_db_instance.postgres.address}:5432/${var.db_name} adanchristian/cadan-abb:v1
              EOF

  tags = {
    Name = "AppInstance"
  }
}

resource "aws_db_instance" "postgres" {
  engine         = "postgres"
  instance_class = "db.t3.micro"
  db_name           = var.db_name
  identifier     = var.db_identifier
  username       = var.db_username
  password       = var.db_password
  allocated_storage = 20
  db_subnet_group_name = aws_db_subnet_group.example.name

  vpc_security_group_ids = [aws_security_group.allow_all.id]

  skip_final_snapshot = true
}