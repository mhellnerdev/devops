/* Declare provider and region */

provider "aws" {
  profile    = "default"
  region     = var.region
}

/* Declare S3 and DynamoDB backend */

terraform {
  backend "s3" {
    bucket = "circlelabs-terraform-states" // .tfstate file gets stored in S3
    key = "ec2-simple.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-lock" // dynamodb lock that prevents modification of .tf file while in and UP state
  }
}

############################################################

/* Declare AWS EC2 ANSIBLE CONTROL NODE */

resource "aws_instance" "ansible-control-node" {
  ami           = "ami-04b9e92b5572fa0d1" // ubuntu linux
  instance_type = "t2.micro"
  key_name      = var.useastkeyname
  vpc_security_group_ids = ["sg-002d15a754884e25e"] // WebDMZ
  tags = {
  Name = "ansible-control-node"
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
    user     = "ubuntu"
    private_key = file(var.useastprvkey)
    host     = self.public_ip
  }

/* Remote commands - Install Ansible and dependencies */

  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt-get install software-properties-common -y",
      "sudo apt-add-repository ppa:ansible/ansible -y",
      "sudo apt-get update -y",
      "sudo apt-get install ansible -y"
    ]
  }

/*  Copy private key to new server. Must run terrform apply as sudo */      
    
    provisioner "file" {
      source = "~/SSH/mhellnerdev-us-east-kp.pem"
      destination = "/home/ubuntu/.ssh/mhellnerdev-us-east-kp.pem"
  }

}
  
/* Declare and assign elastic IP to instance
 
resource "aws_eip" "terraform-ip" {
    vpc = true
    instance = aws_instance.terraform-01.id
} 
*/

############################################################

# /* Declare AWS EC2 INVENTORY NODE 01 */

# resource "aws_instance" "ansible-inventory-01" {
#   ami           = "ami-04b9e92b5572fa0d1" // ubuntu linux
#   instance_type = "t2.micro"
#   key_name      = var.useastkeyname
#   vpc_security_group_ids = ["sg-002d15a754884e25e"] // WebDMZ
#   tags = {
#   Name = "ansible-inventory-01"
#   }

#   root_block_device {
#     volume_type = "gp2"
#     volume_size = "8"
#     delete_on_termination = true
#     encrypted = false
#   }

# /* Remote connectection and setup. */

#   connection {
#     type     = "ssh"
#     user     = "ubuntu"
#     private_key = file(var.useastprvkey)
#     host     = self.public_ip
#   }

# /* Remote commands */

#   provisioner "remote-exec" {
#     inline = [
#       "sudo apt update -y"
#     ]
#   }

# /*  Copy private key to new server. Must run terrform apply as sudo */      
    
#     provisioner "file" {
#       source = "~/SSH/mhellnerdev-us-east-kp.pem"
#       destination = "/home/ubuntu/.ssh/mhellnerdev-us-east-kp.pem"
#   }

# }
  
# /* Declare and assign elastic IP to instance
 
# resource "aws_eip" "terraform-ip" {
#     vpc = true
#     instance = aws_instance.terraform-01.id
# } 
# */

# #############################################################

# /* Declare AWS EC2 INVENTORY NODE 02 */

# resource "aws_instance" "ansible-inventory-02" {
#   ami           = "ami-04b9e92b5572fa0d1" // ubuntu linux
#   instance_type = "t2.micro"
#   key_name      = var.useastkeyname
#   vpc_security_group_ids = ["sg-002d15a754884e25e"] // WebDMZ
#   tags = {
#   Name = "ansible-inventory-02"
#   }

#   root_block_device {
#     volume_type = "gp2"
#     volume_size = "8"
#     delete_on_termination = true
#     encrypted = false
#   }

# /* Remote connectection and setup. */

#   connection {
#     type     = "ssh"
#     user     = "ubuntu"
#     private_key = file(var.useastprvkey)
#     host     = self.public_ip
#   }

# /* Remote commands */

#   provisioner "remote-exec" {
#     inline = [
#       "sudo apt update -y"
#     ]
#   }

# /*  Copy private key to new server. Must run terrform apply as sudo */      
    
#     provisioner "file" {
#       source = "~/SSH/mhellnerdev-us-east-kp.pem"
#       destination = "/home/ubuntu/.ssh/mhellnerdev-us-east-kp.pem"
#   }

# }
  
# /* Declare and assign elastic IP to instance
 
# resource "aws_eip" "terraform-ip" {
#     vpc = true
#     instance = aws_instance.terraform-01.id
# } 
# */


# ############################################################

# /* Declare AWS EC2 INVENTORY NODE 03 */

# resource "aws_instance" "ansible-db" {
#   ami           = "ami-04b9e92b5572fa0d1" // ubuntu linux
#   instance_type = "t2.micro"
#   key_name      = var.useastkeyname
#   vpc_security_group_ids = ["sg-002d15a754884e25e"] // WebDMZ
#   tags = {
#   Name = "ansible-db"
#   }

#   root_block_device {
#     volume_type = "gp2"
#     volume_size = "8"
#     delete_on_termination = true
#     encrypted = false
#   }

# /* Remote connectection and setup. */

#   connection {
#     type     = "ssh"
#     user     = "ubuntu"
#     private_key = file(var.useastprvkey)
#     host     = self.public_ip
#   }

# /* Remote commands */

#   provisioner "remote-exec" {
#     inline = [
#       "sudo apt update -y"
#     ]
#   }

# /*  Copy private key to new server. Must run terrform apply as sudo */      
    
#     provisioner "file" {
#       source = "~/SSH/mhellnerdev-us-east-kp.pem"
#       destination = "/home/ubuntu/.ssh/mhellnerdev-us-east-kp.pem"
#   }

# }
  
# /* Declare and assign elastic IP to instance
 
# resource "aws_eip" "terraform-ip" {
#     vpc = true
#     instance = aws_instance.terraform-01.id
# } 
# */
