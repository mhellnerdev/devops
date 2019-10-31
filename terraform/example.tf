provider "aws" {
  profile    = "default"
  region     = "us-east-1"
}

resource "aws_instance" "terraform-01" {
  ami           = "ami-0b69ea66ff7391e80"
  instance_type = "t2.micro"
  key_name      = "mhellnerdev-us-east-kp"
  vpc_security_group_ids = ["sg-002d15a754884e25e"]

  tags = {
  Name = "Hello TerraForm"
  }

  root_block_device {
    volume_type = "gp2"
    volume_size = "8"
    delete_on_termination = true
    encrypted = true
  }

}

resource "aws_instance" "terraform-02" {
  ami           = "ami-0b69ea66ff7391e80"
  instance_type = "t2.micro"
  key_name      = "mhellnerdev-us-east-kp"
  vpc_security_group_ids = ["sg-002d15a754884e25e"]

  tags = {
  Name = "Goodbye TerraForm"
  }
  
  root_block_device {
    volume_type = "gp2"
    volume_size = "8"
    delete_on_termination = true
    encrypted = true
  }

}
