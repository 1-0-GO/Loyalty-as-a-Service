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

variable "db_username" {
  description = "The username for the database"
  type        = string
  sensitive   = true
  default     = "admin"
}

variable "db_password" {
  description = "The password for the database"
  type        = string
  sensitive   = true
  default     = "Seiadmin123!"
}

variable "db_name" {
  description = "The name to use for the database"
  type        = string
  default     = "Laas"
}

resource "aws_db_instance" "LaasDB" {
  identifier_prefix   = "laas-db"
  engine              = "mysql"
  allocated_storage   = 20
  instance_class      = "db.t3.micro"
  skip_final_snapshot = true
  publicly_accessible = true
  vpc_security_group_ids  = [aws_security_group.rds.id]
  db_name             = var.db_name
  username = var.db_username
  password = var.db_password
}

output "address" {
  value       = aws_db_instance.LaasDB.address
  description = "Connect to the database at this endpoint"
}

output "port" {
  value       = aws_db_instance.LaasDB.port
  description = "The port the database is listening on"
}

resource "aws_security_group" "rds" {
  name = var.security_group_name
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

variable "security_group_name" {
  description = "The name of the security group"
  type        = string
  default     = "rds_security_group"
}