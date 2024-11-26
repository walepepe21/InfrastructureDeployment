# configured aws provider with proper credentials
provider "aws" {
  region    = "us-east-1"
  profile   = "pepe"
}

terraform {
  backend "s3" {
    bucket = "pepe-jenkins"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

# create default vpc if one does not exit
resource "aws_default_vpc" "default_vpc" {

  tags    = {
    Name  = "default vpc"
  }
}


# use data source to get all avalablility zones in region
data "aws_availability_zones" "available_zones" {}


# create default subnet if one does not exit
resource "aws_default_subnet" "default_az1" {
  availability_zone = data.aws_availability_zones.available_zones.names[0]

  tags   = {
    Name = "default subnet"
  }
}


# create security group for the ec2 instance
resource "aws_security_group" "ec2_security_group" {
  name        = "ec2 security group"
  description = "allow access on ports 8080 and 22"
  vpc_id      = aws_default_vpc.default_vpc.id

  # allow access on port 8080
  ingress {
    description      = "http proxy access"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  # allow access on port 22
  ingress {
    description      = "ssh access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags   = {
    Name = "jenkins server security group"
  }
}


# use data source to get a registered amazon linux 2 ami
data "aws_ami" "ubuntu" {

    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"]
}

# launch the ec2 instance
resource "aws_instance" "ec2_instance" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.small"
  subnet_id              = aws_default_subnet.default_az1.id
  vpc_security_group_ids = [aws_security_group.ec2_security_group.id]
  key_name               = "devopskeypair"
  user_data = "${file("install_jenkins.sh")}"

  tags = {
    Name = "jenkins_server"
  }
}


# # an empty resource block
# resource "null_resource" "name" {

#   # ssh into the ec2 instance 
#   connection {
#     type        = "ssh"
#     user        = "ubuntu"
#     private_key = file("~/Downloads/devopskeypair.pem")
#     host        = aws_instance.ec2_instance.public_ip
#   }

#   # copy the install_jenkins.sh file from your computer to the ec2 instance 
#   provisioner "file" {
#     source      = "install_jenkins.sh"
#     destination = "/tmp/install_jenkins.sh"
#   }

#   # set permissions and run the install_jenkins.sh file
#   provisioner "remote-exec" {
#     inline = [
#         "sudo chmod +x /tmp/install_jenkins.sh",
#         "sh /tmp/install_jenkins.sh",
#     ]
#   }

#   # wait for ec2 to be created
#   depends_on = [aws_instance.ec2_instance]
# }


# print the url of the jenkins server
output "website_url" {
  value     = join ("", ["http://", aws_instance.ec2_instance.public_dns, ":", "8080"])
}
