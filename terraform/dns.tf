resource "aws_route53_zone" "myzone" {
  name = "shannonlucas.info"
}

resource "aws_route53_record" "www" {
  zone_id = "${aws_route53_zone.myzone.zone_id}"
  name    = "www"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_instance.tf_instance.public_dns}"]
}

resource "aws_route53_record" "a" {
  zone_id = "${aws_route53_zone.myzone.zone_id}"
  name    = "shannonlucas.info"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.tf_instance.public_ip}"]
}
