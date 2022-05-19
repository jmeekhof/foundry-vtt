data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "foundry" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.foundry_key.key_name
  user_data = templatefile("init.tpl",
    {
      device = var.MOUNT_DEVICE
      port   = var.PORT
      host   = var.HOSTNAME
      email  = var.CERT_EMAIL
    }
  )
  security_groups   = [aws_security_group.http-https-traffic.name]
  availability_zone = "${var.region}a"
  tags = {
    Name = "Foundry-VTT"
  }
}

resource "aws_ebs_volume" "foundry_software" {
  size              = 4
  type              = "gp2"
  availability_zone = "${var.region}a"

  tags = {
    Name = "Foundry-VTT"
  }
}

resource "aws_volume_attachment" "ebs_software" {
  device_name  = var.MOUNT_DEVICE
  volume_id    = aws_ebs_volume.foundry_software.id
  instance_id  = aws_instance.foundry.id
  skip_destroy = true

}


output "example_ip" {
  value = aws_instance.foundry.public_ip
}

