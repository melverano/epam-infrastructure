resource "aws_db_instance" "epam-rds" {
  allocated_storage    = 15
  engine               = "postgres"
  engine_version       = "13.1"
  instance_class       = "db.t3.micro"
  name                 = var.rds_db_name
  username             = var.rds_db_user
  password             = var.rds_db_pass
  availability_zone    = "eu-central-1a"
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.epam_db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.epam_db_security_group.id]
}

resource "aws_db_subnet_group" "epam_db_subnet_group" {
  name       = "epam_db_subnet_group"
  subnet_ids = ["subnet-0f1a3293d2f69f257","subnet-0d86d430d25258a18"]

  tags = {
    Name    = "epam_db_subnet_group"
    Project = "Epam"
    Type    = "RDS"
  }
}

resource "aws_security_group" "epam_db_security_group" {
  name        = "allow_postgresql_port"
  description = "Allow inbound traffic in 10.0.0.0/16"
  vpc_id      = "vpc-0b9ccc12a6e5a6bf4"

  ingress {
    description      = "PostgreSQL"
    protocol         = "tcp"
    from_port        = 5432
    to_port          = 5432
    cidr_blocks      = ["10.0.0.0/16"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "epam_db_security_group"
  }
}
