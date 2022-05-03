# AWS Virtual Private Cloud

## Configures AWS provider


resource "aws_vpc" "vpc_cicd" {
  cidr_block = var.cicd_vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  assign_generated_ipv6_cidr_block = var.assign_generated_ipv6_cidr_block
  instance_tenancy = var.instance_tenancy
  tags = {
      Name = format(
        "%s-%s-CICD-VPC",
        var.company,
        var.environment
      )
  }
}
resource "aws_internet_gateway" "cicd_igw" {
  vpc_id = aws_vpc.vpc_cicd.id
  tags = {
      Name = format(
        "%s-%s-CICD-IGW",
        var.company,
        var.environment
      )
  }
}
# resource "aws_eip" "eip_for_nat" {
#   depends_on = [aws_route_table.public] 
#   count = local.nat_gateway_count 
#   tags = {
#     Name = format(
#       "%s-%s-NAT-%s",
#       var.company,
#       var.environment,
#       element(split("", local.public_subnets[count.index].zone), length(local.public_subnets[count.index].zone) - 1)
#     )
#   }
# }
# resource "aws_nat_gateway" "nat_gw" {
#   depends_on = [aws_eip.eip_for_nat] 
#   count = local.nat_gateway_count
#   allocation_id = aws_eip.eip_for_nat[count.index].id
#   subnet_id = aws_subnet.public[count.index].id
#   tags = {
#      Name = format(
#          "%s-%s-NAT-%s",
#          var.company,
#          var.environment,
#          element(split("", local.public_subnets[count.index].zone), length(local.public_subnets[count.index].zone) - 1)
#      )
#    }
# }
resource "aws_subnet" "cicd_public" {
  count             = length(local.cicd_public_subnets)
  vpc_id            = aws_vpc.vpc_cicd.id
  cidr_block        = local.cicd_public_subnets[count.index].cidr
  availability_zone = local.cicd_public_subnets[count.index].zone
  map_public_ip_on_launch = true
  tags = {
     Name = format(
         "%s-%s-cicd-%s-%s",
         var.company,
         var.environment,
         local.cicd_public_subnets[count.index].purpose,
         element(split("", local.cicd_public_subnets[count.index].zone), length(local.cicd_public_subnets[count.index].zone) - 1)
     )
     "kubernetes.io/role/elb" = "1"  # Refer: https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.1/deploy/subnet_discovery/
     "kubernetes.io/cluster/${var.cluster_name}" = "owned"
   }
}
resource "aws_route_table_association" "cicd_public" {
  count = length(aws_subnet.cicd_public)
  subnet_id      = aws_subnet.cicd_public[count.index].id
  route_table_id = aws_route_table.cicd_public.id
}

resource "aws_route_table" "cicd_public" {
  depends_on = [aws_internet_gateway.cicd_igw] 
  lifecycle {
    ignore_changes = [route]
  }

  vpc_id = aws_vpc.vpc_cicd.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cicd_igw.id
  }

  tags = {
    Name = format(
        "%s-%s-cicd-rt-pub",
        var.company,
        var.environment
    )
  }
}
