output "ebs_address" {
  value = "${aws_elb.web.dns_name}"
}
output "ec_public_ip" {
    value = "${join(",", aws_instance.web.*.public_ip)}"
}
output "ec_private_ip" {
    value = "${join(",", aws_instance.web.*.ip)}"
}
