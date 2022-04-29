resource "aws_security_group" "cicd-sg" {
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
    from_port   = 4443
    to_port     = 4443
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
    "%s-%s-cicd-sg",
    var.company,
    var.environment
  )
  description = format(
    "%s-%s-cicd-sg",
    var.company,
    var.environment
  )
  tags = {
    Name = format(
      "%s-%s-cicd-sg",
      var.company,
      var.environment
    )
  }
}