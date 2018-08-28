provider "aws" {
    region = "us-west-1"
}

resource "aws_instance" "example" {
  ami = "ami-059e7901352ebaef8"
  instance_type = "t3.nano"
}