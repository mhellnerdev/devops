provider "aws" {

}

variable "AWS_REGION" {
    type = string
}

variable "AMIS" {
    type = map(string)
    default = {
        us-east-1 = "my ami"
    }
}

resource "aws_instance" "Terraform-Variables" {
    ami             = var.AMIS[var.AWS_REGION]
    instance_type   = "t2.micro"
    }