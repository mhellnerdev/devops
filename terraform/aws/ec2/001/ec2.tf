/* Declare provider and region */

provider "aws" {
  profile    = "default"
  region     = var.region
}

/* Declare S3 and DynamoDB backend */

terraform {
  backend "s3" {
    bucket = "circlelabs-terraform-states"
    key = "ec2-simple.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-lock"
  }
}

/* Declare AWS EC2 instance */

resource "aws_instance" "terraform-01" {
  ami           = "ami-00dc79254d0461090" // amazon linux
  instance_type = "t2.micro"
  key_name      = var.useastkeyname
  vpc_security_group_ids = ["sg-002d15a754884e25e"] // WebDMZ
  tags = {
  Name = "Terraform-01"
  }

  root_block_device {
    volume_type = "gp2"
    volume_size = "8"
    delete_on_termination = true
    encrypted = false
  }

/* Remote connectection and setup. */

  connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file(var.useastprvkey)
    host     = self.public_ip
  }

/* Remote commands */

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y"
    ]
  }

/*  Copy private key to new server. Must run terrform apply as sudo */      
    
    provisioner "file" {
      source = "~/SSH/mhellnerdev-us-east-kp.pem"
      destination = "/home/ec2-user/.ssh/mhellnerdev-us-east-kp.pem"
  }

}
  
/* Declare and assign elastic IP to instance */
 
resource "aws_eip" "terraform-ip" {
    vpc = true
    instance = aws_instance.terraform-01.id
}

