terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "Region"
  type        = string
  default     = "us-east-2"
  validation {
    condition     = contains(["us-east-1", "us-east-2"], lower(var.aws_region))
    error_message = "We only allow Resources to be created in us-east-1 or us-east-2 Regions."
  }
}

resource "aws_instance" "example" {
  ami                    = "ami-0fc5d935ebf8bc3bc"
  instance_type          = "t2.micro"
  key_name               = "terraform-aws"
  vpc_security_group_ids = ["sg-0c51540c60857b7ed"]
  subnet_id              = "subnet-096d45c28d9fb4c14"
  root_block_device {
    volume_size = "10"
  }
  tags = {
    Name      = "vm"
    Create_By = "Terraform"
  }
}

