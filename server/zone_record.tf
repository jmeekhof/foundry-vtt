resource "aws_route53_record" "foundry" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "foundry.${data.aws_route53_zone.selected.name}"
  type    = "CNAME"
  ttl     = 300
  records = [aws_instance.foundry.public_dns]
}
