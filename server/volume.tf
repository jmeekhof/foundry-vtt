data "aws_ebs_volume" "foundry_vol" {
  most_recent = true
  filter {
    name   = "tag:purpose"
    values = ["foundry"]
  }
}
