provider "aws" {
  profile = "default"
  region     = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-0cdc271d99924feda"
  instance_type = "t2.micro"
}

