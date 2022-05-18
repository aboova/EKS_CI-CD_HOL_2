# Input locals
############################
## subneting of VPC
locals {
  public_subnets = [
    {
      purpose = "pub-sev"
      zone = "${var.region}a" ## Must be put a AZs alphabet
      cidr = "192.168.0.0/24"
    }, 
    {
      purpose = "pub-sev"
      zone = "${var.region}c"
      cidr = "192.168.1.0/24"
    }
  ]
  # jenkins, harbor용 subnet 추가 - 이재정
  cicd_public_subnets = [
    {
      purpose = "pub-sev"
      zone = "${var.region}a" ## Must be put a AZs alphabet
      cidr = "10.0.0.0/24"
    }, 
    {
      purpose = "pub-sev"
      zone = "${var.region}c"
      cidr = "10.0.1.0/24"
    }
  ]
  # private_subnets = [
  #   {
  #     purpose = "pri-sev"
  #     zone = "${var.region}a"
  #     cidr = "192.168.50.0/24"
  #   },
  #   {
  #     purpose = "pri-sev"
  #     zone = "${var.region}c"
  #     cidr = "192.168.51.0/24"
  #   }
  # ]
  zone_index = {
    "a" = 0,
    "c" = 1
  }
    nat_gateway_count = var.enable_nat ? var.single_nat ? 1 : length(local.public_subnets) : 0
}

resource "random_string" "random" {
  length    = 4
  special   = false
  lower     = true #true
  upper     = false
  min_lower = 4
}

locals {
  my_ip_addrs = join("", [local.ifconfig_co_json.ip, "/32"])
}

data "http" "my_auto_ip_addr" {
  url = try("https://ifconfig.co/json", "")
  request_headers = {
    Accept = "application/json"
  }
}
locals {
  ifconfig_co_json = jsondecode(data.http.my_auto_ip_addr.body)
}