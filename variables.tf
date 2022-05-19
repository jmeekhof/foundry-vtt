variable "REGION" {
  type        = string
  description = "The default zone to use"
}

variable "PATH_TO_PRIVATE_KEY" {
  type        = string
  description = "Path to the private key"
}

variable "PATH_TO_PUBLIC_KEY" {
  type        = string
  description = "Path to the public key"
}

variable "MOUNT_DEVICE" {
  type        = string
  description = "The location that the EBS device is located on the file system"
  default     = "/dev/xvdh"
}

variable "HOSTNAME" {
  type        = string
  description = "The desired DNS name for the instance"
}

variable "ZONE" {
  type        = string
  description = "The DNS zone that the HOSTNAME will use"
}

variable "PORT" {
  type    = string
  default = "8080"
}

variable "CERT_EMAIL" {
  type        = string
  description = "The email address to use when negotiating the SSL cert"
}

variable "PROFILE" {
  type        = string
  description = "The aws profile to use"
  default     = "default"
}
