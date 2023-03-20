
resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "kp" {
  key_name   = "lssv"       # Create an SSH key for the LightSail Salt Vault instnace
  public_key = tls_private_key.pk.public_key_openssh

  provisioner "local-exec" { # Write the pem file to your computer! You'll need this!
    command = "echo '${tls_private_key.pk.private_key_pem}' > ./lssv.pem"
  }
}


# Create a new Lightsail Instance
resource "aws_lightsail_instance" "myhost" {
  name              = "lssv"
  availability_zone = "us-west-2a"
  blueprint_id      = var.blueprint_id
  bundle_id         = var.bundle_id
  key_pair_name     = "lssv"
  tags = {
    Name = "lssv",
    Description = "Lightsail, Salt, Vault"
  }
}
