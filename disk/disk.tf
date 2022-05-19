resource "aws_ebs_volume" "foundry_volume" {
  size              = 4
  type              = "gp2"
  availability_zone = "${var.REGION}a"
  snapshot_id       = var.SNAP_ID

  tags = {
    Name = "Foundry-VTT"
  }
}
