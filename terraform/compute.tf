resource "aws_key_pair" "tf_auth" {
  key_name   = "${var.key_name}"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDpeJ7J8UqhmUWbvSzSVqFZ3p68O8Gs/nGw7l9oOBXbuvUkjXsscfCS1wwqM6mbo68WMpD0zVLYgEsHtaKT4IinnQTlHETQZ14ym1D2eswrkmlse+auXzSxKWCZu6Y/0XKgISuyzx6ggB+k5DcXzxl3eFlnhQSUGiqt+dcKsgfHpbpMs2qk3Lnr+tjPMKqu1ma+QjvvQOtD5ZzGzh/hNT2feuGTgslOhWacdRvCNvVhqu83e+AlOnKD2kS27NDdEklaWdqzfKnhXRPQK5iHNmPaS6GTwL+LxQuN++4bIgq6N+ABUUppqVWATIQ9kuGGw6sfU4V8Q4GGtFfqpr/5EJBgClzkTiOJCr6k+0wafK+pKg5WnxfNimiD8n58DgFU+KI+XseEWUphrRue312p8BAVDpnhlCH2px5vN7RLMxyeJBXRHeUAmEijPV1eMef89/FPrS8xRaZR7dpWHOaU5rXS82wToq4dvfB3hGQEyAn+9YueL/rFvxWwQlJjhMoLFteaeY8QDnxWZa9EL//i4TmzeOb+VLUGyt9LH0/gq1YeN81FpPw+pdZyERyCJZuM4mQrUi/e1OlLvFacB5OyC41BYu8rBq8bUIXC3756K2NxSLzj005DBhuWtLNKWjhKLFU2zw/XxHaK43TLtr5WtfL4Xi+21qReqx5Nsd666FUmTQ== slucas@newrelic.com"
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
              docker build -t shannon-website .
              docker run -d -p 80:8080 shannon-website
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

