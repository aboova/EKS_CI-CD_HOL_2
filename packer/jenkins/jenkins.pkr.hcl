packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.9"
      source  = "github.com/hashicorp/amazon"
    }
  }

  required_version = ">= 1.8.0, < 2.0.0"
}

source "amazon-ebs" "HOL_Jenkins_AMI" {
  //AMI Configuration
  region = "ap-northeast-2"
  ami_name = "HOL_Jenkins_AMI"
  ami_description = "HOL_Jenkins_AMI, created by jintae lee"
  ami_virtualization_type = "hvm"
  ami_users = ["553260261205"]
  tags = {"Name" : "HOL_Jenkins_AMI"}
  snapshot_tags = {"Name" = "HOL_Jenkins_AMI"}
  //myinstanceprofile = ""

  //Run Configuration
  instance_type = "t3.medium"
  source_ami = "ami-02e05347a68e9c76f"
  associate_public_ip_address = "true"
  availability_zone = "ap-northeast-2a"

  vpc_filter {
    filters = {
      "cidr": "10.50.0.0/16",
      "tag:Name": "isnt-DEV-VPC"
    }
  }

  subnet_filter {
    filters = {
      "tag:ENV": "isnt-DEV-public"
    }
    most_free = true
  }

  security_group_filter {
    filters = {
      "tag:Name": "isnt-DEV-sg-Allopen"
    }
  }
  
  //Access Configuration
  profile = "jtlee"

  //Polling
  // aws_polling {
  //   delay_seconds = 30
  //   max_attempts = 50
  // }

  //SSH Communicator
  communicator = "ssh"
  ssh_username = "ec2-user"

}

build {
  name = "test-build"
  sources = ["source.amazon-ebs.HOL_Jenkins_AMI"]
  
  provisioner "shell" {
    only = ["amazon-ebs.HOL_Jenkins_AMI"] //only or except는 prefix(source)를 생략  
    scripts = fileset(".", "scripts/jenkins_install.sh")
  }

  post-processor "shell-local" {
    inline = ["echo Hello Packer!"]
  }
}