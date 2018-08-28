variable "server_port" {
    description = "port for HTTP requests"
    default = 8080
}

output "public_ip" {
  value = "${aws_instance.example.public_ip}"
}


provider "aws" {
    region = "us-west-1"
}

resource "aws_instance" "example" {
    ami = "ami-059e7901352ebaef8"
    instance_type = "t3.nano"
    vpc_security_group_ids = ["${aws_security_group.instance.id}"]

    user_data = <<-EOF
                #!/bin/bash
                sudo apt-get update
                sudo apt-get install git
                git clone git@github.com:EvanKDodge/website.git
                cd website
                nohup busybox httpd -f -p "${var.server_port}" &
                EOF
    
    tags {
        Name = "busybox-test-server"
    }
}

resource "aws_security_group" "instance" {
    name = "busybox-example-instance"

    ingress {
        from_port = "${var.server_port}"
        to_port = "${var.server_port}"
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
