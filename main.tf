# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "jenkins_pub_ubun" {
  key_name   = "jenkins-pub-ubun"
  public_key = file("~/.ssh/id_rsa.pub")  # Replace with the path to your public key file
}

# ssh -i ~/.ssh/id_rsa ubuntu@

resource "aws_security_group" "terra_jenkins_sg" {
  vpc_id = "vpc-09caa6ee9c5b42fa5"

  ingress {
    description = "Allow SSH into instance"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow access through all port into instance"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all traffi to eixt"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  tags = {
    Name = "terra-jenkins-sg"
  }
}

resource "aws_instance" "jenkins_instance" {
  ami                     = "ami-0e86e20dae9224db8"
  instance_type           = "t2.micro"
  key_name                = aws_key_pair.jenkins_pub_ubun.key_name
  vpc_security_group_ids  = [aws_security_group.terra_jenkins_sg.id]
  tags = {
    Name = "jenkins-instance"
  }
}

output "instance_public_ip" {
  value = aws_instance.jenkins_instance.public_ip
}