
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