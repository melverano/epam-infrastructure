resource "aws_vpc" "epam_vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name    = "epam_vpc"
    Project = "epam"
    Type    = "Network"
  }
}

resource "aws_subnet" "epam_subnet_a" {
  vpc_id                  = aws_vpc.epam_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone_id    = "euc1-az2"
  map_public_ip_on_launch = true

  tags = {
    Name    = "epam_subnet_a"
    Project = "epam"
    Type    = "Network"
  }
}

resource "aws_subnet" "epam_subnet_b" {
  vpc_id                  = aws_vpc.epam_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone_id    = "euc1-az3"
  map_public_ip_on_launch = true

  tags = {
    Name    = "epam_subnet_b"
    Project = "epam"
    Type    = "Network"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.epam_vpc.id

  tags = {
    Name    = "epam_igw"
    Project = "epam"
    Type    = "Network"
  }
}

resource "aws_route_table" "epam_route_table" {
  vpc_id = aws_vpc.epam_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name    = "epam_route_table"
    Project = "epam"
    Type    = "Network"
  }
}

resource "aws_route_table_association" "epam_rta_a" {
  subnet_id      = aws_subnet.epam_subnet_a.id
  route_table_id = aws_route_table.epam_route_table.id
}

resource "aws_route_table_association" "epam_rta_b" {
  subnet_id      = aws_subnet.epam_subnet_b.id
  route_table_id = aws_route_table.epam_route_table.id
}
