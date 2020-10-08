resource "aws_key_pair" "tf_auth" {
  key_name   = "${var.key_name}"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCjkXYeymU3lLYtsudfz6U/F7ZZK3UK5gPLGpsZeT/gqMwtBO7cGIlrrF1Ys/t8pZQm8bdcWtL90xIu7JEuYIWs4opdJ6MvHjLIslM0zdMX7wy4/NfcJMoa/V/vQ9hyJKgNskoCjn3Lqbom6dFt4WaIbSsSj/aBbWdhIJtPKcRA4lkOgdNWBh1VZFRCGsX+dKKxMabJDSEvxERDGlITasIt1puf3+SxMKwyF2vikIQcptn6QqeixbUnc5s0Plif0fYo+m6Msxt8Pl6xyhkAv0pU7PitgBhW9+iYGU+kMiCAZC7S2PI5309wtlwxwu21Yl3dKzHUhr5Ff5vFeKXaLyud shannonlucas@Shannons-MacBook-Pro.local"
}

resource "aws_instance" "tf_instance" {
  ami           = "${var.aws_ami}"
  instance_type = "t2.micro"

  key_name                    = "${aws_key_pair.tf_auth.key_name}"
  vpc_security_group_ids      = ["${aws_security_group.tf_public_sg.id}"]
  subnet_id                   = "${aws_subnet.tf_public_subnet.id}"
  associate_public_ip_address = true
  availability_zone           = "us-west-2a"

  lifecycle {
    create_before_destroy = true
  }

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install git -y
              git clone https://github.com/lucassha/mywebsite.git
              cd mywebsite
              docker build -t shannon-website-"${var.version}" .
              docker run -d -p 80:8080 shannon-website-"${var.version}"
              EOF

  tags {
    Name                 = "tf_ec2"
    created_by_terraform = 1
  }
}

# backup user_data that is 100% functional
# yum update -y
# yum install -y httpd.x86_64
# systemctl start httpd.service
# systemctl enable httpd.service
# echo "Hello World from $(hostname -f)" > /var/www/html/index.html

