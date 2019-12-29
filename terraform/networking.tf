data "aws_availability_zones" "available" {}

resource "aws_vpc" "tf_vpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags {
    Name                 = "tf_vpc"
    created_by_terraform = 1
  }
}

# attach the igw to your vpc
resource "aws_internet_gateway" "tf_internet_gateway" {
  vpc_id = "${aws_vpc.tf_vpc.id}"

  tags {
    Name                 = "tf_igw"
    created_by_terraform = 1
  }
}

# set up a route table that will allow pub internet traffic
resource "aws_route_table" "tf_public_rt" {
  vpc_id = "${aws_vpc.tf_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.tf_internet_gateway.id}"
  }

  tags {
    Name                 = "tf_rt"
    created_by_terraform = 1
  }
}

# create a subnet where the ec2 instance will reside
resource "aws_subnet" "tf_public_subnet" {
  vpc_id                  = "${aws_vpc.tf_vpc.id}"
  cidr_block              = "${var.public_cidr}"
  map_public_ip_on_launch = true
  availability_zone = "us-west-2a"

  tags {
    Name                 = "tf_public_subnet"
    created_by_terraform = 1
  }
}

# assocate the subnet with the route table. this will make it public
resource "aws_route_table_association" "tf_public_association" {
  subnet_id      = "${aws_subnet.tf_public_subnet.id}"
  route_table_id = "${aws_route_table.tf_public_rt.id}"
}

# create a public security group that allows in ssh and http traffic
resource "aws_security_group" "tf_public_sg" {
  name        = "tf_public_sg"
  description = "Public SG for SSH and HTTP access"
  vpc_id      = "${aws_vpc.tf_vpc.id}"

  # allow ssh traffic in
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # allow http traffic in
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # allow all traffic out 
  # something is jacked up here. need to fix it.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
