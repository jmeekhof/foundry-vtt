resource "aws_key_pair" "foundry_vtt_key" {
  key_name   = "foundry_vtt_key"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}
