
provider "aws" {
  profile    = "default"
  region     = "us-east-1"
}

resource "aws_instance" "terraform-01" {
  ami           = "ami-00dc79254d0461090"
  instance_type = "t2.micro"
  key_name      = "xxxx"
  vpc_security_group_ids = ["sg-002d15a754884e25e"]

  tags = {
  Name = "Terraform-01"
  }

  root_block_device {
    volume_type = "gp2"
    volume_size = "8"
    delete_on_termination = true
    encrypted = true
  }

  connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("~/SSH/xxxx.pem")
    host     = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      
    ]
  }
 provisioner "file" {
    source = "~/SSH/xxxx.pem"
    destination = "/home/ec2-user/.ssh/xxxx.pem"
  }
}
  

resource "aws_eip" "terraform-ip" {
    vpc = true
    instance = aws_instance.terraform-01.id

}

resource "aws_instance" "terraform-02" {
  ami           = "ami-00dc79254d0461090"
  instance_type = "t2.micro"
  key_name      = "xxxx"
  vpc_security_group_ids = ["sg-002d15a754884e25e"]

  tags = {
  Name = "TerraForm-02"
  }
  
  root_block_device {
    volume_type = "gp2"
    volume_size = "8"
    delete_on_termination = true
    encrypted = true
  }
}
