data "template_file" "user_data" {
    template = file("./userdata.sh")
}

resource "aws_instance" "harbor" {
  ami           = "ami-0f8c6c25f59ebfed1"
  instance_type = "t3.medium"
  vpc_security_group_ids = [ 
    aws_security_group.cicd-sg.id,
   ]
  subnet_id = aws_subnet.cicd_public[0].id
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  root_block_device {
    volume_size = 90
    volume_type = "gp3"
  }
  key_name = var.ec2_key_name

  user_data = base64encode(data.template_file.user_data.rendered)
  tags = {
      Name = "harbor"
  }
  depends_on = [
    aws_iam_role_policy_attachment.EC2ContainerRegistryPowerUser,
 ]
}

resource "aws_instance" "jenkins" {
  ami           = "ami-0bbb50e83433280ad"
  instance_type = "t3.medium"
  vpc_security_group_ids = [ 
    aws_security_group.cicd-sg.id,
   ]
  subnet_id = aws_subnet.cicd_public[1].id
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  
  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }
  key_name = var.ec2_key_name

  user_data = base64encode(data.template_file.user_data.rendered)
  tags = {
      Name = "jenkins"
  }
  depends_on = [
    aws_iam_role_policy_attachment.EC2ContainerRegistryPowerUser,
 ]
}

resource "aws_eip" "harbor" {
  instance = aws_instance.harbor.id
  vpc      = true
}

resource "aws_eip" "jenkins" {
  instance = aws_instance.jenkins.id
  vpc      = true
}