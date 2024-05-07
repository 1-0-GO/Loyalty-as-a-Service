terraform {
  required_version = ">= 1.0.0, < 2.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1" 
}

resource "aws_security_group" "instance" {
  name = var.kafka_security_group

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 2181
    to_port     = 2181
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9092
    to_port     = 9092
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

variable "kafka_security_group" {
  description = "kafka_security_group name"
  type        = string
  default     = "kafka_security_group"
}

resource "aws_instance" "kafka" {
  count                   = 2 // Number of Kafka brokers (2 in this case)
  ami                     = "ami-0cf10cdf9fcd62d37" 
  instance_type           = "t2.small"
  key_name                = "vockey"
  vpc_security_group_ids  = [aws_security_group.instance.id]
  user_data               = "${file("creation.sh")}"

  tags = {
    Name = "Kafka Broker ${count.index}"
  }
}

