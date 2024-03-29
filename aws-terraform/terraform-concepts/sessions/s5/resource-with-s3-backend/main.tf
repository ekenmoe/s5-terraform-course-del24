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
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket         = "2560-development-s5-tf-state"
    key            = "aws-terraform/ec2/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "2560-development-s5-tf-state-lock"
  }
}

resource "aws_instance" "example" {
  ami                    = "ami-0fc5d935ebf8bc3bc"
  instance_type          = "t2.micro"
  key_name               = "terraform-aws"
  vpc_security_group_ids = ["sg-0c51540c60857b7ed"]
  subnet_id              = "subnet-096d45c28d9fb4c14"
  root_block_device {
    volume_size = "20"
  }
  tags = {
    Name      = "tia"
    Create_By = "Terraform"
  }
}