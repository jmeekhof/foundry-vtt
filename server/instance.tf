resource "aws_instance" "foundry_instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.foundry_vtt_key.key_name
  user_data = templatefile("init.tpl",
    {
      device = var.MOUNT_DEVICE
      port   = var.PORT
      host   = var.HOSTNAME
      email  = var.CERT_EMAIL
    }
  )
  security_groups   = [aws_security_group.http-https-traffic.name]
  availability_zone = "${var.REGION}a"
  tags = {
    Name = "Foundry-VTT"
  }
}

resource "aws_volume_attachment" "ebs_software" {
  device_name  = var.MOUNT_DEVICE
  volume_id    = data.aws_ebs_volume.foundry_vol.id
  instance_id  = aws_instance.foundry_instance.id
  skip_destroy = true

}

output "public_ip" {
  value = aws_instance.foundry_instance.public_ip
}
