#!/bin/bash
# install jenkins
sudo yum update -y
sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum upgrade
sudo amazon-linux-extras install java-openjdk11 -y
sudo yum install jenkins -y
sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

# install harbor
sudo yum install -y docker
sudo systemctl enable docker.service
sudo systemctl start docker.service

# jenkins user permission to docker
sudo usermod -aG docker jenkins
sudo service jenkins restart