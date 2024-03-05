data "aws_vpc" "vpc_available" {

  filter {
    name   = "tag:Name"
    values = ["nike_vpc"]
  }
}
data "aws_subnets" "available_db_subnet" {
  filter {
    name   = "tag:Name"
    values = ["nike_database*"]
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}
data "aws_security_group" "tcw_sg" {
  filter {
    name   = "tag:Name"
    values = ["nike_security_group"]
  }
}
