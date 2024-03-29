locals {
  aws_region        = lookup(yamldecode(file("${path.module}/variable.yaml"))["configiration"], "aws_region", {})
  aws_instance_dev  = lookup(yamldecode(file("${path.module}/variable.yaml"))["configiration"]["dev"], "aws_instance", {})
  aws_instance_prod = lookup(yamldecode(file("${path.module}/variable.yaml"))["configiration"]["prod"], "aws_instance", {})
}


provider "aws" {
  region = local.aws_region.region
}

resource "aws_instance" "example_dev" {
  ami                    = lookup(local.aws_instance_dev, "ami")
  instance_type          = lookup(local.aws_instance_dev, "instance_type")
  key_name               = lookup(local.aws_instance_dev, "key_name")
  vpc_security_group_ids = [lookup(local.aws_instance_dev, "vpc_security_group_ids")]
  subnet_id              = lookup(local.aws_instance_dev, "subnet_id")
  root_block_device {
    volume_size = lookup(local.aws_instance_dev, "volume_size")
  }

  tags = merge(local.aws_instance_dev.tags, {
    Name = format("%s-%s-%s-bastion-host", local.aws_instance_dev.tags["id"], local.aws_instance_dev.tags["environment"], local.aws_instance_dev.tags["project"])
  })
}

resource "aws_instance" "example_prod" {
  ami                    = lookup(local.aws_instance_prod, "ami")
  instance_type          = lookup(local.aws_instance_prod, "instance_type")
  key_name               = lookup(local.aws_instance_prod, "key_name")
  vpc_security_group_ids = [lookup(local.aws_instance_prod, "vpc_security_group_ids")]
  subnet_id              = lookup(local.aws_instance_prod, "subnet_id")
  root_block_device {
    volume_size = lookup(local.aws_instance_prod, "volume_size")
  }

  tags = merge(local.aws_instance_prod.tags, {
    Name = format("%s-%s-%s-bastion-host", local.aws_instance_prod.tags["id"], local.aws_instance_prod.tags["environment"], local.aws_instance_prod.tags["project"])
  })
}