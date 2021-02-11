variable "region" {
  default = "us-east-1"
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "~/.ssh/foundry-vtt.pem"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "~/.ssh/foundry-vtt.pub"
}

variable "MOUNT_DEVICE" {
  default = "/dev/xvdh"
}

variable "HOSTNAME" {
  default = "foundry.twotheleft.com"
}

variable "ZONE" {
  default = "twotheleft.com."
}

variable "PORT" {
  default = "8080"
}

variable "CERT_EMAIL" {
  default = "jmeekhof@twotheleft.com"
}
