
#vpc
resource "aws_vpc" "vpc" {
  cidr_block = "192.168.0.0/16"
  enable_dns_hostnames = null
  enable_dns_support = null

  tags = {
    Name = "nike_vpc"
  }
}

#Internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "nike_igw"
  }
}

#Public Subnet
resource "aws_subnet" "public_subnet_1" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "192.168.1.0/24"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = null
  tags = {
    Name = "nike_subnet_ap_south_1a"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "192.168.2.0/24"
  availability_zone = "ap-south-1b"
  map_public_ip_on_launch = null
  tags = {
    Name = "nike_subnet_ap_south_1b"
  }
}

#Database subnet
resource "aws_subnet" "database_subnet_1" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "192.168.5.0/24"
  availability_zone = "available"
  map_public_ip_on_launch = false
  tags = {
    Name = "nike_database_subnet_az_1a"
  }
}
resource "aws_subnet" "database_subnet_2" {
   vpc_id = aws_vpc.vpc.id
  cidr_block = "192.168.6.0/24"
  availability_zone = "available"
  map_public_ip_on_launch = false
  tags = {
    Name = "nike_database_subnet_az_1b"
  }
}

#Public routes
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "nike_public_route_table"
  }
}

#mapping igw entry to public route table
resource "aws_route" "public_internet_gateway" {
  route_table_id = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}

#Database route table
resource "aws_route_table" "database_route_table" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "nike_database_route_table"
  }
}

#Route table associations with subnets
resource "aws_route_table_association" "public_route_table_association_1" {
  subnet_id = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}
resource "aws_route_table_association" "public_route_table_association_2" {
  subnet_id = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}
resource "aws_route_table_association" "database_route_table_association_1" {
  subnet_id = aws_subnet.database_subnet_1.id
  route_table_id = aws_route_table.database_route_table.id
}
resource "aws_route_table_association" "database_route_table_association_2" {
  subnet_id = aws_subnet.database_subnet_2.id
  route_table_id = aws_route_table.database_route_table.id
}

#Security group
resource "aws_security_group" "sg" {
  name = "nike_security_group"
  description = "Allow all inbound traffic"
  vpc_id = aws_vpc.vpc.id

  ingress = [
    {
      description      = "All traffic"
      from_port        = 0    # All ports
      to_port          = 0    # All Ports
      protocol         = "-1" # All traffic
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  ]

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      description      = "Outbound rule"
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  ]

  tags = {
    Name = "nike_security_group"
}
}