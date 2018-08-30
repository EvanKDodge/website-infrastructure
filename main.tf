variable "server_port" {
    description = "port for HTTP requests"
    default = 8888
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
    key_name = "nocal"
    vpc_security_group_ids = ["${aws_security_group.instance.id}"]

    user_data = <<-EOF
                #!/bin/bash
                apt-get -y update
                apt-get -y upgrade
                apt-get -y install git
                curl -fsSL get.docker.com | sh
                git clone https://github.com/EvanKDodge/website.git /var/www/html
                docker container run --name web1 -v /var/www/html:/usr/share/nginx/html -p "${var.server_port}":80 -d nginx
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

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
