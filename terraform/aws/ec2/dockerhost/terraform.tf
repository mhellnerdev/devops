/* Declare provider and region */

provider "aws" {
  profile    = "default"
  region     = var.region
}

/* Declare S3 and DynamoDB backend */

terraform {
  backend "s3" {
    bucket = "circlelabs-terraform-states" // .tfstate file gets stored in S3
    key = "ec2-dockerhost.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-lock" // dynamodb lock that prevents modification of .tf file while in and UP state
  }
}

############################################################
/* Declare AWS EC2 Docker Host */
############################################################

resource "aws_instance" "dockerhost" {
  ami           = var.ami // ubuntu linux
  instance_type = var.instancetype
  key_name      = var.useastkeyname
  vpc_security_group_ids = ["sg-002d15a754884e25e"] // WebDMZ
  tags = {
  Name = "dockerhost"
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
    user     = var.username
    private_key = file(var.useastprvkey)
    host     = self.public_ip
  }

/* Remote commands - Install Ansible, Docker, and dependencies */

  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt-get install software-properties-common -y",
      "sudo hostnamectl set-hostname dockerhost",
      "sudo hostnamectl",
      "sudo apt-add-repository ppa:ansible/ansible -y",
      "sudo apt-get update -y",
      "sudo apt-get install ansible -y",
      "sudo apt-get install docker.io -y",
      "sudo apt-get install docker-compose -y",
      "sudo mkdir -p ~/circlelabs/portainer",
      "sudo wget -P ~/circlelabs/portainer/ https://downloads.portainer.io/docker-compose.yml",
      "sudo docker-compose -f ~/circlelabs/portainer/docker-compose.yml up -d",
      "sudo git clone git://github.com/mhellnerdev/devops.git",
    ]
  }

/*  Copy private key to new server. Must run terrform apply as sudo */      
    
    provisioner "file" {
      source = var.useastprvkey
      destination = "/home/ubuntu/.ssh/mhellnerdev-us-east-kp.pem"
  }

}
  
/* Declare and assign elastic IP to instance */
 
resource "aws_eip" "terraform-ip" {
    vpc = true
    instance = aws_instance.dockerhost.id
} 
