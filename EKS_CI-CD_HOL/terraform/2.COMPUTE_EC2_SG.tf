resource "aws_security_group" "jenkins-sg" {
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Communication test"
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Communication test"
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Communication test"
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Communication test"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Communication test"
  }
  vpc_id = aws_vpc.vpc_cicd.id
  name = format(
    "%s-%s-jenkins-sg",
    var.company,
    var.environment
  )
  description = format(
    "%s-%s-jenkins-sg",
    var.company,
    var.environment
  )
  tags = {
    Name = format(
      "%s-%s-jenkins-sg",
      var.company,
      var.environment
    )
  }
}

resource "aws_security_group" "harbor-sg" {
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Communication test"
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Communication test"
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Communication test"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Communication test"
  }
  vpc_id = aws_vpc.vpc_cicd.id
  name = format(
    "%s-%s-harbor-sg",
    var.company,
    var.environment
  )
  description = format(
    "%s-%s-harbor-sg",
    var.company,
    var.environment
  )
  tags = {
    Name = format(
      "%s-%s-harbor-sg",
      var.company,
      var.environment
    )
  }
}