output "vpc" {
  value = "${aws_vpc.tf_vpc.id}"
}

output "igw" {
  value = "${aws_internet_gateway.tf_internet_gateway.id}"
}

output "route_table" {
  value = "${aws_route_table.tf_public_rt.id}"
}

output "subnet" {
  value = "${aws_subnet.tf_public_subnet.id}"
}

output "subnet_cidr" {
  value = "${aws_subnet.tf_public_subnet.cidr_block}"
}

output "sec_group" {
  value = "${aws_security_group.tf_public_sg.id}"
}

output "instance_public_ip" {
  value = "${aws_instance.tf_instance.public_ip}"
}

output "instance_public_dns" {
  value = "${aws_instance.tf_instance.public_dns}"
}
