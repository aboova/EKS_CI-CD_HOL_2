resource "aws_security_group" "eks_node_group" {
  ingress {
    description = "From My IP"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [local.my_ip_addrs]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = aws_vpc.vpc_main.id
  name = format(
      "%s-%s-eks_node_group-sg",
      var.company,
      var.environment
    )
  description = format(
      "%s-%s-eks_node_group-sg",
      var.company,
      var.environment
    )
  tags = {
    Name = format(
      "%s-%s-eks_node_group-sg",
      var.company,
      var.environment
    )
  }
}